    // init the output data (MATLAB cell array)
    Init_Interpolation_Data_Arrays(Num_Interp_Points);
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor: should not usually need to be modified */
SpecificFEM::~SpecificFEM ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* this initializes the output data arrays that will contain the interpolation data */
void SpecificFEM::Init_Interpolation_Data_Arrays(const unsigned int Num_Interp_Points)
{
    // create a cell array to contain the interpolation data (to be output to MATLAB eventually)
	mwSize ndim = 2;
	mwSize dims[2];
	dims[0] = (mwSize) num_row;
	dims[1] = (mwSize) num_col;
	mxInterp_Data = mxCreateCellArray(ndim, dims);
	
	// initialize the entries of the cell array with vector arrays (to be filled with interpolation data)
	mwIndex SetIndex = 0; // init
	mwIndex subs[2];
    for (unsigned int ri = 0; (ri < num_row); ri++)
        for (unsigned int ci = 0; (ci < num_col); ci++)
		    {
            mxArray* Interp_Data_Vec = mxCreateDoubleMatrix((mwSize) Num_Interp_Points, 1, mxREAL);
			// get the correct index
			subs[0] = (mwIndex) ri;
			subs[1] = (mwIndex) ci;
			SetIndex = mxCalcSingleSubscript(mxInterp_Data, (mwSize) 2, subs);
			mxSetCell(mxInterp_Data, SetIndex, Interp_Data_Vec);
			// get pointer to interpolation data in the cell array
			mxArray* TEMP = mxGetCell(mxInterp_Data, SetIndex);
			Interp_Data[ri][ci] = mxGetPr(TEMP);
			}
}
/***************************************************************************************/

