/*
============================================================================================
   This class points to outside MATLAB data which contains info about the FEM element data.
   It will also create a DoF numbering for that element.
   
   NOTE: portions of this code are automatically generated!
   
   Copyright (c) 05-21-2013,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set the type of element
#define ELEM_Name        "Elem3_Test"
// set allocator class name
#define EDA               Elem3_Test_DoF_Allocator
// set nodal topology data type name
#define NODAL_TOPOLOGY    Elem3_Test_nodal_top

// set the number of DoF sets
#define Num_Vtx_Sets        2
#define Num_Edge_Sets       2
#define Num_Face_Sets       0
#define Num_Tet_Sets        0

// set the max number (over all sets) of DoFs per entity per set
#define Max_DoF_Per_Vtx     1
#define Max_DoF_Per_Edge    2
#define Max_DoF_Per_Face    0
#define Max_DoF_Per_Tet     0

// set the total number of DoFs per entity
#define Num_DoF_Per_Vtx     2
#define Num_DoF_Per_Edge    4
#define Num_DoF_Per_Face    0
#define Num_DoF_Per_Tet     0

// set the TOTAL number of DoFs per cell (element)
#define Total_DoF_Per_Cell  18
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
// set (intrinsic) dimension and domain
#define Dimension    2
#define Domain_str  "triangle"

// set the number of vertices
#define NUM_VTX    3
// set the number of edges
#define NUM_EDGE   3
// set the number of faces
#define NUM_FACE   1
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
    void  Fill_DoF_Map  (TRIANGLE_EDGE_SEARCH*);
    int  Assign_Vtx_DoF (TRIANGLE_EDGE_SEARCH*, const int);
    int  Assign_Edge_DoF(TRIANGLE_EDGE_SEARCH*, const int);
    int  Assign_Face_DoF(TRIANGLE_EDGE_SEARCH*, const int);
    int  Assign_Tet_DoF (TRIANGLE_EDGE_SEARCH*, const int);
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
    Node.V[1][3][1] = 3; // Set1, V3

    Node.V[2][1][1] = 16; // Set2, V1
    Node.V[2][2][1] = 17; // Set2, V2
    Node.V[2][3][1] = 18; // Set2, V3

    Node.E[1][1][1] = 4; // Set1, E1
    Node.E[1][1][2] = 7; // Set1, E1
    Node.E[1][2][1] = 5; // Set1, E2
    Node.E[1][2][2] = 8; // Set1, E2
    Node.E[1][3][1] = 6; // Set1, E3
    Node.E[1][3][2] = 9; // Set1, E3

    Node.E[2][1][1] = 10; // Set2, E1
    Node.E[2][1][2] = 13; // Set2, E1
    Node.E[2][2][1] = 11; // Set2, E2
    Node.E[2][2][2] = 14; // Set2, E2
    Node.E[2][3][1] = 12; // Set2, E3
    Node.E[2][3][2] = 15; // Set2, E3



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
void EDA::Fill_DoF_Map(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search)
{
    // output what we are doing
    printf("Generating DoFs on ");
    printf(Domain);
    printf("s for the Finite Element: ");
    printf(Name);
    printf(".\n");

    // write the local to global DoF mapping
    int DoF_Offset = 0;
    DoF_Offset = Assign_Vtx_DoF (Tri_Edge_Search, DoF_Offset);
    DoF_Offset = Assign_Edge_DoF(Tri_Edge_Search, DoF_Offset);
    DoF_Offset = Assign_Face_DoF(Tri_Edge_Search, DoF_Offset);
    DoF_Offset = Assign_Tet_DoF (Tri_Edge_Search, DoF_Offset);
    Error_Check_DoF_Map(Tri_Edge_Search->Num_Tri);
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the vertex DoFs */
int EDA::Assign_Vtx_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)
                        const int              DoF_Offset)
{
    // for every vertex, store the first triangle (with local vertex index) that allocated DoFs for it
    vector<int> Vtx_to_Tri[2];
    Vtx_to_Tri[0].resize((unsigned int)(Tri_Edge_Search->Max_Vtx_Index+1),-1); // init to NULL value
    Vtx_to_Tri[1].resize((unsigned int)(Tri_Edge_Search->Max_Vtx_Index+1),-1); // init to NULL value

    int Vtx_DoF_Counter = DoF_Offset;
    // allocate DoFs for the global vertices that are actually present
    if (Num_DoF_Per_Vtx > 0)
        {
        int VTX_COUNT = 0; // keep track of the number of unique vertices
        for (int ti=0; ti < Tri_Edge_Search->Num_Tri; ti++)
            {
            // loop thru all vertices of each triangle
            for (int vtxi=0; vtxi < NUM_VTX; vtxi++)
                {
                const unsigned int Vertex = (unsigned int) Tri_Edge_Search->Tri_DoF[vtxi][ti];
                const int tri_ind         =     ti;
                const int vtx_ind         = vtxi+1; // put into MATLAB-style indexing
                // if this vertex has NOT been visited yet
                if (Vtx_to_Tri[0][Vertex]==-1)
                    {
                    VTX_COUNT++;

                    // remember which triangle is associated with this vertex
                    Vtx_to_Tri[0][Vertex] = tri_ind;
                    // remember the local vertex
                    Vtx_to_Tri[1][Vertex] = vtx_ind;

                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: add more DoFs
                    Vtx_DoF_Counter++;
                    cell_dof[ Node.V[1][vtx_ind][1] ][ti] = Vtx_DoF_Counter;
                    // Set 2: add more DoFs
                    Vtx_DoF_Counter++;
                    cell_dof[ Node.V[2][vtx_ind][1] ][ti] = Vtx_DoF_Counter;
                    /*------------   END: Auto Generate ------------*/
                    }
                else
                    {
                    const int old_ti      = Vtx_to_Tri[0][Vertex];
                    const int old_vtx_ind = Vtx_to_Tri[1][Vertex];

                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: copy over DoFs
                    cell_dof[ Node.V[1][vtx_ind][1] ][ti] = cell_dof[ Node.V[1][old_vtx_ind][1] ][old_ti];
                    // Set 2: copy over DoFs
                    cell_dof[ Node.V[2][vtx_ind][1] ][ti] = cell_dof[ Node.V[2][old_vtx_ind][1] ][old_ti];
                    /*------------   END: Auto Generate ------------*/
                    }
                }
            }
        // store the number of unique vertices
        Tri_Edge_Search->Num_Unique_Vertices = VTX_COUNT;
        }
    return Vtx_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the edge DoFs */
int EDA::Assign_Edge_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)
                         const int              DoF_Offset)
{
    int Edge_DoF_Counter = DoF_Offset;
    // allocate DoFs for the edges in the triangulation
    if (Num_DoF_Per_Edge > 0)
        {
        // temp storage for DoFs on edge
        int SE_DoF[Num_Edge_Sets+1][Max_DoF_Per_Edge+1];
        // initialize to NULL value
        for (int ind1=0; ind1 < Num_Edge_Sets+1; ind1++)
        for (int ind2=0; ind2 < Max_DoF_Per_Edge+1; ind2++)
            SE_DoF[ind1][ind2] = -1;

        // initialize previous edge to NULL
        EDGE_TO_CELL Prev_EI;
        Prev_EI.edge_info[0] = -1;
        Prev_EI.edge_info[1] = -1;
        Prev_EI.edge_info[2] = -1;
        Prev_EI.edge_info[3] = 0;

        std::vector<EDGE_TO_CELL>::iterator ei; // need iterator
        int EDGE_COUNT = 0;
        for (ei=Tri_Edge_Search->Edge_List.begin(); ei!=Tri_Edge_Search->Edge_List.end(); ++ei)
            {
            const EDGE_TO_CELL Current_EI = *ei;
            const bool NEW_EDGE = (Prev_EI.edge_info[0]!=Current_EI.edge_info[0]) || (Prev_EI.edge_info[1]!=Current_EI.edge_info[1]);
            const unsigned int cell_index = (unsigned int) Current_EI.edge_info[2];
            const int local_edge_index = Current_EI.edge_info[3];

            // if this edge has NOT been visited yet
            if (NEW_EDGE)
                {
                EDGE_COUNT++;
                Prev_EI = Current_EI; // update previous

                // allocate new DoF's
                /*------------ BEGIN: Auto Generate ------------*/
                // Set 1: add more DoFs
                Edge_DoF_Counter++;
                SE_DoF[1][1] = Edge_DoF_Counter;
                Edge_DoF_Counter++;
                SE_DoF[1][2] = Edge_DoF_Counter;
                // Set 2: add more DoFs
                Edge_DoF_Counter++;
                SE_DoF[2][1] = Edge_DoF_Counter;
                Edge_DoF_Counter++;
                SE_DoF[2][2] = Edge_DoF_Counter;
                /*------------   END: Auto Generate ------------*/
                }
            else
                {
                // if the same edge is contained in the same cell as the previous
                if (Prev_EI.edge_info[2]==cell_index)
                    {
                    // then, this should not happen!
                    mexPrintf("An edge appears more than once, and referenced to the same cell,\n");
                    mexPrintf("        in an internal list of this sub-routine!\n");
                    mexPrintf("This should never happen!\n");
                    mexPrintf("Please report this bug!\n");
                    mexErrMsgTxt("STOP!\n");
                    }
                }

            // allocate DoFs on edge in positive order
            if (local_edge_index>0)
                {
                /*------------ BEGIN: Auto Generate ------------*/
                // Set 1:
                cell_dof[ Node.E[1][local_edge_index][1] ][cell_index] = SE_DoF[1][1];
                cell_dof[ Node.E[1][local_edge_index][2] ][cell_index] = SE_DoF[1][2];
                // Set 2:
                cell_dof[ Node.E[2][local_edge_index][1] ][cell_index] = SE_DoF[2][1];
                cell_dof[ Node.E[2][local_edge_index][2] ][cell_index] = SE_DoF[2][2];
                /*------------   END: Auto Generate ------------*/
                }
            // allocate DoFs on edge in negative order
            if (local_edge_index<0)
                {
                /*------------ BEGIN: Auto Generate ------------*/
                // Set 1:
                cell_dof[ Node.E[1][-local_edge_index][2] ][cell_index] = SE_DoF[1][1];
                cell_dof[ Node.E[1][-local_edge_index][1] ][cell_index] = SE_DoF[1][2];
                // Set 2:
                cell_dof[ Node.E[2][-local_edge_index][2] ][cell_index] = SE_DoF[2][1];
                cell_dof[ Node.E[2][-local_edge_index][1] ][cell_index] = SE_DoF[2][2];
                /*------------   END: Auto Generate ------------*/
                }
            }
        // store the number of unique edges
        Tri_Edge_Search->Num_Unique_Edges = EDGE_COUNT;
        }
    return Edge_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the face DoFs */
int EDA::Assign_Face_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)
                         const int              DoF_Offset)
{
    int Face_DoF_Counter = DoF_Offset;
    // special case: there are 1-to-N triangles (no gaps in numbering)
    if (Num_DoF_Per_Face > 0)
        {
        // allocate DoFs for the faces (triangles) in the mesh
        for (int ti=0; ti < Tri_Edge_Search->Num_Tri; ti++)
            {
            const int face_ind = 1; // there is only 1 face in 2D
            /*------------ BEGIN: Auto Generate ------------*/
            // Set 1: add more DoFs
            /*------------   END: Auto Generate ------------*/
            }
        }
    return Face_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the tet DoFs */
int EDA::Assign_Tet_DoF(TRIANGLE_EDGE_SEARCH*  Tri_Edge_Search,   // inputs (list of triangles)
                        const int              DoF_Offset)
{
    int Tet_DoF_Counter = DoF_Offset;
    // special case: there are no tets in 2D
    if (Num_DoF_Per_Tet > 0)
        {
        // this should not run!
        }
    return Tet_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* perform error checks on FEM DoF map */
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
