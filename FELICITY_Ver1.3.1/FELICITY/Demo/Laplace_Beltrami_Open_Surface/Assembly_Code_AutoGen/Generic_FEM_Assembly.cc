/*
============================================================================================
   Methods for a C++ Class that does generic finite element assembly.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 04-08-2010,  Shawn W. Walker
============================================================================================
*/

#define GFA Generic_FEM_Assembly

/***************************************************************************************/
/* constructor */
GFA::GFA (const mxArray *prhs[], const mxArray *Subset_Elem)
{
    /*------------ BEGIN: Auto Generate ------------*/
    // setup inputs
    Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma.Setup_Data(prhs[PRHS_Gamma_Mesh_Subdomains], prhs[PRHS_Gamma_Mesh_DoFmap], Subset_Elem);
    Domain_Gamma_embedded_in_Gamma_restricted_to_dGamma.Setup_Data(prhs[PRHS_Gamma_Mesh_Subdomains], prhs[PRHS_Gamma_Mesh_DoFmap], Subset_Elem);
    Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma.Setup_Data(prhs[PRHS_Gamma_Mesh_Subdomains], prhs[PRHS_Gamma_Mesh_DoFmap], Subset_Elem);

    geom_Gamma_embedded_in_Gamma_restricted_to_Gamma.Setup_Mesh_Geometry(prhs[PRHS_Gamma_Mesh_Vertices], prhs[PRHS_Gamma_Mesh_DoFmap], prhs[PRHS_EMPTY_1]);
    geom_Gamma_embedded_in_Gamma_restricted_to_Gamma.Domain = &Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    geom_Gamma_embedded_in_Gamma_restricted_to_dGamma.Setup_Mesh_Geometry(prhs[PRHS_Gamma_Mesh_Vertices], prhs[PRHS_Gamma_Mesh_DoFmap], prhs[PRHS_EMPTY_1]);
    geom_Gamma_embedded_in_Gamma_restricted_to_dGamma.Domain = &Domain_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    geom_dGamma_embedded_in_Gamma_restricted_to_dGamma.Setup_Mesh_Geometry(prhs[PRHS_Gamma_Mesh_Vertices], prhs[PRHS_Gamma_Mesh_DoFmap], prhs[PRHS_EMPTY_1]);
    geom_dGamma_embedded_in_Gamma_restricted_to_dGamma.Domain = &Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma;

    Setup_Data(prhs);
    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
GFA::~GFA ()
{
    // clear it
    mxFree(Sparse_Data_NV_Error_sq.name);
    mxFree(Sparse_Data_Neumann_L2_Error_sq.name);
    mxFree(Sparse_Data_TV_Error_sq.name);
    mxFree(Sparse_Data_lambda_L2_Error_sq.name);
    mxFree(Sparse_Data_u_L2_Error_sq.name);
}
/***************************************************************************************/


/***************************************************************************************/
/* setup matrix data into a nice struct for internal use */
void GFA::Setup_Data(const mxArray *prhs[]) // input from MATLAB
{
    // access previously assembled matrices (if they exist)
    /*------------ BEGIN: Auto Generate ------------*/
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "NV_Error_sq", 0, Sparse_Data_NV_Error_sq);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "Neumann_L2_Error_sq", 1, Sparse_Data_Neumann_L2_Error_sq);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "TV_Error_sq", 2, Sparse_Data_TV_Error_sq);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "lambda_L2_Error_sq", 3, Sparse_Data_lambda_L2_Error_sq);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "u_L2_Error_sq", 4, Sparse_Data_u_L2_Error_sq);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to FE basis functions
    V_h_phi_restricted_to_Gamma.Setup_Function_Space(prhs[PRHS_V_h_DoFmap]);
    V_h_phi_restricted_to_Gamma.Mesh = &geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    G_h_phi_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_G_h_DoFmap]);
    G_h_phi_restricted_to_dGamma.Mesh = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    V_h_phi_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_V_h_DoFmap]);
    V_h_phi_restricted_to_dGamma.Mesh = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    W_h_phi_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_W_h_DoFmap]);
    W_h_phi_restricted_to_dGamma.Mesh = &geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup correct number of components for CONSTANT basis functions
    NV_Error_sq_dGamma_col_constant_phi.Num_Comp = 1;
    NV_Error_sq_dGamma_row_constant_phi.Num_Comp = 1;
    Neumann_L2_Error_sq_dGamma_col_constant_phi.Num_Comp = 1;
    Neumann_L2_Error_sq_dGamma_row_constant_phi.Num_Comp = 1;
    TV_Error_sq_dGamma_col_constant_phi.Num_Comp = 1;
    TV_Error_sq_dGamma_row_constant_phi.Num_Comp = 1;
    lambda_L2_Error_sq_dGamma_col_constant_phi.Num_Comp = 1;
    lambda_L2_Error_sq_dGamma_row_constant_phi.Num_Comp = 1;
    u_L2_Error_sq_Gamma_col_constant_phi.Num_Comp = 1;
    u_L2_Error_sq_Gamma_row_constant_phi.Num_Comp = 1;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to external FE functions
    u_h_restricted_to_Gamma.Setup_Function_Space(prhs[PRHS_u_h_Values], &V_h_phi_restricted_to_Gamma);
    NV_h_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_NV_h_Values], &G_h_phi_restricted_to_dGamma);
    TV_h_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_TV_h_Values], &G_h_phi_restricted_to_dGamma);
    lambda_h_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_lambda_h_Values], &W_h_phi_restricted_to_dGamma);
    u_h_restricted_to_dGamma.Setup_Function_Space(prhs[PRHS_u_h_Values], &V_h_phi_restricted_to_dGamma);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup the base matrices to compute
    Base_Matrix_NV_Error_sq = new Base_NV_Error_sq_Data_Type(&NV_Error_sq_dGamma_row_constant_phi, &NV_Error_sq_dGamma_col_constant_phi);
    Base_Matrix_Neumann_L2_Error_sq = new Base_Neumann_L2_Error_sq_Data_Type(&Neumann_L2_Error_sq_dGamma_row_constant_phi, &Neumann_L2_Error_sq_dGamma_col_constant_phi);
    Base_Matrix_TV_Error_sq = new Base_TV_Error_sq_Data_Type(&TV_Error_sq_dGamma_row_constant_phi, &TV_Error_sq_dGamma_col_constant_phi);
    Base_Matrix_lambda_L2_Error_sq = new Base_lambda_L2_Error_sq_Data_Type(&lambda_L2_Error_sq_dGamma_row_constant_phi, &lambda_L2_Error_sq_dGamma_col_constant_phi);
    Base_Matrix_u_L2_Error_sq = new Base_u_L2_Error_sq_Data_Type(&u_L2_Error_sq_Gamma_row_constant_phi, &u_L2_Error_sq_Gamma_col_constant_phi);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pass pointers around
    Base_Matrix_NV_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_Gamma = &geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    Base_Matrix_NV_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_dGamma = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->geom_dGamma_embedded_in_Gamma_restricted_to_dGamma = &geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->G_h_phi_restricted_to_dGamma = &G_h_phi_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->V_h_phi_restricted_to_Gamma = &V_h_phi_restricted_to_Gamma;
    Base_Matrix_NV_Error_sq->V_h_phi_restricted_to_dGamma = &V_h_phi_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->W_h_phi_restricted_to_dGamma = &W_h_phi_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->NV_h_restricted_to_dGamma = &NV_h_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->TV_h_restricted_to_dGamma = &TV_h_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->lambda_h_restricted_to_dGamma = &lambda_h_restricted_to_dGamma;
    Base_Matrix_NV_Error_sq->u_h_restricted_to_Gamma = &u_h_restricted_to_Gamma;
    Base_Matrix_NV_Error_sq->u_h_restricted_to_dGamma = &u_h_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_Gamma = &geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    Base_Matrix_Neumann_L2_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_dGamma = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->geom_dGamma_embedded_in_Gamma_restricted_to_dGamma = &geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->G_h_phi_restricted_to_dGamma = &G_h_phi_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->V_h_phi_restricted_to_Gamma = &V_h_phi_restricted_to_Gamma;
    Base_Matrix_Neumann_L2_Error_sq->V_h_phi_restricted_to_dGamma = &V_h_phi_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->W_h_phi_restricted_to_dGamma = &W_h_phi_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->NV_h_restricted_to_dGamma = &NV_h_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->TV_h_restricted_to_dGamma = &TV_h_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->lambda_h_restricted_to_dGamma = &lambda_h_restricted_to_dGamma;
    Base_Matrix_Neumann_L2_Error_sq->u_h_restricted_to_Gamma = &u_h_restricted_to_Gamma;
    Base_Matrix_Neumann_L2_Error_sq->u_h_restricted_to_dGamma = &u_h_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_Gamma = &geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    Base_Matrix_TV_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_dGamma = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->geom_dGamma_embedded_in_Gamma_restricted_to_dGamma = &geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->G_h_phi_restricted_to_dGamma = &G_h_phi_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->V_h_phi_restricted_to_Gamma = &V_h_phi_restricted_to_Gamma;
    Base_Matrix_TV_Error_sq->V_h_phi_restricted_to_dGamma = &V_h_phi_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->W_h_phi_restricted_to_dGamma = &W_h_phi_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->NV_h_restricted_to_dGamma = &NV_h_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->TV_h_restricted_to_dGamma = &TV_h_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->lambda_h_restricted_to_dGamma = &lambda_h_restricted_to_dGamma;
    Base_Matrix_TV_Error_sq->u_h_restricted_to_Gamma = &u_h_restricted_to_Gamma;
    Base_Matrix_TV_Error_sq->u_h_restricted_to_dGamma = &u_h_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_Gamma = &geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    Base_Matrix_lambda_L2_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_dGamma = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->geom_dGamma_embedded_in_Gamma_restricted_to_dGamma = &geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->G_h_phi_restricted_to_dGamma = &G_h_phi_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->V_h_phi_restricted_to_Gamma = &V_h_phi_restricted_to_Gamma;
    Base_Matrix_lambda_L2_Error_sq->V_h_phi_restricted_to_dGamma = &V_h_phi_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->W_h_phi_restricted_to_dGamma = &W_h_phi_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->NV_h_restricted_to_dGamma = &NV_h_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->TV_h_restricted_to_dGamma = &TV_h_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->lambda_h_restricted_to_dGamma = &lambda_h_restricted_to_dGamma;
    Base_Matrix_lambda_L2_Error_sq->u_h_restricted_to_Gamma = &u_h_restricted_to_Gamma;
    Base_Matrix_lambda_L2_Error_sq->u_h_restricted_to_dGamma = &u_h_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_Gamma = &geom_Gamma_embedded_in_Gamma_restricted_to_Gamma;
    Base_Matrix_u_L2_Error_sq->geom_Gamma_embedded_in_Gamma_restricted_to_dGamma = &geom_Gamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->geom_dGamma_embedded_in_Gamma_restricted_to_dGamma = &geom_dGamma_embedded_in_Gamma_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->G_h_phi_restricted_to_dGamma = &G_h_phi_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->V_h_phi_restricted_to_Gamma = &V_h_phi_restricted_to_Gamma;
    Base_Matrix_u_L2_Error_sq->V_h_phi_restricted_to_dGamma = &V_h_phi_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->W_h_phi_restricted_to_dGamma = &W_h_phi_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->NV_h_restricted_to_dGamma = &NV_h_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->TV_h_restricted_to_dGamma = &TV_h_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->lambda_h_restricted_to_dGamma = &lambda_h_restricted_to_dGamma;
    Base_Matrix_u_L2_Error_sq->u_h_restricted_to_Gamma = &u_h_restricted_to_Gamma;
    Base_Matrix_u_L2_Error_sq->u_h_restricted_to_dGamma = &u_h_restricted_to_dGamma;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup the block matrices to assemble
    Block_Assemble_Matrix_NV_Error_sq = new Block_Assemble_NV_Error_sq_Data_Type(&Sparse_Data_NV_Error_sq, Base_Matrix_NV_Error_sq);
    Block_Assemble_Matrix_Neumann_L2_Error_sq = new Block_Assemble_Neumann_L2_Error_sq_Data_Type(&Sparse_Data_Neumann_L2_Error_sq, Base_Matrix_Neumann_L2_Error_sq);
    Block_Assemble_Matrix_TV_Error_sq = new Block_Assemble_TV_Error_sq_Data_Type(&Sparse_Data_TV_Error_sq, Base_Matrix_TV_Error_sq);
    Block_Assemble_Matrix_lambda_L2_Error_sq = new Block_Assemble_lambda_L2_Error_sq_Data_Type(&Sparse_Data_lambda_L2_Error_sq, Base_Matrix_lambda_L2_Error_sq);
    Block_Assemble_Matrix_u_L2_Error_sq = new Block_Assemble_u_L2_Error_sq_Data_Type(&Sparse_Data_u_L2_Error_sq, Base_Matrix_u_L2_Error_sq);
    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* here is the main calling routine for assembling all FEM matrices */
void GFA::Assemble_Matrices ()
{
    // BEGIN: assemble matrices over the Integration Domain: Gamma

    if (Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma.Sub_Assem_List.empty())
        {
        mexPrintf("This integration domain is empty: Gamma\n");
        mexPrintf(" ... so no assembly necessary.\n");
        }

    // loop through each element
    for (std::vector<unsigned int>::iterator DoI_Ind = Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma.Sub_Assem_List.begin();
              DoI_Ind != Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma.Sub_Assem_List.end(); ++DoI_Ind)
        {
        Domain_Gamma_embedded_in_Gamma_restricted_to_Gamma.Read_Embed_Data(*DoI_Ind);

        // get the local simplex transformation
        geom_Gamma_embedded_in_Gamma_restricted_to_Gamma.Compute_Local_Transformation();

        // perform pre-computations with FE basis functions
        // NOTE: this must come before the external FE coefficient functions
        V_h_phi_restricted_to_Gamma.Transform_Basis_Functions();

        // perform pre-computations with external FE coefficient functions
        u_h_restricted_to_Gamma.Compute_Func();

        // loop through the FE matrices to compute
        Base_Matrix_u_L2_Error_sq->Tabulate_Tensor(geom_Gamma_embedded_in_Gamma_restricted_to_Gamma);

        // loop through the block FE matrices to assemble
        Block_Assemble_Matrix_u_L2_Error_sq->Add_Entries_To_Global_Matrix_Gamma(Base_Matrix_u_L2_Error_sq);
        }
    // END: assemble matrices over the Integration Domain: Gamma

    // BEGIN: assemble matrices over the Integration Domain: dGamma

    if (Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma.Sub_Assem_List.empty())
        {
        mexPrintf("This integration domain is empty: dGamma\n");
        mexPrintf(" ... so no assembly necessary.\n");
        }

    // loop through each element
    for (std::vector<unsigned int>::iterator DoI_Ind = Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma.Sub_Assem_List.begin();
              DoI_Ind != Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma.Sub_Assem_List.end(); ++DoI_Ind)
        {
        Domain_Gamma_embedded_in_Gamma_restricted_to_dGamma.Read_Embed_Data(*DoI_Ind);
        Domain_dGamma_embedded_in_Gamma_restricted_to_dGamma.Read_Embed_Data(*DoI_Ind);

        // get the local simplex transformation
        geom_Gamma_embedded_in_Gamma_restricted_to_dGamma.Compute_Local_Transformation();
        geom_dGamma_embedded_in_Gamma_restricted_to_dGamma.Compute_Local_Transformation();

        // perform pre-computations with FE basis functions
        // NOTE: this must come before the external FE coefficient functions
        G_h_phi_restricted_to_dGamma.Transform_Basis_Functions();
        V_h_phi_restricted_to_dGamma.Transform_Basis_Functions();
        W_h_phi_restricted_to_dGamma.Transform_Basis_Functions();

        // perform pre-computations with external FE coefficient functions
        NV_h_restricted_to_dGamma.Compute_Func();
        TV_h_restricted_to_dGamma.Compute_Func();
        lambda_h_restricted_to_dGamma.Compute_Func();
        u_h_restricted_to_dGamma.Compute_Func();

        // loop through the FE matrices to compute
        Base_Matrix_NV_Error_sq->Tabulate_Tensor(geom_dGamma_embedded_in_Gamma_restricted_to_dGamma);
        Base_Matrix_Neumann_L2_Error_sq->Tabulate_Tensor(geom_dGamma_embedded_in_Gamma_restricted_to_dGamma);
        Base_Matrix_TV_Error_sq->Tabulate_Tensor(geom_dGamma_embedded_in_Gamma_restricted_to_dGamma);
        Base_Matrix_lambda_L2_Error_sq->Tabulate_Tensor(geom_dGamma_embedded_in_Gamma_restricted_to_dGamma);

        // loop through the block FE matrices to assemble
        Block_Assemble_Matrix_NV_Error_sq->Add_Entries_To_Global_Matrix_dGamma(Base_Matrix_NV_Error_sq);
        Block_Assemble_Matrix_Neumann_L2_Error_sq->Add_Entries_To_Global_Matrix_dGamma(Base_Matrix_Neumann_L2_Error_sq);
        Block_Assemble_Matrix_TV_Error_sq->Add_Entries_To_Global_Matrix_dGamma(Base_Matrix_TV_Error_sq);
        Block_Assemble_Matrix_lambda_L2_Error_sq->Add_Entries_To_Global_Matrix_dGamma(Base_Matrix_lambda_L2_Error_sq);
        }
    // END: assemble matrices over the Integration Domain: dGamma

}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* this outputs all FEM matrices as MATLAB sparse matrices */
void GFA::Output_Matrices (mxArray* plhs[])
{
    // declare internal matrix data storage pointer
    mxArray* Sparse_ptr;

    // create sparse MATLAB matrices and pass them back to MATLAB

    Sparse_ptr = Block_Assemble_Matrix_NV_Error_sq->MAT->export_matrix();
    Output_Matrix(0, Sparse_ptr, mxCreateString(Block_Assemble_Matrix_NV_Error_sq->Name), plhs[0]);
    delete(Block_Assemble_Matrix_NV_Error_sq);

    Sparse_ptr = Block_Assemble_Matrix_Neumann_L2_Error_sq->MAT->export_matrix();
    Output_Matrix(1, Sparse_ptr, mxCreateString(Block_Assemble_Matrix_Neumann_L2_Error_sq->Name), plhs[0]);
    delete(Block_Assemble_Matrix_Neumann_L2_Error_sq);

    Sparse_ptr = Block_Assemble_Matrix_TV_Error_sq->MAT->export_matrix();
    Output_Matrix(2, Sparse_ptr, mxCreateString(Block_Assemble_Matrix_TV_Error_sq->Name), plhs[0]);
    delete(Block_Assemble_Matrix_TV_Error_sq);

    Sparse_ptr = Block_Assemble_Matrix_lambda_L2_Error_sq->MAT->export_matrix();
    Output_Matrix(3, Sparse_ptr, mxCreateString(Block_Assemble_Matrix_lambda_L2_Error_sq->Name), plhs[0]);
    delete(Block_Assemble_Matrix_lambda_L2_Error_sq);

    Sparse_ptr = Block_Assemble_Matrix_u_L2_Error_sq->MAT->export_matrix();
    Output_Matrix(4, Sparse_ptr, mxCreateString(Block_Assemble_Matrix_u_L2_Error_sq->Name), plhs[0]);
    delete(Block_Assemble_Matrix_u_L2_Error_sq);

}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/***************************************************************************************/
/* setup sparse FEM matrices to be output to MATLAB */
#define NUM_Matrix_Fieldnames (sizeof(Matrix_Fieldnames)/sizeof(*Matrix_Fieldnames))
void GFA::Init_Output_Matrices (mxArray* plhs[])               // output
{
    // // declare internal matrix data storage pointers
    // mxArray *Sparse_ptr;

    // declare constant arrays (see 'Generic_FEM_Assembly.h')
    const char *Matrix_Fieldnames[] = {OUT_MAT_str, OUT_FEM_NAME_str};

    // declare parameters for outputing structures to MATLAB
    mwSize Matrix_dims[2] = {1, 1}; // just initialize to a 1x1 struct

    // set the number of MATLAB structs to create
    Matrix_dims[1] = NUM_FEM_MAT;
    /*** setup LHS argument of MATLAB calling function (i.e. the output structs) ***/
    //                            2, 1xN struct,    X sub-fields,  field names
    plhs[0] = mxCreateStructArray(2, Matrix_dims, NUM_Matrix_Fieldnames, Matrix_Fieldnames);
}
/***************************************************************************************/


/***************************************************************************************/
/* output sparse FEM matrix to MATLAB */
void GFA::Output_Matrix(mwIndex index, mxArray* Sparse_ptr, mxArray* Matrix_Name,   // input
                        mxArray* mxOUT) // output
{
	// point the output MATLAB structure fields to the correct data blocks!
	mxSetFieldByNumber(mxOUT,index,mxGetFieldNumber(mxOUT,OUT_MAT_str), Sparse_ptr);
	mxSetFieldByNumber(mxOUT,index,mxGetFieldNumber(mxOUT,OUT_FEM_NAME_str), Matrix_Name);
}
/***************************************************************************************/


/***************************************************************************************/
/* this verifies the incoming FEM matrix index and name matches, and accesses the data
   (if appropriate) */
void GFA::Access_Previous_FEM_Matrix(
                          const mxArray* OLD_FEM, const char* Matrix_Name,  // inputs
						  const int& Array_Index,                           // inputs
						  PTR_TO_SPARSE&  Data)                             // outputs
{
	if (!mxIsEmpty(OLD_FEM))
		{
		const int Num_Prev_Matrices = (const int) mxGetNumberOfElements(OLD_FEM);
		if (Array_Index >= Num_Prev_Matrices)
			mexErrMsgTxt("Index exceeds the number of incoming FEM matrices!");

        // determine which index of the subdomain array is the one we want
		const mxArray* mxMAT_Name = mxGetField(OLD_FEM, (mwIndex)Array_Index, OUT_FEM_NAME_str);

		/* Copy the string data over... */
        mwSize name_len = mxGetNumberOfElements(mxMAT_Name) + 1;
        char* name_in   = (char*) mxCalloc(name_len, sizeof(char));
        if (mxGetString(mxMAT_Name, name_in, name_len) != 0)
            mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Matrix_Name string data.");

        // if they match, then access the data
        const bool name_equal = (strcmp(Matrix_Name,name_in)==0);
        mxFree(name_in);
        if (name_equal)
            Read_Sparse_Ptr(OLD_FEM, Array_Index, Data);
		else // fail
			{
			mexPrintf("ERROR: The Matrix_Name: %s\n",Matrix_Name);
			mexPrintf("ERROR:     does not match: %s\n",name_in);
			mexPrintf("ERROR:     at OLD_FEM index: %d\n",Array_Index+1); // put into MATLAB style
			mexErrMsgTxt("Check your OLD_FEM data!");
			}
        }
	else
		Clear_Sparse_Ptr(Data);
}
/***************************************************************************************/


/***************************************************************************************/
/* read sparse pointer data, so we can reuse sparse data structure in assembly */
void GFA::Read_Sparse_Ptr (const mxArray* OLD_FEM, const int& Array_Index,   // inputs
						   PTR_TO_SPARSE&  Data)                             // outputs
{
	// indicate that there is a matrix
	Data.valid = true;

	// store the matrix name as a string
	const mxArray* String_ptr = mxGetField(OLD_FEM, (mwIndex)Array_Index, OUT_FEM_NAME_str);
	unsigned int buflen = ((unsigned int)mxGetN(String_ptr))*sizeof(mxChar) + 1;
	Data.name = (char*) mxMalloc((size_t)buflen);
	// copy name over
	const int status = mxGetString(String_ptr, Data.name, (mwSize)buflen);
	if (status==1) mexErrMsgTxt("FEM matrix string name not read in correctly!");

	// get pointer to sparse MATLAB matrix
	const mxArray* Sparse_ptr = mxGetField(OLD_FEM, (mwIndex)Array_Index, OUT_MAT_str);
	// store CSC matrix format info
	Data.m  = (int) mxGetM(Sparse_ptr);
	Data.n  = (int) mxGetN(Sparse_ptr);
	Data.jc = (mwIndex*) mxGetJc(Sparse_ptr);
	Data.ir = (mwIndex*) mxGetIr(Sparse_ptr);
	Data.pr =  (double*) mxGetPr(Sparse_ptr);
}
/***************************************************************************************/


/***************************************************************************************/
/* clear sparse pointer data */
void GFA::Clear_Sparse_Ptr (PTR_TO_SPARSE&  Data)
{
	// clear pointers
	Data.valid = false;
	Data.name  = NULL;
	Data.m     = 0;
	Data.n     = 0;
	Data.jc    = NULL;
	Data.ir    = NULL;
	Data.pr    = NULL;
}
/***************************************************************************************/

#undef GFA

/***/
