/*
============================================================================================
   This routine organizes variable matrix data from MATLAB.


   OUTPUTS
   -------
   mat_struct:
       A struct containing the nodal values of the piecewise linear matrix:
       mat_struct.VAL[3][3]
                 .DET

   INPUTS
   ------
   Mesh:
       Data struct containing the triangle mesh information.

   Input_MAT:
       A MATLAB struct containing the variable matrix.

   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// a simple 3x3 matrix structure
// Note: this will also be used to hold a 2x2 matrix
typedef struct
{
  // the arrays stored here correspond the vertex nodes of the mesh
  double  *VAL[3][3];
  double  *DET;
}
MATRIX_3x3_STRUCT;

/*** put incoming piecewise linear matrix data from MATLAB into a nice struct ***/
MATRIX_3x3_STRUCT  Setup_Matrix_Data(
                        TRI_MESH_DATA_STRUCT   Mesh,        // inputs
                        const mxArray         *Input_MAT)   // inputs
{
	// define output data
	MATRIX_3x3_STRUCT  mat_struct;
	
	// internal var's
	mxArray *MAT_INDEX;
	mxArray *I_VAL[3][3];
	mxArray *MAT_DET;
	mxArray *DET_VAL;

	// get pointer to the matrix entry index field
	MAT_INDEX  = mxGetField(Input_MAT,(mwIndex)0,"I");
	size_t NR  = mxGetM(MAT_INDEX);
	size_t NC  = mxGetN(MAT_INDEX);
	// get pointer to the matrix determinant field
	MAT_DET    = mxGetField(Input_MAT,(mwIndex)0,"DET");
	
	// get pointers to values
	for (size_t j=0; j < NC; j++)
	for (size_t i=0; i < NR; i++)
		I_VAL[i][j] = mxGetField(MAT_INDEX,(mwIndex)(i + NR*j),"VAL");
	// get pointer to determinant values
	DET_VAL = mxGetField(MAT_DET,(mwIndex)0,"VAL");

	/* BEGIN: Error Checking */
	if (NR!=NC) mexErrMsgTxt("ERROR: Matrix must have the same number of rows as columns!");
	if (NR!=Mesh.GeoDim) mexErrMsgTxt("ERROR: Matrix dimension does not match the geometric dimension!");
	if (mxGetM(DET_VAL)!=Mesh.NumVtx) mexErrMsgTxt("ERROR: Length of array of determinant values does not match number of mesh vertices!");
	if (mxGetN(DET_VAL)!=1) mexErrMsgTxt("ERROR: array of determinant values should be a column vector!");
	for (size_t j=0; j < NC; j++)
	for (size_t i=0; i < NR; i++)
		{
		if (mxGetM(I_VAL[i][j])!=Mesh.NumVtx) mexErrMsgTxt("ERROR: Length of array of matrix[i][j] values does not match number of mesh vertices!");
		if (mxGetN(I_VAL[i][j])!=1) mexErrMsgTxt("ERROR: array of matrix[i][j] values should be a column vector!");
		}
	/* END: Error Checking */

	// point the internal struct to the external MATLAB data
	for (size_t j=0; j < NC; j++)
	for (size_t i=0; i < NR; i++)
		mat_struct.VAL[i][j] = mxGetPr(I_VAL[i][j]);

	// get det values
	mat_struct.DET = mxGetPr(DET_VAL);
	
	return mat_struct;
}
/***/
