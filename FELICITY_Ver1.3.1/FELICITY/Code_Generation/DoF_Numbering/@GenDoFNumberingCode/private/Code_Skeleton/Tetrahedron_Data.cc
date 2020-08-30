/*
============================================================================================
   This class points to outside MATLAB data which contains info about the mesh.
   It also searches the triangulation and finds all edges and faces of the triangulation.

   Copyright (c) 05-29-2013,  Shawn W. Walker
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
    // edge_info[2]:   index of the tetrahedron (cell) that contains the edge
    // edge_info[3]:   local edge index in the enclosing cell;  value: +/- 1,2,3,4,5,6
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

/***************************************************************************************/
// a struct for holding face data
typedef struct
{
    unsigned int face_info[6];
    // face_info[0,1,2]: the indices of the vertices of the face (sorted ascending order)
    //                   note: these index into the global vertex list
    // face_info[3]:     index of the tetrahedron (cell) that contains the face
    // face_info[4]:     local face index in the enclosing cell;  value: 1,2,3,4
	// face_info[5]:     permutation index (1,2,3,4,5,6) indicating how to permute the 
	//                   face vertices so they are in ascending order.
	//                   see below for more info.
}
FACE_TO_CELL;

// comparison
bool compare_f2c (FACE_TO_CELL first, FACE_TO_CELL second)
{
    if (first.face_info[0] < second.face_info[0])
        return true;
    else if (first.face_info[0] > second.face_info[0])
        return false;
    else
        {
        if (first.face_info[1] < second.face_info[1])
            return true;
        else if (first.face_info[1] > second.face_info[1])
            return false;
        else
            {
			if (first.face_info[2] < second.face_info[2])
				return true;
			else if (first.face_info[2] > second.face_info[2])
				return false;
			else
				{
				if (first.face_info[3] < second.face_info[3])
					return true;
				else
					return false;
				}
            }
        }
}
/***************************************************************************************/

/*** C++ class ***/
#define TD TETRAHEDRON_DATA
class TD
{
public:
    int      Num_Tet;              // number of tetrahedra
    int      Num_Edge;             // number of mesh edges
    int      Max_Vtx_Index;        // largest vertex index in the tet DoF list
    int      Num_Unique_Vertices;  // number of distinct vertices in the triangulation

    int*     Tet_DoF[4];        // tetrahedra DoF list
	
    // used for finding all the edges in the mesh
    std::vector<EDGE_TO_CELL>   Edge_List;
    int                         Num_Unique_Edges;

    // used for finding all the edges in the mesh
    std::vector<FACE_TO_CELL>   Face_List;
    int                         Num_Unique_Faces;

    TD (); // constructor
    ~TD ();   // DE-structor
    void Setup_Mesh(const mxArray*);
	//unsigned int Determine_Edge_NOT_To_Swap_In_Face(const unsigned int&, const unsigned int&);

private:
	void Ensure_Ordered_Edge(EDGE_TO_CELL&);
	void Ensure_Ordered_Face(FACE_TO_CELL&);
	void Face_Error_Msg(FACE_TO_CELL&);
};

/***************************************************************************************/
/* constructor */
TD::TD ()
{
    // init everything else to zero
    Num_Tet             = 0;
    Num_Edge            = 0;
    Max_Vtx_Index       = 0;
	Num_Unique_Vertices = 0;
	Num_Unique_Edges    = 0;
	Num_Unique_Faces    = 0;
	Edge_List.clear();
	Face_List.clear();
    for (int i = 0; (i < 4); i++)
        Tet_DoF[i] = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
TD::~TD ()
{
	Edge_List.clear();
	Face_List.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void TD::Setup_Mesh(const mxArray* Tet)
{
    // get the number of tets
    Num_Tet = (int) mxGetM(Tet);
    // get the number of DoFs for each tet
    int CHK_Num_Tet_DoF = (int) mxGetN(Tet);


    /* BEGIN: Error Checking */
    if (mxGetClassID(Tet)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Tetrahedra List must be uint32!");
    if (CHK_Num_Tet_DoF!=4)
        {
        mexPrintf("ERROR: Tetrahedra List has %d columns; expected 4 columns.\n", CHK_Num_Tet_DoF);
        mexErrMsgTxt("ERROR: need 4 nodes to specify a tetrahedron!");
        }
    /* END: Error Checking */


    // split up the columns of the tet data
    Tet_DoF[0] = (int *) mxGetPr(Tet);
    for (int i = 1; (i < 4); i++)
        Tet_DoF[i] = Tet_DoF[i-1] + Num_Tet;

    // get the maximum vertex index in the triangulation
    Max_Vtx_Index  = max_array(Tet_DoF[0], 4*Num_Tet);
	
    // collect all the edges and faces of the triangulation
    Edge_List.reserve(6*Num_Tet);
	Face_List.reserve(4*Num_Tet);
    for (int tet_ind = 0; tet_ind < Num_Tet; tet_ind++)
        {
		// read in the vertices of the current tetrahedron
        const int V1 = Tet_DoF[0][tet_ind];
        const int V2 = Tet_DoF[1][tet_ind];
        const int V3 = Tet_DoF[2][tet_ind];
		const int V4 = Tet_DoF[3][tet_ind];

        EDGE_TO_CELL  EI;
        // local edge 1
        EI.edge_info[0] = V1;
        EI.edge_info[1] = V2;
        EI.edge_info[2] = tet_ind;
        EI.edge_info[3] = 1;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 2
        EI.edge_info[0] = V1;
        EI.edge_info[1] = V3;
        EI.edge_info[2] = tet_ind;
        EI.edge_info[3] = 2;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 3
        EI.edge_info[0] = V1;
        EI.edge_info[1] = V4;
        EI.edge_info[2] = tet_ind;
        EI.edge_info[3] = 3;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 4
        EI.edge_info[0] = V2;
        EI.edge_info[1] = V3;
        EI.edge_info[2] = tet_ind;
        EI.edge_info[3] = 4;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 5
        EI.edge_info[0] = V3;
        EI.edge_info[1] = V4;
        EI.edge_info[2] = tet_ind;
        EI.edge_info[3] = 5;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
        // local edge 6
        EI.edge_info[0] = V4;
        EI.edge_info[1] = V2;
        EI.edge_info[2] = tet_ind;
        EI.edge_info[3] = 6;
        Ensure_Ordered_Edge(EI);
        Edge_List.push_back(EI);
		
        FACE_TO_CELL  FI;
        // local face 1
        FI.face_info[0] = (unsigned int) V2;
        FI.face_info[1] = (unsigned int) V3;
		FI.face_info[2] = (unsigned int) V4;
        FI.face_info[3] = (unsigned int) tet_ind;
        FI.face_info[4] = 1;
        Ensure_Ordered_Face(FI);
        Face_List.push_back(FI);
        // local face 2
        FI.face_info[0] = (unsigned int) V1;
        FI.face_info[1] = (unsigned int) V4;
		FI.face_info[2] = (unsigned int) V3;
        FI.face_info[3] = (unsigned int) tet_ind;
        FI.face_info[4] = 2;
        Ensure_Ordered_Face(FI);
        Face_List.push_back(FI);
        // local face 3
        FI.face_info[0] = (unsigned int) V1;
        FI.face_info[1] = (unsigned int) V2;
		FI.face_info[2] = (unsigned int) V4;
        FI.face_info[3] = (unsigned int) tet_ind;
        FI.face_info[4] = 3;
        Ensure_Ordered_Face(FI);
        Face_List.push_back(FI);
        // local face 4
        FI.face_info[0] = (unsigned int) V1;
        FI.face_info[1] = (unsigned int) V3;
		FI.face_info[2] = (unsigned int) V2;
        FI.face_info[3] = (unsigned int) tet_ind;
        FI.face_info[4] = 4;
        Ensure_Ordered_Face(FI);
        Face_List.push_back(FI);
        }
    std::sort(Edge_List.begin(), Edge_List.end(), compare_e2c);
	std::sort(Face_List.begin(), Face_List.end(), compare_f2c);
}
/***************************************************************************************/


/***************************************************************************************/
/* this ensures that EI.edge_info[0] < EI.edge_info[1] and adjusts EI.edge_info[3]
   to have the correct sign so that the orientation of the stored edge matches the
   orientation of the edge in the enclosing cell. */
void TD::Ensure_Ordered_Edge(EDGE_TO_CELL& EI)     // input to be modified
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


/***************************************************************************************/
/* this ensures that FI.face_info[0] < FI.face_info[1] < FI.face_info[2] and sets
   FI.face_info[5] = the permutation index that records how the face vertices were
   rearranged to obtain the above ordering. */
// Define the 6 permutations:
// NOTE: this is the same format as in the m-file:
//       "Elem_DoF_Allocator_class_declaration_3D_tetrahedron.m"
//        under "GenDoFNumberingCode\private\"
/* face_perm = [1 2 3;  % 1
                3 1 2;  % 2
                2 3 1;  % 3
                3 2 1;  % 4
                2 1 3;  % 5
                1 3 2]; % 6
   Note: indices are local vertex indices (indexed from 1);
         subtract "1" to get C-style indexing
*/
void TD::Ensure_Ordered_Face(FACE_TO_CELL& FI)     // input to be modified
{
    const unsigned int V0 = FI.face_info[0];
    const unsigned int V1 = FI.face_info[1];
	const unsigned int V2 = FI.face_info[2];

    if (V0 > V1)
        {
		if (V1 > V2)
			{
			// order the vertices in increasing order
			FI.face_info[0] = V2; // 3
			FI.face_info[1] = V1; // 2
			FI.face_info[2] = V0; // 1
			// record permutation
			FI.face_info[5] = 4;
			}
		else if (V1 < V2)
			{
			if (V0 > V2)
				{
				// order the vertices in increasing order
				FI.face_info[0] = V1; // 2
				FI.face_info[1] = V2; // 3
				FI.face_info[2] = V0; // 1
				// record permutation
				FI.face_info[5] = 3;
				}
			else if (V0 < V2)
				{
				// order the vertices in increasing order
				FI.face_info[0] = V1; // 2
				FI.face_info[1] = V0; // 1
				FI.face_info[2] = V2; // 3
				// record permutation
				FI.face_info[5] = 5;
				}
			else
				Face_Error_Msg(FI);
			}
		else
			Face_Error_Msg(FI);
        }
	else if (V0 < V1)
        {
		if (V1 > V2)
			{
			if (V0 > V2)
				{
				// order the vertices in increasing order
				FI.face_info[0] = V2; // 3
				FI.face_info[1] = V0; // 1
				FI.face_info[2] = V1; // 2
				// record permutation
				FI.face_info[5] = 2;
				}
			else if (V0 < V2)
				{
				// order the vertices in increasing order
				FI.face_info[0] = V0; // 1
				FI.face_info[1] = V2; // 3
				FI.face_info[2] = V1; // 2
				// record permutation
				FI.face_info[5] = 6;
				}
			else
				Face_Error_Msg(FI);
			}
		else if (V1 < V2)
			{
			// no change needed! already ordered: [1 2 3]
			// record permutation
			FI.face_info[5] = 1;
			}
		else
			Face_Error_Msg(FI);
        }
    else
		Face_Error_Msg(FI);
}
/***************************************************************************************/


/***************************************************************************************/
/* this outputs an error message about the given face */
void TD::Face_Error_Msg(FACE_TO_CELL& FI)     // input to be modified
{
	mexPrintf("This face is not correct:\n");
	mexPrintf("face data = [%d, %d, %d]\n",FI.face_info[0],FI.face_info[1],FI.face_info[2]);
	mexPrintf("enclosing cell index = %d\n",FI.face_info[3]);
	mexPrintf("oriented local face index = %d\n",FI.face_info[4]);
	mexPrintf("\n");
	mexPrintf("All three vertices of a face must be distinct!\n");
	mexErrMsgTxt("Your input triangulation is incorrect!");
}
/***************************************************************************************/

#undef TD

/***/
