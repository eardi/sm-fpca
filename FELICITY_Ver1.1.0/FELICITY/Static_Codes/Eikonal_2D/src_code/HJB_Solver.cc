/*
============================================================================================
   Methods for solving the Hamilton-Jacobi equation via a variational method.
   
   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

#include "HJB_Solver.h"

#define HS HJB_Solver

/***************************************************************************************/
/* constructor */
HS::HS () : GeoDim(0), Soln(0), NOT_enqueued(0), Metric_Present(false)
{
	//
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
HS::~HS ()
{
	if (NOT_enqueued!=0)
		mxFree(NOT_enqueued);
	if (Metric_Present)
		{
		// free the internally computed matrix inverse
		for (int j=0; j < GeoDim; j++)
		for (int i=0; i < GeoDim; i++)
			mxFree(Q.VAL[i][j]);
		mxFree(Q.DET);
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* initialize solver internals */
void HS::Init (const mxArray *prhs[])
{
	/* BEGIN: Setup Inputs (prhs) */
	Mesh            = Setup_2D_Input_Triangle_Mesh_Data(prhs[INPUT_Vertex_Coord], prhs[INPUT_Tri_Elements]);
    Node            = Setup_Node_Data(Mesh, prhs[INPUT_Fixed_Node_List], prhs[INPUT_Adj_Node_List]);
    Param           = Setup_Param(prhs[INPUT_Parameters]);
    TriNeighbors.Init(prhs[INPUT_Tri_Neighbor_Data],Param);
    GeoDim          = (int) Mesh.GeoDim;
    
    if (!mxIsEmpty(prhs[INPUT_Mat]))
		{
		Metric_Present  = true;
	    M               = Setup_Matrix_Data(Mesh, prhs[INPUT_Mat]);
	    Q               = Compute_Inverse(M);
		}
	/* END: Setup Inputs (prhs) */
	
	// allocate
	NOT_enqueued    = (bool *) mxMalloc( Mesh.NumVtx * sizeof(bool) );
	// init
	for(size_t j=0; j < Mesh.NumVtx; j++)
		NOT_enqueued[j] = true;
}
/***************************************************************************************/


/***************************************************************************************/
/* setup output to MATLAB */
void HS::Setup_Output(const mxArray *Input_Soln,  // input
                      mxArray *plhs[])            // output
{
	// error check
	if (mxGetM(Input_Soln)!=Mesh.NumVtx) mexErrMsgTxt("ERROR: Length of Initial Soln vector is not the same as the number of mesh vertices!");
	
    /* deep copy the input solution */
    plhs[0] = mxDuplicateArray(Input_Soln);
    
    /* make a scalar */
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
    
    /* get pointers */
    Soln         = mxGetPr(plhs[0]);
    Output_Error = mxGetPr(plhs[1]);
}
/***************************************************************************************/


/***************************************************************************************/
/* init the queue buffer */
void HS::Init_FIFO()
{
	// make sure the buffer is empty
	Reset_FIFO();
	
	// fill the queue with the nodes adjacent to the Dirichlet nodes
	for(size_t i=0; i < Node.NumAdj; i++)
		FIFO_Buffer.push(Node.Adj[i]-1); // correct for C - style indexing

	// indicate which nodes have NOT made it to the queue yet
	// init by saying none of the nodes has been enqueued
	for(size_t j=0; j < Mesh.NumVtx; j++)
		NOT_enqueued[j] = true;
	// indicate that the adjacent and fixed nodes have been enqueued
	for(size_t i=0; i < Node.NumAdj; i++)
		NOT_enqueued[Node.Adj[i]-1] = false; // correct for C - style indexing
	for(size_t i=0; i < Node.NumFixed; i++)
		NOT_enqueued[Node.Fixed[i]-1] = false; // correct for C - style indexing
}
/***************************************************************************************/


/***************************************************************************************/
/* remove all elements from the queue buffer */
void HS::Reset_FIFO()
{
	while (!FIFO_Buffer.empty())
		FIFO_Buffer.pop();
}
/***************************************************************************************/


/***************************************************************************************/
/* solve the static HJB equation */
void HS::Compute_Soln()
{
	// init
	int CNT = 0;
	double MAX_ERROR = Param.INF_VAL;
	
	while ( (CNT < Param.NumGaussSeidel) && (MAX_ERROR > Param.TOL) )
		{
		CNT++;
		MAX_ERROR = Run_Gauss_Seidel_Iteration();
		}
	// output this to MATLAB
	*Output_Error = MAX_ERROR;
}
/***************************************************************************************/


/***************************************************************************************/
/* run one complete (non-linear, adaptive) Gauss-Seidel iteration */
double HS::Run_Gauss_Seidel_Iteration()
{
	// init the FIFO Queue
	Init_FIFO();
	
	// reset the error
	// used to compute the L^\infty norm of the error between successive iterations
	double MAX_ERROR = 0.0;
	
	while (!FIFO_Buffer.empty())
		{
		// get the first vertex
		int CV_minus_1 = FIFO_Buffer.front();
		FIFO_Buffer.pop();
		
		// get current value
		double VAL = Soln[CV_minus_1];
		
		// compute potential new value via the Hopf-Lax formula at the current vertex
		double NEW_VAL = Compute_Hopf_Lax_Update(CV_minus_1);

		// compute difference
		double error = std::fabs(NEW_VAL - VAL);
		
		// compare the old and new values
		//    if the difference is greater than the tolerance
		//           then, accept the new value
		if (error > Param.TOL)
			{
			MAX_ERROR = std::max(MAX_ERROR,error);
			Soln[CV_minus_1] = NEW_VAL;
			}
		}
		
	return MAX_ERROR;
}
/***************************************************************************************/


/***************************************************************************************/
/* run a single (Hopf-Lax) update for a given vertex */
double HS::Compute_Hopf_Lax_Update(int Current_Vtx_minus_1)
{
	double Update_VAL = Param.INF_VAL;
	
	// get the current star of triangles
	TriNeighbors.Get_Star(Current_Vtx_minus_1,Mesh);
	
	// loop over star of triangles
	for(int ST_i=1; ST_i <= TriNeighbors.Star.Num_Tri; ST_i++)
		{
		double temp_VAL = Find_Min_On_Tri(TriNeighbors.Star.Col1[ST_i],
		                                  TriNeighbors.Star.Col2[ST_i],
		                                  TriNeighbors.Star.Col3[ST_i],
		                                  Current_Vtx_minus_1);
		Update_VAL = std::min(temp_VAL,Update_VAL);
		}

	return Update_VAL;
}
/***************************************************************************************/


/***************************************************************************************/
/* compute minimum over one triangle */
// this routine has multiple RETURN statements!
double HS::Find_Min_On_Tri(int V1, int V2, int V3, // inputs are vertex indices of triangle
                           int CV_minus_1)         // the index of the node at the star center
{
	double VEC12[3] = {0.0, 0.0, 0.0};
	double VEC31[3] = {0.0, 0.0, 0.0};
	double VEC32[3] = {0.0, 0.0, 0.0};
	
	// add these border vertices to the FIFO for later updating
	Update_FIFO(V2, V3);
	
	// compute the solution values at V2 and V3
	double u_2 = Soln[V2];
	double u_3 = Soln[V3];
	
	// get triangle edge vectors
	Get_Vec_Diff(V1, V2, VEC12);
	double VEC12_len = sqrt(inner(VEC12, VEC12, CV_minus_1));
	Get_Vec_Diff(V3, V2, VEC32);
	double VEC32_len = sqrt(inner(VEC32, VEC32, CV_minus_1));
	
	// compute quotient
	double Delta = (u_3 - u_2) / VEC32_len;
	
	if (Delta >= 1.0)
		return u_2 + VEC12_len;

	Get_Vec_Diff(V3, V1, VEC31);
	double VEC31_len = sqrt(inner(VEC31, VEC31, CV_minus_1));
	
	if (Delta <= -1.0)
		return u_3 + VEC31_len;

	// we have to work some more
	double cos_alpha = inner(VEC12, VEC32, CV_minus_1) / (VEC12_len * VEC32_len);
	double cos_beta  = inner(VEC31, VEC32, CV_minus_1) / (VEC31_len * VEC32_len);
	
	if (Delta >= cos_alpha)
		return u_2 + VEC12_len;
	else if (Delta <= -cos_beta)
		return u_3 + VEC31_len;
	else
		return u_2 + ( cos_alpha*Delta + sqrt( (1 - (cos_alpha*cos_alpha)) * (1 - (Delta*Delta)) ) ) * VEC12_len;
}
/***************************************************************************************/


/***************************************************************************************/
/* compute inverse of a matrix */
MATRIX_3x3_STRUCT HS::Compute_Inverse(MATRIX_3x3_STRUCT M)
{
	// declare the output
	MATRIX_3x3_STRUCT Q;
	
	// consider the 2x2 case
	if (GeoDim==2)
		{
		// BEGIN: allocate memory
		for (int j=0; j < 2; j++)
		for (int i=0; i < 2; i++)
			Q.VAL[i][j] = (double *) mxMalloc( Mesh.NumVtx * sizeof(double) );
		// blank the others
		Q.VAL[2][0] = NULL; Q.VAL[2][1] = NULL; Q.VAL[2][2] = NULL;
		Q.VAL[0][2] = NULL; Q.VAL[1][2] = NULL;
		
		Q.DET       = (double *) mxMalloc( Mesh.NumVtx * sizeof(double) );
		// END: allocate memory
		
		// compute!
		for (size_t pt=0; pt < Mesh.NumVtx; pt++)
			{
			Q.DET[pt] = 1.0 / M.DET[pt]; // inverse!
			Q.VAL[0][0][pt] =  M.VAL[1][1][pt] * Q.DET[pt];
			Q.VAL[1][1][pt] =  M.VAL[0][0][pt] * Q.DET[pt];
			Q.VAL[0][1][pt] = -M.VAL[0][1][pt] * Q.DET[pt];
			Q.VAL[1][0][pt] = -M.VAL[1][0][pt] * Q.DET[pt];
			}
		}
	// else do the 3x3 case
	else
		printf("matrix 3x3 case is NOT implemented! \n");

	return Q;
}
/***************************************************************************************/


/***************************************************************************************/
/* update the FIFO with the given vertices as long as they have
   not already been included! */
inline void HS::Update_FIFO(int V2, int V3)
{
	if (NOT_enqueued[V2])
		{
		FIFO_Buffer.push(V2);
		NOT_enqueued[V2] = false;
		}
	
	if (NOT_enqueued[V3])
		{
		FIFO_Buffer.push(V3);
		NOT_enqueued[V3] = false;
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* compute vector difference W = V(i) - V(j) */
inline void HS::Get_Vec_Diff(int i, int j, double *W)
{
	W[0] = Mesh.Vtx.x[i] - Mesh.Vtx.x[j];
	W[1] = Mesh.Vtx.y[i] - Mesh.Vtx.y[j];
	
	if (GeoDim==3)
	    W[2] = Mesh.Vtx.z[i] - Mesh.Vtx.z[j];
}
/***************************************************************************************/


/***************************************************************************************/
/* compute inner product C = A * B */
// this has multiple RETURN statements!
inline double HS::inner(double *A, double *B, int CV_minus_1)
{
	if (!Metric_Present)
		{
		// assume standard euclidean metric
		double C = A[0]*B[0] + A[1]*B[1];
		if (GeoDim==3)
		    C = C + A[2]*B[2];
		return C;
		}
	else
		{
		// use the matrix (that represents the metric) that was provided
		double C = 0.0;
		for (int j=0; j < 2; j++)
		for (int i=0; i < 2; i++)
			C += A[i] * Q.VAL[i][j][CV_minus_1] * B[j];

		if (GeoDim==3)
			printf("matrix 3x3 inner product NOT implemented! \n");

		return C;
		}
}
/***************************************************************************************/

#undef HS

/***/
