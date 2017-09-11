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
    Domain_Boundary_embedded_in_Omega_restricted_to_Boundary.Setup_Data(prhs[PRHS_Omega_Mesh_Subdomains], prhs[PRHS_Omega_Mesh_DoFmap]);
    Domain_Omega_embedded_in_Omega_restricted_to_Boundary.Setup_Data(prhs[PRHS_Omega_Mesh_Subdomains], prhs[PRHS_Omega_Mesh_DoFmap]);

    geom_Boundary_embedded_in_Omega_restricted_to_Boundary.Setup_Mesh_Geometry(prhs[PRHS_Omega_Mesh_Vertices], prhs[PRHS_Omega_Mesh_DoFmap], prhs[PRHS_Omega_Mesh_Orient]);
    geom_Boundary_embedded_in_Omega_restricted_to_Boundary.Domain = &Domain_Boundary_embedded_in_Omega_restricted_to_Boundary;
    geom_Omega_embedded_in_Omega_restricted_to_Boundary.Setup_Mesh_Geometry(prhs[PRHS_Omega_Mesh_Vertices], prhs[PRHS_Omega_Mesh_DoFmap], prhs[PRHS_Omega_Mesh_Orient]);
    geom_Omega_embedded_in_Omega_restricted_to_Boundary.Domain = &Domain_Omega_embedded_in_Omega_restricted_to_Boundary;

    Setup_Data(prhs);
    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
GFA::~GFA ()
{
    // clear it
    mxFree(Sparse_Data_NV_Constraint.name);
    mxFree(Sparse_Data_NV_Matrix.name);
}
/***************************************************************************************/


/***************************************************************************************/
/* setup matrix data into a nice struct for internal use */
void GFA::Setup_Data(const mxArray *prhs[]) // input from MATLAB
{
    // access previously assembled matrices (if they exist)
    /*------------ BEGIN: Auto Generate ------------*/
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "NV_Constraint", 0, Sparse_Data_NV_Constraint);
    Access_Previous_FEM_Matrix(prhs[PRHS_OLD_FEM], "NV_Matrix", 1, Sparse_Data_NV_Matrix);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to FEM basis functions
    P0_phi_restricted_to_Boundary.Setup_Function_Space(prhs[PRHS_P0_DoFmap]);
    P0_phi_restricted_to_Boundary.Mesh = &geom_Boundary_embedded_in_Omega_restricted_to_Boundary;
    RT0_phi_restricted_to_Boundary.Setup_Function_Space(prhs[PRHS_RT0_DoFmap]);
    RT0_phi_restricted_to_Boundary.Mesh = &geom_Omega_embedded_in_Omega_restricted_to_Boundary;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup correct number of components for CONSTANT basis functions
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to external FEM functions
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup the desired matrices to assemble
    Fobj_NV_Constraint = new NV_Constraint(&Sparse_Data_NV_Constraint, &P0_phi_restricted_to_Boundary, &RT0_phi_restricted_to_Boundary);
    Fobj_NV_Matrix = new NV_Matrix(&Sparse_Data_NV_Matrix, &RT0_phi_restricted_to_Boundary, &RT0_phi_restricted_to_Boundary);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pass pointers around
    Fobj_NV_Constraint->geom_Boundary_embedded_in_Omega_restricted_to_Boundary = &geom_Boundary_embedded_in_Omega_restricted_to_Boundary;
    Fobj_NV_Constraint->geom_Omega_embedded_in_Omega_restricted_to_Boundary = &geom_Omega_embedded_in_Omega_restricted_to_Boundary;
    Fobj_NV_Constraint->P0_phi_restricted_to_Boundary = &P0_phi_restricted_to_Boundary;
    Fobj_NV_Constraint->RT0_phi_restricted_to_Boundary = &RT0_phi_restricted_to_Boundary;

    Fobj_NV_Matrix->geom_Boundary_embedded_in_Omega_restricted_to_Boundary = &geom_Boundary_embedded_in_Omega_restricted_to_Boundary;
    Fobj_NV_Matrix->geom_Omega_embedded_in_Omega_restricted_to_Boundary = &geom_Omega_embedded_in_Omega_restricted_to_Boundary;
    Fobj_NV_Matrix->P0_phi_restricted_to_Boundary = &P0_phi_restricted_to_Boundary;
    Fobj_NV_Matrix->RT0_phi_restricted_to_Boundary = &RT0_phi_restricted_to_Boundary;

    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* here is the main calling routine for assembling all FEM matrices */
void GFA::Assemble_Matrices ()
{
    unsigned int Num_DoI_Elem = 0;

    // BEGIN: assemble matrices over the Integration Domain: Boundary
    Num_DoI_Elem = Domain_Boundary_embedded_in_Omega_restricted_to_Boundary.Get_Num_Elem();
    // loop through each element
    for (unsigned int DoI_Index = 0; DoI_Index < Num_DoI_Elem; DoI_Index++)
        {
        Domain_Boundary_embedded_in_Omega_restricted_to_Boundary.Read_Embed_Data(DoI_Index);
        Domain_Omega_embedded_in_Omega_restricted_to_Boundary.Read_Embed_Data(DoI_Index);

        // get the local simplex transformation
        geom_Boundary_embedded_in_Omega_restricted_to_Boundary.Compute_Local_Transformation();
        geom_Omega_embedded_in_Omega_restricted_to_Boundary.Compute_Local_Transformation();

        // perform pre-computations with FE basis functions
        // NOTE: this must come before the external FE coefficient functions
        P0_phi_restricted_to_Boundary.Transform_Basis_Functions();
        RT0_phi_restricted_to_Boundary.Transform_Basis_Functions();


        // loop through the desired FEM matrices and assemble
        Fobj_NV_Constraint->Add_Entries_To_Global_Matrix(geom_Boundary_embedded_in_Omega_restricted_to_Boundary);
        Fobj_NV_Matrix->Add_Entries_To_Global_Matrix(geom_Boundary_embedded_in_Omega_restricted_to_Boundary);
        }
    // END: assemble matrices over the Integration Domain: Boundary

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

    Sparse_ptr = Fobj_NV_Constraint->MAT->export_matrix();
    Output_Matrix(0, Sparse_ptr, mxCreateString(Fobj_NV_Constraint->Name), plhs[0]);
    delete(Fobj_NV_Constraint);

    Sparse_ptr = Fobj_NV_Matrix->MAT->export_matrix();
    Output_Matrix(1, Sparse_ptr, mxCreateString(Fobj_NV_Matrix->Name), plhs[0]);
    delete(Fobj_NV_Matrix);

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
