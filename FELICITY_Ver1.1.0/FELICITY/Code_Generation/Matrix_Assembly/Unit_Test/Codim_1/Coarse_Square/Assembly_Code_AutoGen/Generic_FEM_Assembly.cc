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
GFA::GFA (const mxArray *prhs[])
{
    /*------------ BEGIN: Auto Generate ------------*/
    // setup inputs
    Domain_Gamma_embedded_in_Omega_restricted_to_Gamma.Setup_Data(prhs[PRHS_Omega_Mesh_Subdomains], prhs[PRHS_Omega_Mesh_DoFmap]);
    Domain_Omega_embedded_in_Omega_restricted_to_Gamma.Setup_Data(prhs[PRHS_Omega_Mesh_Subdomains], prhs[PRHS_Omega_Mesh_DoFmap]);

    geom_Gamma_embedded_in_Omega_restricted_to_Gamma.Setup_Mesh_Geometry(prhs[PRHS_Omega_Mesh_Vertices], prhs[PRHS_Omega_Mesh_DoFmap], prhs[PRHS_EMPTY_1]);
    geom_Gamma_embedded_in_Omega_restricted_to_Gamma.Domain = &Domain_Gamma_embedded_in_Omega_restricted_to_Gamma;
    geom_Omega_embedded_in_Omega_restricted_to_Gamma.Setup_Mesh_Geometry(prhs[PRHS_Omega_Mesh_Vertices], prhs[PRHS_Omega_Mesh_DoFmap], prhs[PRHS_EMPTY_1]);
    geom_Omega_embedded_in_Omega_restricted_to_Gamma.Domain = &Domain_Omega_embedded_in_Omega_restricted_to_Gamma;

    Setup_Data(prhs);
    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
GFA::~GFA ()
{
    // clear it
    mxFree(Sparse_Data_Bdy_Mass.name);
    mxFree(Sparse_Data_Bdy_Vec.name);
    mxFree(Sparse_Data_Mass_Matrix.name);
    mxFree(Sparse_Data_Small_Matrix.name);
    mxFree(Sparse_Data_Vec_Stiffness_Matrix.name);
}
/***************************************************************************************/


/***************************************************************************************/
/* setup matrix data into a nice struct for internal use */
void GFA::Setup_Data(const mxArray *prhs[]) // input from MATLAB
{
    // access previously assembled matrices (if they exist)
    /*------------ BEGIN: Auto Generate ------------*/
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "Bdy_Mass", 0, Sparse_Data_Bdy_Mass);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "Bdy_Vec", 1, Sparse_Data_Bdy_Vec);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "Mass_Matrix", 2, Sparse_Data_Mass_Matrix);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "Small_Matrix", 3, Sparse_Data_Small_Matrix);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "Vec_Stiffness_Matrix", 4, Sparse_Data_Vec_Stiffness_Matrix);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to FEM basis functions
    M_Space_phi_restricted_to_Gamma.Setup_Function_Space(prhs[PRHS_M_Space_DoFmap]);
    M_Space_phi_restricted_to_Gamma.Mesh = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    U_Space_phi_restricted_to_Gamma.Setup_Function_Space(prhs[PRHS_U_Space_DoFmap]);
    U_Space_phi_restricted_to_Gamma.Mesh = &geom_Omega_embedded_in_Omega_restricted_to_Gamma;
    Vector_P1_phi_restricted_to_Gamma.Setup_Function_Space(prhs[PRHS_Vector_P1_DoFmap]);
    Vector_P1_phi_restricted_to_Gamma.Mesh = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup correct number of components for CONSTANT basis functions
    Bdy_Vec_Gamma_col_constant_phi.Num_Comp = 1;
    Small_Matrix_Gamma_col_constant_phi.Num_Comp = 2;
    Small_Matrix_Gamma_row_constant_phi.Num_Comp = 2;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to external FEM functions
    old_soln_restricted_to_Gamma.Setup_Function_Space(prhs[PRHS_old_soln_Values], &U_Space_phi_restricted_to_Gamma);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup the desired matrices to assemble
    Fobj_Bdy_Mass = new Bdy_Mass(&Sparse_Data_Bdy_Mass, &U_Space_phi_restricted_to_Gamma, &M_Space_phi_restricted_to_Gamma);
    Fobj_Bdy_Vec = new Bdy_Vec(&Sparse_Data_Bdy_Vec, &M_Space_phi_restricted_to_Gamma, &Bdy_Vec_Gamma_col_constant_phi);
    Fobj_Mass_Matrix = new Mass_Matrix(&Sparse_Data_Mass_Matrix, &M_Space_phi_restricted_to_Gamma, &M_Space_phi_restricted_to_Gamma);
    Fobj_Small_Matrix = new Small_Matrix(&Sparse_Data_Small_Matrix, &Small_Matrix_Gamma_row_constant_phi, &Small_Matrix_Gamma_col_constant_phi);
    Fobj_Vec_Stiffness_Matrix = new Vec_Stiffness_Matrix(&Sparse_Data_Vec_Stiffness_Matrix, &Vector_P1_phi_restricted_to_Gamma, &Vector_P1_phi_restricted_to_Gamma);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pass pointers around
    Fobj_Bdy_Mass->geom_Gamma_embedded_in_Omega_restricted_to_Gamma = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Bdy_Mass->geom_Omega_embedded_in_Omega_restricted_to_Gamma = &geom_Omega_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Bdy_Mass->M_Space_phi_restricted_to_Gamma = &M_Space_phi_restricted_to_Gamma;
    Fobj_Bdy_Mass->U_Space_phi_restricted_to_Gamma = &U_Space_phi_restricted_to_Gamma;
    Fobj_Bdy_Mass->Vector_P1_phi_restricted_to_Gamma = &Vector_P1_phi_restricted_to_Gamma;
    Fobj_Bdy_Mass->old_soln_restricted_to_Gamma = &old_soln_restricted_to_Gamma;

    Fobj_Bdy_Vec->geom_Gamma_embedded_in_Omega_restricted_to_Gamma = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Bdy_Vec->geom_Omega_embedded_in_Omega_restricted_to_Gamma = &geom_Omega_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Bdy_Vec->M_Space_phi_restricted_to_Gamma = &M_Space_phi_restricted_to_Gamma;
    Fobj_Bdy_Vec->U_Space_phi_restricted_to_Gamma = &U_Space_phi_restricted_to_Gamma;
    Fobj_Bdy_Vec->Vector_P1_phi_restricted_to_Gamma = &Vector_P1_phi_restricted_to_Gamma;
    Fobj_Bdy_Vec->old_soln_restricted_to_Gamma = &old_soln_restricted_to_Gamma;

    Fobj_Mass_Matrix->geom_Gamma_embedded_in_Omega_restricted_to_Gamma = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Mass_Matrix->geom_Omega_embedded_in_Omega_restricted_to_Gamma = &geom_Omega_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Mass_Matrix->M_Space_phi_restricted_to_Gamma = &M_Space_phi_restricted_to_Gamma;
    Fobj_Mass_Matrix->U_Space_phi_restricted_to_Gamma = &U_Space_phi_restricted_to_Gamma;
    Fobj_Mass_Matrix->Vector_P1_phi_restricted_to_Gamma = &Vector_P1_phi_restricted_to_Gamma;
    Fobj_Mass_Matrix->old_soln_restricted_to_Gamma = &old_soln_restricted_to_Gamma;

    Fobj_Small_Matrix->geom_Gamma_embedded_in_Omega_restricted_to_Gamma = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Small_Matrix->geom_Omega_embedded_in_Omega_restricted_to_Gamma = &geom_Omega_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Small_Matrix->M_Space_phi_restricted_to_Gamma = &M_Space_phi_restricted_to_Gamma;
    Fobj_Small_Matrix->U_Space_phi_restricted_to_Gamma = &U_Space_phi_restricted_to_Gamma;
    Fobj_Small_Matrix->Vector_P1_phi_restricted_to_Gamma = &Vector_P1_phi_restricted_to_Gamma;
    Fobj_Small_Matrix->old_soln_restricted_to_Gamma = &old_soln_restricted_to_Gamma;

    Fobj_Vec_Stiffness_Matrix->geom_Gamma_embedded_in_Omega_restricted_to_Gamma = &geom_Gamma_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Vec_Stiffness_Matrix->geom_Omega_embedded_in_Omega_restricted_to_Gamma = &geom_Omega_embedded_in_Omega_restricted_to_Gamma;
    Fobj_Vec_Stiffness_Matrix->M_Space_phi_restricted_to_Gamma = &M_Space_phi_restricted_to_Gamma;
    Fobj_Vec_Stiffness_Matrix->U_Space_phi_restricted_to_Gamma = &U_Space_phi_restricted_to_Gamma;
    Fobj_Vec_Stiffness_Matrix->Vector_P1_phi_restricted_to_Gamma = &Vector_P1_phi_restricted_to_Gamma;
    Fobj_Vec_Stiffness_Matrix->old_soln_restricted_to_Gamma = &old_soln_restricted_to_Gamma;

    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* here is the main calling routine for assembling all FEM matrices */
void GFA::Assemble_Matrices ()
{
    unsigned int Num_DoI_Elem = 0;

    // BEGIN: assemble matrices over the Integration Domain: Gamma
    Num_DoI_Elem = Domain_Gamma_embedded_in_Omega_restricted_to_Gamma.Get_Num_Elem();
    // loop through each element
    for (unsigned int DoI_Index = 0; DoI_Index < Num_DoI_Elem; DoI_Index++)
        {
        Domain_Gamma_embedded_in_Omega_restricted_to_Gamma.Read_Embed_Data(DoI_Index);
        Domain_Omega_embedded_in_Omega_restricted_to_Gamma.Read_Embed_Data(DoI_Index);

        // get the local simplex transformation
        geom_Gamma_embedded_in_Omega_restricted_to_Gamma.Compute_Local_Transformation();
        geom_Omega_embedded_in_Omega_restricted_to_Gamma.Compute_Local_Transformation();

        // perform pre-computations with FE basis functions
        // NOTE: this must come before the external FE coefficient functions
        M_Space_phi_restricted_to_Gamma.Transform_Basis_Functions();
        U_Space_phi_restricted_to_Gamma.Transform_Basis_Functions();
        Vector_P1_phi_restricted_to_Gamma.Transform_Basis_Functions();

        // perform pre-computations with external FE coefficient functions
        old_soln_restricted_to_Gamma.Compute_Func();

        // loop through the desired FEM matrices and assemble
        Fobj_Bdy_Mass->Add_Entries_To_Global_Matrix(geom_Gamma_embedded_in_Omega_restricted_to_Gamma);
        Fobj_Bdy_Vec->Add_Entries_To_Global_Matrix(geom_Gamma_embedded_in_Omega_restricted_to_Gamma);
        Fobj_Mass_Matrix->Add_Entries_To_Global_Matrix(geom_Gamma_embedded_in_Omega_restricted_to_Gamma);
        Fobj_Small_Matrix->Add_Entries_To_Global_Matrix(geom_Gamma_embedded_in_Omega_restricted_to_Gamma);
        Fobj_Vec_Stiffness_Matrix->Add_Entries_To_Global_Matrix(geom_Gamma_embedded_in_Omega_restricted_to_Gamma);
        }
    // END: assemble matrices over the Integration Domain: Gamma

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

    Sparse_ptr = Fobj_Bdy_Mass->MAT->export_matrix();
    Output_Matrix(0, Sparse_ptr, mxCreateString(Fobj_Bdy_Mass->Name), plhs[0]);
    delete(Fobj_Bdy_Mass);

    Sparse_ptr = Fobj_Bdy_Vec->MAT->export_matrix();
    Output_Matrix(1, Sparse_ptr, mxCreateString(Fobj_Bdy_Vec->Name), plhs[0]);
    delete(Fobj_Bdy_Vec);

    Sparse_ptr = Fobj_Mass_Matrix->MAT->export_matrix();
    Output_Matrix(2, Sparse_ptr, mxCreateString(Fobj_Mass_Matrix->Name), plhs[0]);
    delete(Fobj_Mass_Matrix);

    Sparse_ptr = Fobj_Small_Matrix->MAT->export_matrix();
    Output_Matrix(3, Sparse_ptr, mxCreateString(Fobj_Small_Matrix->Name), plhs[0]);
    delete(Fobj_Small_Matrix);

    Sparse_ptr = Fobj_Vec_Stiffness_Matrix->MAT->export_matrix();
    Output_Matrix(4, Sparse_ptr, mxCreateString(Fobj_Vec_Stiffness_Matrix->Name), plhs[0]);
    delete(Fobj_Vec_Stiffness_Matrix);

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
