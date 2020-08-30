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
    Generic_FEM_Assembly (const mxArray *[], const mxArray *); // constructor
    ~Generic_FEM_Assembly (); // DE-structor

    /*------------ BEGIN: Auto Generate ------------*/
    // create access routines
    const Data_Type_NV_h_restricted_to_dGamma* Get_NV_h_restricted_to_dGamma_ptr() const { return &(NV_h_restricted_to_dGamma); }
    const Data_Type_TV_h_restricted_to_dGamma* Get_TV_h_restricted_to_dGamma_ptr() const { return &(TV_h_restricted_to_dGamma); }
    const Data_Type_lambda_h_restricted_to_dGamma* Get_lambda_h_restricted_to_dGamma_ptr() const { return &(lambda_h_restricted_to_dGamma); }
    const Data_Type_u_h_restricted_to_Gamma* Get_u_h_restricted_to_Gamma_ptr() const { return &(u_h_restricted_to_Gamma); }
    const Data_Type_u_h_restricted_to_dGamma* Get_u_h_restricted_to_dGamma_ptr() const { return &(u_h_restricted_to_dGamma); }

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
    CLASS_Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma    Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    CLASS_Domain_Gamma_embedded_in_Gamma_restricted_to_dGamma    Domain_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    CLASS_Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma    Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma;

    // mesh geometry classes (can be higher order)
    CLASS_geom_Gamma_embedded_in_Gamma_restricted_to_Gamma   geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    CLASS_geom_Gamma_embedded_in_Gamma_restricted_to_dGamma   geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    CLASS_geom_dGamma_embedded_in_Gamma_restricted_to_dGamma   geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pointers to each specific FEM matrix
    Base_NV_Error_sq_Data_Type*    Base_Matrix_NV_Error_sq;
    Base_Neumann_L2_Error_sq_Data_Type*    Base_Matrix_Neumann_L2_Error_sq;
    Base_TV_Error_sq_Data_Type*    Base_Matrix_TV_Error_sq;
    Base_lambda_L2_Error_sq_Data_Type*    Base_Matrix_lambda_L2_Error_sq;
    Base_u_L2_Error_sq_Data_Type*    Base_Matrix_u_L2_Error_sq;

    Block_Assemble_NV_Error_sq_Data_Type*    Block_Assemble_Matrix_NV_Error_sq;
    PTR_TO_SPARSE    Sparse_Data_NV_Error_sq;
    Block_Assemble_Neumann_L2_Error_sq_Data_Type*    Block_Assemble_Matrix_Neumann_L2_Error_sq;
    PTR_TO_SPARSE    Sparse_Data_Neumann_L2_Error_sq;
    Block_Assemble_TV_Error_sq_Data_Type*    Block_Assemble_Matrix_TV_Error_sq;
    PTR_TO_SPARSE    Sparse_Data_TV_Error_sq;
    Block_Assemble_lambda_L2_Error_sq_Data_Type*    Block_Assemble_Matrix_lambda_L2_Error_sq;
    PTR_TO_SPARSE    Sparse_Data_lambda_L2_Error_sq;
    Block_Assemble_u_L2_Error_sq_Data_Type*    Block_Assemble_Matrix_u_L2_Error_sq;
    PTR_TO_SPARSE    Sparse_Data_u_L2_Error_sq;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing and evaulating FEM (local) basis functions
    Data_Type_V_h_phi_restricted_to_Gamma      V_h_phi_restricted_to_Gamma;
    Data_Type_G_h_phi_restricted_to_dGamma      G_h_phi_restricted_to_dGamma;
    Data_Type_V_h_phi_restricted_to_dGamma      V_h_phi_restricted_to_dGamma;
    Data_Type_W_h_phi_restricted_to_dGamma      W_h_phi_restricted_to_dGamma;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing CONSTANT basis functions
    Data_Type_CONST_ONE_phi      NV_Error_sq_dGamma_col_constant_phi;
    Data_Type_CONST_ONE_phi      NV_Error_sq_dGamma_row_constant_phi;
    Data_Type_CONST_ONE_phi      Neumann_L2_Error_sq_dGamma_col_constant_phi;
    Data_Type_CONST_ONE_phi      Neumann_L2_Error_sq_dGamma_row_constant_phi;
    Data_Type_CONST_ONE_phi      TV_Error_sq_dGamma_col_constant_phi;
    Data_Type_CONST_ONE_phi      TV_Error_sq_dGamma_row_constant_phi;
    Data_Type_CONST_ONE_phi      lambda_L2_Error_sq_dGamma_col_constant_phi;
    Data_Type_CONST_ONE_phi      lambda_L2_Error_sq_dGamma_row_constant_phi;
    Data_Type_CONST_ONE_phi      u_L2_Error_sq_Gamma_col_constant_phi;
    Data_Type_CONST_ONE_phi      u_L2_Error_sq_Gamma_row_constant_phi;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing external functions
    Data_Type_u_h_restricted_to_Gamma      u_h_restricted_to_Gamma;
    Data_Type_NV_h_restricted_to_dGamma      NV_h_restricted_to_dGamma;
    Data_Type_TV_h_restricted_to_dGamma      TV_h_restricted_to_dGamma;
    Data_Type_lambda_h_restricted_to_dGamma      lambda_h_restricted_to_dGamma;
    Data_Type_u_h_restricted_to_dGamma      u_h_restricted_to_dGamma;
    /*------------   END: Auto Generate ------------*/

};

/***/
