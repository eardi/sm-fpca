/*
============================================================================================
   Methods for a C++ Class that does generic finite element interpolation.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 01-29-2013,  Shawn W. Walker
============================================================================================
*/

#define GFI Generic_FEM_Interpolation

/***************************************************************************************/
/* constructor */
GFI::GFI (const mxArray *prhs[])
{
    /*------------ BEGIN: Auto Generate ------------*/
    // setup inputs
    const mxArray *PRHS_EMPTY = NULL;
    Domain_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All.Setup_Data(prhs[PRHS_EMPTY_2], prhs[PRHS_Hold_All_Mesh_DoFmap], PRHS_EMPTY);

    Hold_All_Interp_Data.Setup("Hold_All", 2, prhs[PRHS_Hold_All_Interp_Data]);

    geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All.Setup_Mesh_Geometry(prhs[PRHS_Hold_All_Mesh_Vertices], prhs[PRHS_Hold_All_Mesh_DoFmap], prhs[PRHS_EMPTY_1]);
    geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All.Domain = &Domain_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All;

    Setup_Data(prhs);
    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
GFI::~GFI ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* setup data into a nice struct for internal use */
void GFI::Setup_Data(const mxArray *prhs[]) // input from MATLAB
{
    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to FE basis functions
    GS_phi_restricted_to_Hold_All.Setup_Function_Space(prhs[PRHS_GS_DoFmap]);
    GS_phi_restricted_to_Hold_All.Mesh = &geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup access to external FE functions
    f_restricted_to_Hold_All.Setup_Function_Space(prhs[PRHS_f_Values], &GS_phi_restricted_to_Hold_All);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // setup the desired interpolations to evaluate
    Iobj_I_h_f = new I_h_f(Hold_All_Interp_Data.Num_Pts);
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pass pointers around
    Iobj_I_h_f->geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All = &geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All;
    Iobj_I_h_f->f_restricted_to_Hold_All = &f_restricted_to_Hold_All;

    /*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* here is the main calling routine for interpolating */
void GFI::Evaluate_Interpolations ()
{
    unsigned int Num_DoE_Interp_Pts = 0;

    // BEGIN: evaluate interpolations over the Expression Domain: Hold_All
    Num_DoE_Interp_Pts = Hold_All_Interp_Data.Num_Pts;
    // loop through each point
    for (unsigned int DoE_Pt = 0; DoE_Pt < Num_DoE_Interp_Pts; DoE_Pt++)
        {
        // read the DoE *element* index from the interpolation point data
        const unsigned int DoE_Elem_Index_MATLAB_style = Hold_All_Interp_Data.Cell_Index[DoE_Pt];
        if (DoE_Elem_Index_MATLAB_style==0) // cell index is INVALID, so ignore!
            {
            mexPrintf("Interpolation cell index is *invalid* for point index #%d.\n",DoE_Pt+1);
            mexPrintf("    No interpolation will be done at this point!\n");
            }
        else // only compute if the cell index is valid!
            {
            unsigned int DoE_Elem_Index = DoE_Elem_Index_MATLAB_style - 1; // need to offset for C-style indexing
            Domain_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All.Read_Embed_Data(DoE_Elem_Index);

            // get the local simplex transformation
            // copy local interpolation coordinates
            Hold_All_Interp_Data.Copy_Local_X(DoE_Pt,geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All.local_coord);
            geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All.Compute_Local_Transformation();

            // perform pre-computations with FE basis functions
            // NOTE: this must come before the external FE coefficient functions
            // copy local interpolation coordinates
            Hold_All_Interp_Data.Copy_Local_X(DoE_Pt,GS_phi_restricted_to_Hold_All.local_coord);
            GS_phi_restricted_to_Hold_All.Transform_Basis_Functions();

            // perform pre-computations with external FE coefficient functions
            f_restricted_to_Hold_All.Compute_Func();

            // loop through the desired FEM interpolations
            Iobj_I_h_f->Eval_All_Interpolations(DoE_Pt);
            }
        }
    // END: evaluate interpolations over the Expression Domain: Hold_All

}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* this outputs all FEM interpolations as MATLAB vectors (in cell arrays) */
void GFI::Output_Interpolations (mxArray* plhs[])
{
    Output_Single_Interpolation(0, Iobj_I_h_f->mxInterp_Data, mxCreateString(Iobj_I_h_f->Name), plhs[0]);
    delete(Iobj_I_h_f);

}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/***************************************************************************************/
/* setup INTERP data to be output to MATLAB */
#define NUM_Interp_Fieldnames (sizeof(Interp_Fieldnames)/sizeof(*Interp_Fieldnames))
void GFI::Init_Output_Data (mxArray* plhs[])               // output
{
    // declare constant arrays (see 'Generic_FEM_Interpolation.h')
    const char *Interp_Fieldnames[] = {OUT_DATA_str, OUT_NAME_str};

    // declare parameters for outputing structures to MATLAB
    mwSize Interp_dims[2] = {1, 1}; // just initialize to a 1x1 struct

    // set the number of MATLAB structs to create
    Interp_dims[1] = NUM_FEM_INTERP;
    /*** setup LHS argument of MATLAB calling function (i.e. the output structs) ***/
    //                            2, 1xN struct,    X sub-fields,  field names
    plhs[0] = mxCreateStructArray(2, Interp_dims, NUM_Interp_Fieldnames, Interp_Fieldnames);
}
/***************************************************************************************/


/***************************************************************************************/
/* output single FEM interpolation data to MATLAB */
void GFI::Output_Single_Interpolation(mwIndex index, mxArray* Interp_ptr, mxArray* Interp_Name,   // input
                                      mxArray* mxOUT) // output
{
	// point the output MATLAB structure fields to the correct data blocks!
	mxSetFieldByNumber(mxOUT,index,mxGetFieldNumber(mxOUT,OUT_DATA_str), Interp_ptr);
	mxSetFieldByNumber(mxOUT,index,mxGetFieldNumber(mxOUT,OUT_NAME_str), Interp_Name);
}
/***************************************************************************************/

#undef GFI

/***/
