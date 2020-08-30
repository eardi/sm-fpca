

/***************************************************************************************/
/* setup POINTS data to be output to MATLAB */
#define NUM_Points_Fieldnames (sizeof(Points_Fieldnames)/sizeof(*Points_Fieldnames))
void GPS::Init_Output_Data (mxArray* plhs[])               // output
{
    // declare constant arrays (see 'Generic_Point_Search.h')
    const char *Points_Fieldnames[] = {OUT_DATA_str, OUT_NAME_str};

    // declare parameters for outputing structures to MATLAB
    mwSize Points_dims[2] = {1, 1}; // just initialize to a 1x1 struct

    // set the number of MATLAB structs to create
    Points_dims[1] = NUM_PT_SEARCH;
    /*** setup LHS argument of MATLAB calling function (i.e. the output structs) ***/
    //                            2, 1xN struct,    X sub-fields,  field names
    plhs[0] = mxCreateStructArray(2, Points_dims, NUM_Points_Fieldnames, Points_Fieldnames);
}
/***************************************************************************************/


/***************************************************************************************/
/* output single domain point search data to MATLAB */
void GPS::Output_Single_Point_Data(mwIndex index, mxArray* Points_ptr, mxArray* Points_Name,   // input
                                   mxArray* mxOUT) // output
{
	// point the output MATLAB structure fields to the correct data blocks!
	mxSetFieldByNumber(mxOUT,index,mxGetFieldNumber(mxOUT,OUT_DATA_str), Points_ptr);
	mxSetFieldByNumber(mxOUT,index,mxGetFieldNumber(mxOUT,OUT_NAME_str), Points_Name);
}
/***************************************************************************************/

#undef GPS

/***/
