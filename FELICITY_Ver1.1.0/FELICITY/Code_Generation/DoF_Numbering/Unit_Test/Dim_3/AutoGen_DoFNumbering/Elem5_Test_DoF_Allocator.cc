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
#define ELEM_Name        "Elem5_Test"
// set allocator class name
#define EDA               Elem5_Test_DoF_Allocator
// set nodal topology data type name
#define NODAL_TOPOLOGY    Elem5_Test_nodal_top

// set the number of DoF sets
#define Num_Vtx_Sets        1
#define Num_Edge_Sets       0
#define Num_Face_Sets       0
#define Num_Tet_Sets        1

// set the max number (over all sets) of DoFs per entity per set
#define Max_DoF_Per_Vtx     1
#define Max_DoF_Per_Edge    0
#define Max_DoF_Per_Face    0
#define Max_DoF_Per_Tet     1

// set the total number of DoFs per entity
#define Num_DoF_Per_Vtx     1
#define Num_DoF_Per_Edge    0
#define Num_DoF_Per_Face    0
#define Num_DoF_Per_Tet     1

// set the TOTAL number of DoFs per cell (element)
#define Total_DoF_Per_Cell  5
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
class EDA
{
public:
    char*    Name;              // name of finite element space
    int      Dim;               // intrinsic dimension
    char*    Domain;            // type of domain: "interval", "triangle", "tetrahedron"

    EDA ();  // constructor
    ~EDA (); // DE-structor
    mxArray* Init_DoF_Map(int);
    void  Fill_DoF_Map  (TETRAHEDRON_DATA*);
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
    int DoF_Counter = 0;
    for (int ind=0; ind < Tet_Data->Num_Tet; ind++)
        {
        for (int i = 1; (i <= Total_DoF_Per_Cell); i++) // note: off by one because of C-style indexing!
            {
            DoF_Counter++;
            cell_dof[i][ind] = DoF_Counter;
            }
        }
    Error_Check_DoF_Map(Tet_Data->Num_Tet);
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
