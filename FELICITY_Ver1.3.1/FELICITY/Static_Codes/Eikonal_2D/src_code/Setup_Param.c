/*
============================================================================================
   This routine organizes some incoming data lists.


   OUTPUTS
   -------
   param_struct:
       A struct containing the algorithm parameters; see below.

   INPUTS
   ------
   Param:
       Param.Max_Tri_per_Star
       Param.NumGaussSeidel
       Param.INF_VAL
       Param.TOL

   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// data structure
typedef struct
{
  int      Max_Tri_per_Star;  // maximum number of triangles in any star of the mesh
  int      NumGaussSeidel;    // number of Gauss-Seidel iterations to run
  double   INF_VAL;           // the "value of infinity"
  double   TOL;               // desired error tolerance
}
PARAM_STRUCT;

/*** put incoming node data from MATLAB into a nice struct ***/
PARAM_STRUCT  Setup_Param(const mxArray *Input_Param)  // inputs
{
	// define output data
	PARAM_STRUCT  param_struct;
	
	/* BEGIN: error checking */
	if (mxGetFieldNumber(Input_Param,"Max_Tri_per_Star")!=0)
		{
		printf("ERROR: Parameter struct missing '.Max_Tri_per_Star'. \n");
		printf("----------------------------------------------------\n");
		printf("       Parameter struct should have the form:  \n");
		printf("                        Param.Max_Tri_per_Star \n");
		printf("                        Param.NumGaussSeidel   \n");
		printf("                        Param.INF_VAL          \n");
		printf("                        Param.TOL              \n");
		printf("----------------------------------------------------\n");
		mexErrMsgTxt("See 'Setup_Param.c'.");
		}
	if (mxGetFieldNumber(Input_Param,"NumGaussSeidel")!=1)
		{
		printf("ERROR: Parameter struct missing '.NumGaussSeidel'. \n");
		printf("----------------------------------------------------\n");
		printf("       Parameter struct should have the form:  \n");
		printf("                        Param.Max_Tri_per_Star \n");
		printf("                        Param.NumGaussSeidel   \n");
		printf("                        Param.INF_VAL          \n");
		printf("                        Param.TOL              \n");
		printf("----------------------------------------------------\n");
		mexErrMsgTxt("See 'Setup_Param.c'.");
		}
	if (mxGetFieldNumber(Input_Param,"INF_VAL")!=2)
		{
		printf("ERROR: Parameter struct missing '.INF_VAL'. \n");
		printf("----------------------------------------------------\n");
		printf("       Parameter struct should have the form:  \n");
		printf("                        Param.Max_Tri_per_Star \n");
		printf("                        Param.NumGaussSeidel   \n");
		printf("                        Param.INF_VAL          \n");
		printf("                        Param.TOL              \n");
		printf("----------------------------------------------------\n");
		mexErrMsgTxt("See 'Setup_Param.c'.");
		}
	if (mxGetFieldNumber(Input_Param,"TOL")!=3)
		{
		printf("ERROR: Parameter struct missing '.TOL'. \n");
		printf("----------------------------------------------------\n");
		printf("       Parameter struct should have the form:  \n");
		printf("                        Param.Max_Tri_per_Star \n");
		printf("                        Param.NumGaussSeidel   \n");
		printf("                        Param.INF_VAL          \n");
		printf("                        Param.TOL              \n");
		printf("----------------------------------------------------\n");
		mexErrMsgTxt("See 'Setup_Param.c'.");
		}
	/* END: error checking */
	
	mxArray *FIELD; // temp
	
	FIELD = mxGetField(Input_Param,(mwIndex)0,"Max_Tri_per_Star");
	param_struct.Max_Tri_per_Star = (int) *mxGetPr(FIELD);
	
	FIELD = mxGetField(Input_Param,(mwIndex)0,"NumGaussSeidel");
	param_struct.NumGaussSeidel = (int) *mxGetPr(FIELD);

	FIELD = mxGetField(Input_Param,(mwIndex)0,"INF_VAL");
	param_struct.INF_VAL = (double) *mxGetPr(FIELD);
	
	FIELD = mxGetField(Input_Param,(mwIndex)0,"TOL");
	param_struct.TOL = (double) *mxGetPr(FIELD);
	
	// output the mesh data
	return param_struct;
}
/***/
