

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
