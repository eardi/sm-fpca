/*
============================================================================================
   Header file for a C++ Class that contains methods for generic finite element assembly.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 06-20-2012,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set the number of FEM matrices to assemble
#define NUM_FEM_MAT    5

// In MATLAB, the output FEM matrix entry list should look like:
//            FEM.MAT
//               .Type
//
// Here, we define the strings that makes these variable names
#define OUT_MAT_str      "MAT"
#define OUT_FEM_NAME_str "Type"
/*------------   END: Auto Generate ------------*/

/***************************************************************************************/
/*** C++ class ***/
class Generic_FEM_Assembly
{
public:
    //Generic_FEM_Assembly (); // constructor
    Generic_FEM_Assembly (const mxArray *[]); // constructor
    ~Generic_FEM_Assembly (); // DE-structor

    /*------------ BEGIN: Auto Generate ------------*/
    // create access routines
    const Data_Type_old_p_restricted_to_Omega* Get_old_p_restricted_to_Omega_ptr() const { return &(old_p_restricted_to_Omega); }
    const Data_Type_old_vel_restricted_to_Omega* Get_old_vel_restricted_to_Omega_ptr() const { return &(old_vel_restricted_to_Omega); }

    void Setup_Data (const mxArray*[]);
    void Assemble_Matrices ();
    void Output_Matrices (mxArray*[]);
    void Init_Output_Matrices (mxArray*[]);
    void Output_Matrix (mwIndex, mxArray*, mxArray*, mxArray*);
    void Access_Previous_FEM_Matrix (const mxArray*, const char*, const int&, PTR_TO_SPARSE&);
    void Read_Sparse_Ptr (const mxArray*, const int&, PTR_TO_SPARSE&);
    void Clear_Sparse_Ptr (PTR_TO_SPARSE&);

private:
    // these variables are defined from inputs coming from MATLAB

    // classes for (sub)domain(s) and topological entities
    CLASS_Domain_Omega_embedded_in_Omega_restricted_to_Omega    Domain_Omega_embedded_in_Omega_restricted_to_Omega;

    // mesh geometry classes (can be higher order)
    CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega   geom_Omega_embedded_in_Omega_restricted_to_Omega;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pointers to each specific FEM matrix
    Div_Matrix*    Fobj_Div_Matrix;
    L2_Error_Sq*    Fobj_L2_Error_Sq;
    Mass_Matrix*    Fobj_Mass_Matrix;
    RHS_Div*    Fobj_RHS_Div;
    Small_Matrix*    Fobj_Small_Matrix;
    PTR_TO_SPARSE    Sparse_Data_Div_Matrix;
    PTR_TO_SPARSE    Sparse_Data_L2_Error_Sq;
    PTR_TO_SPARSE    Sparse_Data_Mass_Matrix;
    PTR_TO_SPARSE    Sparse_Data_RHS_Div;
    PTR_TO_SPARSE    Sparse_Data_Small_Matrix;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing and evaulating FEM (local) basis functions
    Data_Type_P0_phi_restricted_to_Omega      P0_phi_restricted_to_Omega;
    Data_Type_RT0_phi_restricted_to_Omega      RT0_phi_restricted_to_Omega;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing CONSTANT basis functions
    Data_Type_CONST_ONE_phi      L2_Error_Sq_Omega_col_constant_phi;
    Data_Type_CONST_ONE_phi      L2_Error_Sq_Omega_row_constant_phi;
    Data_Type_CONST_ONE_phi      RHS_Div_Omega_col_constant_phi;
    Data_Type_CONST_ONE_phi      Small_Matrix_Omega_col_constant_phi;
    Data_Type_CONST_ONE_phi      Small_Matrix_Omega_row_constant_phi;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing external functions
    Data_Type_old_p_restricted_to_Omega      old_p_restricted_to_Omega;
    Data_Type_old_vel_restricted_to_Omega      old_vel_restricted_to_Omega;
    /*------------   END: Auto Generate ------------*/

};

/***/
