/*
============================================================================================
   This class points to outside MATLAB data which contains info about the mesh.
   It also searches the triangulation and finds all edges of the triangulation.

   Copyright (c) 05-27-2013,  Shawn W. Walker
============================================================================================
*/

#include <vector>

/***************************************************************************************/
// a struct for holding edge data
typedef struct
{
    int   edge_info[4];
    // edge_info[0,1]: the indices of the vertices of the edge (sorted ascending order)
    //                 note: these index into the global vertex list
    // edge_info[2]:   index of the triangle (cell) that contains the edge
    // edge_info[3]:   local edge index in the enclosing cell;  value: +/- 1,2,3
}
EDGE_TO_CELL;

// comparison
bool compare_e2c (EDGE_TO_CELL first, EDGE_TO_CELL second)
{
    if (first.edge_info[0] < second.edge_info[0])
        return true;
    else if (first.edge_info[0] > second.edge_info[0])
        return false;
    else
        {
        if (first.edge_info[1] < second.edge_info[1])
            return true;
        else if (first.edge_info[1] > second.edge_info[1])
            return false;
        else
            {
            if (first.edge_info[2] < second.edge_info[2])
                return true;
            else
                return false;
            }
        }
}
/***************************************************************************************/

/*** C++ class ***/
#define TES TRIANGLE_EDGE_SEARCH
class TES
{
public:
    int      Num_Tri;              // number of triangles
    int      Max_Vtx_Index;        // largest vertex index in the triangle DoF list
    int      Num_Unique_Vertices;  // number of distinct vertices in the triangulation
    int*     Tri_DoF[3];           // triangle DoF list

    // used for finding all the edges in the mesh
    std::vector<EDGE_TO_CELL>   Edge_List;
    int                         Num_Unique_Edges;

    TES (); // constructor
    ~TES ();   // DE-structor
    void Setup_Mesh(const mxArray*);
    void Ensure_Ordered_Edge(EDGE_TO_CELL&);
};

/***************************************************************************************/
/* constructor */
TES::TES ()
{
    // init everything else to zero
    Num_Tri             = 0;
    Max_Vtx_Index       = 0;
    Num_Unique_Vertices = 0;
    Num_Unique_Edges    = 0;
	Edge_List.clear();
    for (int i = 0; (i < 3); i++)
        Tri_DoF[i] = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
TES::~TES ()
{
	Edge_List.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct */
void TES::Setup_Mesh(const mxArray* mxTri)        // inputs (list of triangles)
{
    // get the number of triangles
    Num_Tri = (int) mxGetM(mxTri);
    // get the number of DoFs for each triangle
    int CHK_Num_Tri_DoF = (int) mxGetN(mxTri);


    /* BEGIN: Error Checking */
    if (mxGetClassID(mxTri)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Triangle List must be uint32!");
    if (CHK_Num_Tri_DoF!=3)
        {
        mexPrintf("ERROR: Triangle List has %d columns; expected 3 columns.\n", CHK_Num_Tri_DoF);
        mexErrMsgTxt("ERROR: need 3 nodes to specify a triangle!");
        }
    /* END: Error Checking */


    // split up the columns of the triangle data
    Tri_DoF[0] = (int *) mxGetPr(mxTri);
    for (int i = 1; (i < 3); i++)
        Tri_DoF[i] = Tri_DoF[i-1] + Num_Tri;

    // get the maximum vertex index in the triangulation
    Max_Vtx_Index  = max_array(Tri_DoF[0], 3*Num_Tri);

    // collect all the edges of the triangulation
    Edge_List.reserve(3*Num_Tri);
    for (int tri_ind = 0; tri_ind < Num_Tri; tri_ind++)
        {
		// read in the vertices of the current triangle
        const int V1 = Tri_DoF[0][tri_ind];
        const int V2 = Tri_DoF[1][tri_ind];
        const int V3 = Tri_DoF[2][tri_ind];

        EDGE_TO_CELL  EI;
        // local edge 1
        EI.edge_info[0] = V2;
        EI.edge_info[1] = V3;
        EI.edge_info[2] = tri_ind;
        EI.edge_info[3] = 1;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 2
        EI.edge_info[0] = V3;
        EI.edge_info[1] = V1;
        EI.edge_info[2] = tri_ind;
        EI.edge_info[3] = 2;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 3
        EI.edge_info[0] = V1;
        EI.edge_info[1] = V2;
        EI.edge_info[2] = tri_ind;
        EI.edge_info[3] = 3;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        }
    std::sort(Edge_List.begin(), Edge_List.end(), compare_e2c);
}
/***************************************************************************************/


/***************************************************************************************/
/* this ensures that EI.edge_info[0] < EI.edge_info[1] and adjusts EI.edge_info[3]
   to have the correct sign so that the orientation of the stored edge matches the
   orientation of the edge in the enclosing cell. */
void TES::Ensure_Ordered_Edge(EDGE_TO_CELL& EI)     // input to be modified
{
    const int TEMP_0 = EI.edge_info[0];
    const int TEMP_1 = EI.edge_info[1];

    if (TEMP_0 > TEMP_1)
        {
        // swap the order
        EI.edge_info[0] = TEMP_1;
        EI.edge_info[1] = TEMP_0;
        EI.edge_info[3] = -EI.edge_info[3]; // change the sign to record the relative orientation
        }
    else if (TEMP_0==TEMP_1)
        {
        mexPrintf("This edge is not correct:\n");
        mexPrintf("edge data = [%d, %d]\n",TEMP_0,TEMP_1);
        mexPrintf("enclosing cell index = %d\n",EI.edge_info[2]);
        mexPrintf("oriented local edge index = %d\n",EI.edge_info[3]);
        mexPrintf("\n");
        mexPrintf("The tail and head vertex index of an edge *cannot* be the same!\n");
        mexErrMsgTxt("Your input triangulation is incorrect!");
        }
    // else do nothing
}
/***************************************************************************************/

#undef TES

/***/
