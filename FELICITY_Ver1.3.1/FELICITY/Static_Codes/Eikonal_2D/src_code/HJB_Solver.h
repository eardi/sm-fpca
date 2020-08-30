/*
============================================================================================
   Header file for a C++ Class that contains methods for solving the Hamilton-Jacobi
   equation via a variational method.
   

   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

// we use a FIFO buffer in this code
#include <queue>
#include <cmath>

/***************************************************************************************/
class HJB_Solver
{
public:
	HJB_Solver (); // constructor
	~HJB_Solver (); // DE-structor
	
	void Init (const mxArray *[]);
    void Setup_Output(const mxArray *, mxArray *[]);
	void Init_FIFO();
	void Reset_FIFO();
	void Compute_Soln();
	double Run_Gauss_Seidel_Iteration();
	double Compute_Hopf_Lax_Update(int);
	double Find_Min_On_Tri(int, int, int, int);
	
	MATRIX_3x3_STRUCT Compute_Inverse(MATRIX_3x3_STRUCT);
	
	inline void Update_FIFO(int V2, int V3);
    inline void Get_Vec_Diff(int i, int j, double *W);
	inline double inner(double *A, double *B, int CV_minus_1);

private:
    // these variables are defined from inputs coming from MATLAB
	TRI_MESH_DATA_STRUCT  Mesh;             // mesh data structure
	FIXED_NODE_STRUCT     Node;             // contains fixed/boundary nodes and adjacent
	PARAM_STRUCT          Param;            // list of parameters
	Tri_Neighbor_Data     TriNeighbors;     // triangle neighbor data
	int                   GeoDim;
	
	bool                  Metric_Present;   // indicate whether a variable matrix is used
	MATRIX_3x3_STRUCT     M;                // storage for the variable matrix values
	MATRIX_3x3_STRUCT     Q;                // storage for the matrix inverse
	
	// pointer to HJB solution
	double  *Soln;
	// pointer to the max iterative error
	double  *Output_Error;
	
	// FIFO buffer
	std::queue<int>  FIFO_Buffer;
	// record which vertices have not been enqueued (i.e. have not made it to the FIFO yet)
	bool            *NOT_enqueued;
};

/***/
