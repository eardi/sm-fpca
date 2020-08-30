/*
============================================================================================
   This class points to outside MATLAB data which contains info about the
   finite element data.  It will also create a DoF numbering for that element.
   
   NOTE: portions of this code are automatically generated!
   
   Copyright (c) 10-16-2016,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set the type of element
#define ELEM_Name        "lagrange_deg1_dim1"
// set allocator class name
#define EDA               lagrange_deg1_dim1_DoF_Allocator
// set nodal topology data type name
#define NODAL_TOPOLOGY    lagrange_deg1_dim1_nodal_top
// set permutation map data type names
#define SINGLE_EDGE_PERM_MAP    lagrange_deg1_dim1_single_edge_perm_map
#define EDGE_DOF_PERMUTATION    lagrange_deg1_dim1_edge_dof_perm
#define SINGLE_FACE_PERM_MAP    lagrange_deg1_dim1_single_face_perm_map
#define FACE_DOF_PERMUTATION    lagrange_deg1_dim1_face_dof_perm

// set the number of DoF sets
#define Num_Vtx_Sets        1
#define Num_Edge_Sets       0
#define Num_Face_Sets       0
#define Num_Tet_Sets        0

// set the max number (over all sets) of DoFs per entity per set
#define Max_DoF_Per_Vtx     1
#define Max_DoF_Per_Edge    0
#define Max_DoF_Per_Face    0
#define Max_DoF_Per_Tet     0

// set the total number of DoFs per entity
#define Num_DoF_Per_Vtx     1
#define Num_DoF_Per_Edge    0
#define Num_DoF_Per_Face    0
#define Num_DoF_Per_Tet     0

// set the TOTAL number of DoFs per cell (element)
#define Total_DoF_Per_Cell  2
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
// set (intrinsic) dimension and domain
#define Dimension    1
#define Domain_str  "interval"

// set the number of vertices
#define NUM_VTX    2
// set the number of edges
#define NUM_EDGE   1
// set the number of faces
#define NUM_FACE   0
// set the number of tetrahedrons
#define NUM_TET    0
/*------------   END: Auto Generate ------------*/

/***************************************************************************************/
// data structure containing information on the local element DoF numbering
typedef struct
{
    int  V[Num_Vtx_Sets +1][NUM_VTX +1][Max_DoF_Per_Vtx +1];    // nodes associated with each vertex
    int  E[Num_Edge_Sets+1][NUM_EDGE+1][Max_DoF_Per_Edge+1];    // nodes associated with each edge
    int  F[Num_Face_Sets+1][NUM_FACE+1][Max_DoF_Per_Face+1];    // nodes associated with each face
    int  T[Num_Tet_Sets +1][NUM_TET +1][Max_DoF_Per_Tet +1];    // nodes associated with each tetrahedron
}
NODAL_TOPOLOGY;

/***************************************************************************************/
class EDA
{
public:
    char*    Name;              // name of finite element space
    int      Dim;               // intrinsic dimension
    char*    Domain;            // type of domain: "interval", "triangle", "tetrahedron"

    NODAL_TOPOLOGY   Node;      // Nodal DoF arrangment

    EDA ();  // constructor
    ~EDA (); // DE-structor
    mxArray* Init_DoF_Map(int);
    void  Fill_DoF_Map  (EDGE_POINT_SEARCH*);
    int  Assign_Vtx_DoF (EDGE_POINT_SEARCH*, const int);
    int  Assign_Edge_DoF(EDGE_POINT_SEARCH*, const int);
    int  Assign_Face_DoF(EDGE_POINT_SEARCH*, const int);
    int  Assign_Tet_DoF (EDGE_POINT_SEARCH*, const int);
    void  Error_Check_DoF_Map(const int&);

private:
    int*  cell_dof[Total_DoF_Per_Cell+1];
};

/***************************************************************************************/
/* constructor */
EDA::EDA ()
{
    // setup
    Name              = (char *) ELEM_Name;
    Dim               = Dimension;
    Domain            = (char *) Domain_str;

/*------------ BEGIN: Auto Generate ------------*/
    // nodal DoF arrangement
    Node.V[1][1][1] = 1; // Set1, V1
    Node.V[1][2][1] = 2; // Set1, V2




/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
EDA::~EDA ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* initialize FEM DoF map to all zeros */
mxArray* EDA::Init_DoF_Map(int  Num_Cell)     // output to MATLAB
{
    mxArray* DoF_Map;

    // BEGIN: allocate and access output data
    DoF_Map = mxCreateNumericMatrix((mwSize)Num_Cell, (mwSize)Total_DoF_Per_Cell, mxUINT32_CLASS, mxREAL);
    // access the data
    // split up the columns of the data
    cell_dof[0] = NULL; // not used!
    cell_dof[1] = (int *) mxGetPr(DoF_Map);
    for (int i = 2; (i <= Total_DoF_Per_Cell); i++) // note: off by one because of C-style indexing!
        cell_dof[i] = cell_dof[i-1] + Num_Cell;
    // END: allocate and access output data

    return DoF_Map;
}
/***************************************************************************************/


/***************************************************************************************/
/* assign DoFs */
void EDA::Fill_DoF_Map(EDGE_POINT_SEARCH*  Edge_Point_Search)
{
    // output what we are doing
    printf("Generating DoFs on ");
    printf(Domain);
    printf("s for the Finite Element: ");
    printf(Name);
    printf(".\n");

    // write the local to global DoF mapping
    int DoF_Offset = 0;
    DoF_Offset = Assign_Vtx_DoF (Edge_Point_Search, DoF_Offset);
    DoF_Offset = Assign_Edge_DoF(Edge_Point_Search, DoF_Offset);
    DoF_Offset = Assign_Face_DoF(Edge_Point_Search, DoF_Offset);
    DoF_Offset = Assign_Tet_DoF (Edge_Point_Search, DoF_Offset);
    Error_Check_DoF_Map(Edge_Point_Search->Num_Edge);
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the vertex DoFs */
int EDA::Assign_Vtx_DoF(EDGE_POINT_SEARCH*  Edge_Point_Search,   // inputs (list of edges)
                        const int           DoF_Offset)
{
    // for every vertex, store the first edge (with local vertex index) that allocated DoFs for it
    vector<int> Vtx_to_Edge[2];
    Vtx_to_Edge[0].resize((unsigned int)(Edge_Point_Search->Max_Vtx_Index+1),-1); // init to NULL value
    Vtx_to_Edge[1].resize((unsigned int)(Edge_Point_Search->Max_Vtx_Index+1),-1); // init to NULL value

    int Vtx_DoF_Counter = DoF_Offset;
    // allocate DoFs for the global vertices that are actually present
    if (Num_DoF_Per_Vtx > 0)
        {
        int VTX_COUNT = 0; // keep track of the number of unique vertices
        for (int ei=0; ei < Edge_Point_Search->Num_Edge; ei++)
            {
            // loop thru all vertices of each edge
            for (int vtxi=0; vtxi < NUM_VTX; vtxi++)
                {
                const unsigned int Vertex = (unsigned int) Edge_Point_Search->Edge_DoF[vtxi][ei];
                const int edge_ind        =     ei;
                const int  vtx_ind        = vtxi+1; // put into MATLAB-style indexing
                // if this vertex has NOT been visited yet
                if (Vtx_to_Edge[0][Vertex]==-1)
                    {
                    VTX_COUNT++;

                    // remember which edge is associated with this vertex
                    Vtx_to_Edge[0][Vertex] = edge_ind;
                    // remember the local vertex
                    Vtx_to_Edge[1][Vertex] = vtx_ind;

                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: add more DoFs
                    Vtx_DoF_Counter++;
                    cell_dof[ Node.V[1][vtx_ind][1] ][ei] = Vtx_DoF_Counter;
                    /*------------   END: Auto Generate ------------*/
                    }
                else
                    {
                    const int old_ei      = Vtx_to_Edge[0][Vertex];
                    const int old_vtx_ind = Vtx_to_Edge[1][Vertex];

                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: copy over DoFs
                    cell_dof[ Node.V[1][vtx_ind][1] ][ei] = cell_dof[ Node.V[1][old_vtx_ind][1] ][old_ei];
                    /*------------   END: Auto Generate ------------*/
                    }
                }
            }
        // store the number of unique vertices
        Edge_Point_Search->Num_Unique_Vertices = VTX_COUNT;
        }
    return Vtx_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the edge DoFs */
int EDA::Assign_Edge_DoF(EDGE_POINT_SEARCH*  Edge_Point_Search,   // inputs (list of edges)
                         const int           DoF_Offset)
{
    int Edge_DoF_Counter = DoF_Offset;
    // special case: there are 1-to-N edges (no gaps in numbering)
    if (Num_DoF_Per_Edge > 0)
        {
        // allocate DoFs for the edges in the mesh
        for (int ei=0; ei < Edge_Point_Search->Num_Edge; ei++)
            {
            const int edge_ind = 1; // there is only 1 edge in 1D

            /*------------ BEGIN: Auto Generate ------------*/
            // Set 1: add more DoFs
            /*------------   END: Auto Generate ------------*/
            }
        }
    return Edge_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the face DoFs */
int EDA::Assign_Face_DoF(EDGE_POINT_SEARCH*  Edge_Point_Search,   // inputs (list of edges)
                         const int           DoF_Offset)
{
    int Face_DoF_Counter = DoF_Offset;
    // special case: there are no faces in 1D
    if (Num_DoF_Per_Face > 0)
        {
        // this should not run!
        }
    return Face_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the tet DoFs */
int EDA::Assign_Tet_DoF(EDGE_POINT_SEARCH*  Edge_Point_Search,   // inputs (list of edges)
                        const int           DoF_Offset)
{
    int Tet_DoF_Counter = DoF_Offset;
    // special case: there are no tets in 1D
    if (Num_DoF_Per_Tet > 0)
        {
        // this should not run!
        }
    return Tet_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* perform error checks on Finite Element Degree-of-Freedom (DoF) map */
void EDA::Error_Check_DoF_Map(const int&  Num_Cell)
{
    // BEGIN: error check
    const unsigned int LENGTH = Total_DoF_Per_Cell*Num_Cell;
    const unsigned int MIN_DoF = *min_element(cell_dof[1], cell_dof[1]+LENGTH);
    if (MIN_DoF < 1)
        {
        mexPrintf("ERROR: DoFmap references DoF with index 0!\n");
        mexPrintf("ERROR: Some DoFs were never allocated!\n");
        mexErrMsgTxt("ERROR: Make sure your mesh describes a domain that is a manifold!");
        }
    // END: error check
}
/***************************************************************************************/


#undef ELEM_Name
#undef EDA
#undef NODAL_TOPOLOGY
#undef SINGLE_EDGE_PERM_MAP
#undef EDGE_DOF_PERMUTATION
#undef SINGLE_FACE_PERM_MAP
#undef FACE_DOF_PERMUTATION
#undef Dimension
#undef Domain_str

#undef NUM_VTX
#undef NUM_EDGE
#undef NUM_FACE
#undef NUM_TET

#undef Num_Vtx_Sets
#undef Num_Edge_Sets
#undef Num_Face_Sets
#undef Num_Tet_Sets

#undef Max_DoF_Per_Vtx
#undef Max_DoF_Per_Edge
#undef Max_DoF_Per_Face
#undef Max_DoF_Per_Tet

#undef Num_DoF_Per_Vtx
#undef Num_DoF_Per_Edge
#undef Num_DoF_Per_Face
#undef Num_DoF_Per_Tet

#undef Total_DoF_Per_Cell

/***/
