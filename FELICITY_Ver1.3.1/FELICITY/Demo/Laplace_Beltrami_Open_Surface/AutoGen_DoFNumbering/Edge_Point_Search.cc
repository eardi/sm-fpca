/*
============================================================================================
   This class points to outside MATLAB data which contains info about the mesh.
   It also searches the triangulation and finds the edges of each triangle.

   Copyright (c) 05-28-2013,  Shawn W. Walker
============================================================================================
*/

/*** C++ class ***/
#define EPS EDGE_POINT_SEARCH
class EPS
{
public:
    int      Num_Edge;             // number of edges
    int      Max_Vtx_Index;        // largest vertex index in the edge DoF list
    int      Num_Unique_Vertices;  // number of distinct vertices in the edge mesh
    int*     Edge_DoF[2];          // edge DoF list

    EPS (); // constructor
    ~EPS ();   // DE-structor
    void Setup_Mesh(const mxArray*);
};

/***************************************************************************************/
/* constructor */
EPS::EPS ()
{
    // init everything else to zero
    Num_Edge            = 0;
    Max_Vtx_Index       = 0;
    Num_Unique_Vertices = 0;
    for (int i = 0; (i < 2); i++)
        Edge_DoF[i] = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
EPS::~EPS ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void EPS::Setup_Mesh(const mxArray* Edge)      // inputs (list of edges)
{
    // get the number of edges
    Num_Edge = (int) mxGetM(Edge);
    // get the number of DoFs for each edge
    int CHK_Num_Edge_DoF = (int) mxGetN(Edge);


    /* BEGIN: Error Checking */
    if (mxGetClassID(Edge)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Edge List must be uint32!");
    if (CHK_Num_Edge_DoF!=2)
        {
        mexPrintf("ERROR: Edge List has %d columns; expected 2 columns.\n", CHK_Num_Edge_DoF);
        mexErrMsgTxt("ERROR: need 2 nodes to specify an edge!");
        }
    /* END: Error Checking */


    // split up the columns of the edge data
    Edge_DoF[0] = (int *) mxGetPr(Edge);
    for (int i = 1; (i < 2); i++)
        Edge_DoF[i] = Edge_DoF[i-1] + Num_Edge;

    // get the maximum vertex index in the edge list
    Max_Vtx_Index  = max_array(Edge_DoF[0], 2*Num_Edge);
}
/***************************************************************************************/

#undef EPS

/***/
