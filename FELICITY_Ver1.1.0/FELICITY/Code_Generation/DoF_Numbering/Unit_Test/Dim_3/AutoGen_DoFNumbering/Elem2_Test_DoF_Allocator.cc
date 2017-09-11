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
#define ELEM_Name        "Elem2_Test"
// set allocator class name
#define EDA               Elem2_Test_DoF_Allocator
// set nodal topology data type name
#define NODAL_TOPOLOGY    Elem2_Test_nodal_top

// set the number of DoF sets
#define Num_Vtx_Sets        0
#define Num_Edge_Sets       1
#define Num_Face_Sets       0
#define Num_Tet_Sets        0

// set the max number (over all sets) of DoFs per entity per set
#define Max_DoF_Per_Vtx     0
#define Max_DoF_Per_Edge    2
#define Max_DoF_Per_Face    0
#define Max_DoF_Per_Tet     0

// set the total number of DoFs per entity
#define Num_DoF_Per_Vtx     0
#define Num_DoF_Per_Edge    2
#define Num_DoF_Per_Face    0
#define Num_DoF_Per_Tet     0

// set the TOTAL number of DoFs per cell (element)
#define Total_DoF_Per_Cell  12
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
// set (intrinsic) dimension and domain
#define Dimension    3
#define Domain_str  "tetrahedron"

// set the number of vertices
#define NUM_VTX    4
// set the number of edges
#define NUM_EDGE   6
// set the number of faces
#define NUM_FACE   4
// set the number of tetrahedrons
#define NUM_TET    1
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
    void  Fill_DoF_Map  (TETRAHEDRON_DATA*);
    int  Assign_Vtx_DoF (TETRAHEDRON_DATA*, const int);
    int  Assign_Edge_DoF(TETRAHEDRON_DATA*, const int);
    int  Assign_Face_DoF(TETRAHEDRON_DATA*, const int);
    int  Assign_Tet_DoF (TETRAHEDRON_DATA*, const int);
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

    Node.E[1][1][1] = 1; // Set1, E1
    Node.E[1][1][2] = 2; // Set1, E1
    Node.E[1][2][1] = 3; // Set1, E2
    Node.E[1][2][2] = 4; // Set1, E2
    Node.E[1][3][1] = 5; // Set1, E3
    Node.E[1][3][2] = 6; // Set1, E3
    Node.E[1][4][1] = 7; // Set1, E4
    Node.E[1][4][2] = 8; // Set1, E4
    Node.E[1][5][1] = 9; // Set1, E5
    Node.E[1][5][2] = 10; // Set1, E5
    Node.E[1][6][1] = 11; // Set1, E6
    Node.E[1][6][2] = 12; // Set1, E6



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
void EDA::Fill_DoF_Map(TETRAHEDRON_DATA*  Tet_Data)
{
    // output what we are doing
    printf("Generating DoFs on ");
    printf(Domain);
    printf("s for the Finite Element: ");
    printf(Name);
    printf(".\n");

    // write the local to global DoF mapping
    int DoF_Offset = 0;
    DoF_Offset = Assign_Vtx_DoF (Tet_Data, DoF_Offset);
    DoF_Offset = Assign_Edge_DoF(Tet_Data, DoF_Offset);
    DoF_Offset = Assign_Face_DoF(Tet_Data, DoF_Offset);
    DoF_Offset = Assign_Tet_DoF (Tet_Data, DoF_Offset);
    Error_Check_DoF_Map(Tet_Data->Num_Tet);
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the vertex DoFs */
int EDA::Assign_Vtx_DoF(TETRAHEDRON_DATA*      Tet_Data,     // inputs (list of tets)
                        const int              DoF_Offset)
{
    // for every vertex, store the first tet (with local vertex index) that allocated DoFs for it
    vector<int> Vtx_to_Tet[2];
    Vtx_to_Tet[0].resize((unsigned int)(Tet_Data->Max_Vtx_Index+1));
    Vtx_to_Tet[1].resize((unsigned int)(Tet_Data->Max_Vtx_Index+1));

    int Vtx_DoF_Counter = DoF_Offset;
    // allocate DoFs for the global vertices that are actually present
    if (Num_DoF_Per_Vtx > 0)
        {
        int VTX_COUNT = 0; // keep track of the number of unique vertices
        for (int ti=0; ti < Tet_Data->Num_Tet; ti++)
            {
            // loop thru all vertices of each tet
            for (int vtxi=0; vtxi < NUM_VTX; vtxi++)
                {
                const unsigned int Vertex = (unsigned int) Tet_Data->Tet_DoF[vtxi][ti];
                const int tet_ind         =   ti+1; // put into MATLAB-style indexing
                const int vtx_ind         = vtxi+1; // put into MATLAB-style indexing
                // if this vertex has NOT been visited yet
                if (Vtx_to_Tet[0][Vertex]==0)
                    {
                    VTX_COUNT++;

                    // remember which tet is associated with this vertex
                    Vtx_to_Tet[0][Vertex] = tet_ind;
                    // remember the local vertex
                    Vtx_to_Tet[1][Vertex] = vtx_ind;

                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: add more DoFs
                    /*------------   END: Auto Generate ------------*/
                    }
                else
                    {
                    const int old_ti      = Vtx_to_Tet[0][Vertex]-1; // put into C-style indexing
                    const int old_vtx_ind = Vtx_to_Tet[1][Vertex];

                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: copy over DoFs
                    /*------------   END: Auto Generate ------------*/
                    }
                }
            }
        // store the number of unique vertices
        Tet_Data->Num_Unique_Vertices = VTX_COUNT;
        }
    return Vtx_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the edge DoFs */
int EDA::Assign_Edge_DoF(TETRAHEDRON_DATA*      Tet_Data,    // inputs (list of tets)
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
        for (ei=Tet_Data->Edge_List.begin(); ei!=Tet_Data->Edge_List.end(); ++ei)
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
                /*------------   END: Auto Generate ------------*/
                }
            // allocate DoFs on edge in negative order
            if (local_edge_index<0)
                {
                /*------------ BEGIN: Auto Generate ------------*/
                // Set 1:
                cell_dof[ Node.E[1][-local_edge_index][2] ][cell_index] = SE_DoF[1][1];
                cell_dof[ Node.E[1][-local_edge_index][1] ][cell_index] = SE_DoF[1][2];
                /*------------   END: Auto Generate ------------*/
                }
            }
        // store the number of unique edges
        Tet_Data->Num_Unique_Edges = EDGE_COUNT;
        }
    return Edge_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the face DoFs */
int EDA::Assign_Face_DoF(TETRAHEDRON_DATA*      Tet_Data,    // inputs (list of tets)
                         const int              DoF_Offset)
{
    int Face_DoF_Counter = DoF_Offset;
    // allocate DoFs for the faces in the triangulation
    if (Num_DoF_Per_Face > 0)
        {
        // temp storage for DoFs on face
        int SF_DoF[Num_Face_Sets+1][Max_DoF_Per_Face+1];
        // initialize to NULL value
        for (int ind1=0; ind1 < Num_Face_Sets+1; ind1++)
        for (int ind2=0; ind2 < Max_DoF_Per_Face+1; ind2++)
            SF_DoF[ind1][ind2] = -1;

        // initialize previous face to NULL
        FACE_TO_CELL Prev_FI;
        Prev_FI.face_info[0] = 0;
        Prev_FI.face_info[1] = 0;
        Prev_FI.face_info[2] = 0;
        Prev_FI.face_info[3] = 0;
        Prev_FI.face_info[4] = 0;
        Prev_FI.face_info[5] = 0;

        std::vector<FACE_TO_CELL>::iterator fi; // need iterator
        int FACE_COUNT = 0;
        for (fi=Tet_Data->Face_List.begin(); fi!=Tet_Data->Face_List.end(); ++fi)
            {
            const FACE_TO_CELL Current_FI = *fi;
            const bool NEW_FACE = (Prev_FI.face_info[0]!=Current_FI.face_info[0]) ||
                                  (Prev_FI.face_info[1]!=Current_FI.face_info[1]) ||
                                  (Prev_FI.face_info[2]!=Current_FI.face_info[2]);
            const unsigned int cell_index       = Current_FI.face_info[3];
            const unsigned int local_face_index = Current_FI.face_info[4];

            // if this face has NOT been visited yet
            if (NEW_FACE)
                {
                FACE_COUNT++;
                Prev_FI = Current_FI; // update previous

                // generate new DoF's
                /*------------ BEGIN: Auto Generate ------------*/
                // Set 1: add more DoFs
                /*------------   END: Auto Generate ------------*/
                }
            else
                {
                // if the same face is contained in the same cell as the previous
                if (Prev_FI.face_info[3]==cell_index)
                    {
                    // then, this should not happen!
                    mexPrintf("A face appears more than once, and referenced to the same cell,\n");
                    mexPrintf("        in an internal list of this sub-routine!\n");
                    mexPrintf("This should never happen!\n");
                    mexPrintf("Please report this bug!\n");
                    mexErrMsgTxt("STOP!\n");
                    }
                }

            // allocate DoFs on new (first) face (in an arbitrary order)
            if (NEW_FACE)
                {
                /*------------ BEGIN: Auto Generate ------------*/
                // Set 1: write DoFs in an arbitrary, but fixed order
                /*------------   END: Auto Generate ------------*/
                }
            // allocate DoFs on opposite (second) face in *reverse* order (with respect to each edge) and swap two of the edges
            else
                {
                const unsigned int NOT_SWAP = Tet_Data->Determine_Edge_NOT_To_Swap_In_Face(Prev_FI.face_info[5],Current_FI.face_info[5]);
                if (NOT_SWAP==1) // swap edges 2 & 3
                    {
                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: write DoFs in reverse order from before
                    // edge 1
                    // edge 2
                    // edge 3
                    /*------------   END: Auto Generate ------------*/
                    }
                else if (NOT_SWAP==2) // swap edges 1 & 3
                    {
                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: write DoFs in reverse order from before
                    // edge 1
                    // edge 2
                    // edge 3
                    /*------------   END: Auto Generate ------------*/
                    }
                else // if (NOT_SWAP==3) // swap edges 1 & 2
                    {
                    /*------------ BEGIN: Auto Generate ------------*/
                    // Set 1: write DoFs in reverse order from before
                    // edge 1
                    // edge 2
                    // edge 3
                    /*------------   END: Auto Generate ------------*/
                    }
                }
            }
        // store the number of unique faces
        Tet_Data->Num_Unique_Faces = FACE_COUNT;
        }
    return Face_DoF_Counter;
}
/***************************************************************************************/


/***************************************************************************************/
/* allocate the tet DoFs */
int EDA::Assign_Tet_DoF(TETRAHEDRON_DATA*       Tet_Data,    // inputs (list of tets)
                        const int               DoF_Offset)
{
    int Tet_DoF_Counter = DoF_Offset;
    // special case: there are 1-to-N tets (no gaps in numbering)
    if (Num_DoF_Per_Tet > 0)
        {
        // allocate DoFs for the global tets that are actually present
        for (int ti=0; ti < Tet_Data->Num_Tet; ti++)
            {
            const int tet_ind = 1; // there is only 1 tet in 3D

            /*------------ BEGIN: Auto Generate ------------*/
            // Set 1: add more DoFs
            /*------------   END: Auto Generate ------------*/
            }
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
