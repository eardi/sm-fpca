/*
============================================================================================
   This class implements the E_ODT mesh smoothing method.

   Copyright (c) 04-23-2013,  Shawn W. Walker
============================================================================================
*/

/* C++ Mesh Smoothing class definition */
#define EOMSC  E_ODT_Mesh_Smoother_Class
class EOMSC
{
public:
    EOMSC (); // constructor
    ~EOMSC ();   // DE-structor
    void Setup_Data(Mesh_Class_For_Star*, const mxArray*, const mxArray*);
	void Setup_Bias_Gradient(const mxArray*);
    void Run_Smoother();

    // inputs
    int       Num_Vtx_To_Smooth;
    int*      Vtx_List_To_Smooth;
    int       Num_Sweeps;

    // outputs
    mxArray*  New_Vtx_Coord;

private:
    int                    Num_Vtx;
    double*                Vtx_Coord[3];    // mesh vertex coordinates
	bool                   GOT_BIAS_GRAD;   // indicates whether bias gradient info is present
	double*                Bias_Grad[3];    // extra bias gradient info
    Mesh_Class_For_Star*   Mesh;
    STAR                   Vtx_Star;

    void Run_Smoother_Once_1D();
    void Compute_E_ODT_Star_Gradient_wrt_Vtx2_1D(double& Vol, double Weighted_Grad_Vol[1]);
    void Compute_Weighted_Gradient_Of_T_Vol_wrt_Center_Vtx_1D(int* vtx_indices, double& vol, double vol_grad[1]);

    void Run_Smoother_Once_2D();
    void Compute_E_ODT_Star_Gradient_wrt_Vtx2_2D(double& Vol, double Weighted_Grad_Vol[2]);
    void Compute_Weighted_Gradient_Of_T_Vol_wrt_Vtx2_2D(int* vtx_indices, double& vol, double vol_grad[2]);

    void Run_Smoother_Once_3D();
    void Compute_E_ODT_Star_Gradient_wrt_Vtx2_3D(double& Vol, double Weighted_Grad_Vol[3]);
    void Compute_Weighted_Gradient_Of_T_Vol_wrt_Vtx2_3D(int* vtx_indices, double& vol, double vol_grad[3]);
    void Star_Volume_Is_Degenerate_Message(const int&);

    inline void Read_Vertex_Coord1(const int& vi, double vc[1])
        {
            // read in the vertex coordinates
            vc[0] = Vtx_Coord[0][vi];
        }
    inline void Read_Vertex_Coord2(const int& vi, double vc[2])
        {
            // read in the vertex coordinates
            vc[0] = Vtx_Coord[0][vi];
            vc[1] = Vtx_Coord[1][vi];
        }
    inline void Read_Vertex_Coord3(const int& vi, double vc[3])
        {
            // read in the vertex coordinates
            vc[0] = Vtx_Coord[0][vi];
            vc[1] = Vtx_Coord[1][vi];
            vc[2] = Vtx_Coord[2][vi];
        }

    inline void Write_Vertex_Coord1(const int& vi, double vc[1])
        {
            // write the vertex coordinates
            Vtx_Coord[0][vi] = vc[0];
        }
    inline void Write_Vertex_Coord2(const int& vi, double vc[2])
        {
            // write the vertex coordinates
            Vtx_Coord[0][vi] = vc[0];
            Vtx_Coord[1][vi] = vc[1];
        }
    inline void Write_Vertex_Coord3(const int& vi, double vc[3])
        {
            // write the vertex coordinates
            Vtx_Coord[0][vi] = vc[0];
            Vtx_Coord[1][vi] = vc[1];
            Vtx_Coord[2][vi] = vc[2];
        }

    inline void Vec_Diff2(double A[2], double B[2], double Diff_AB[2])
        {
            Diff_AB[0] = A[0] - B[0];
            Diff_AB[1] = A[1] - B[1];
        }
    inline void Vec_Diff3(double A[3], double B[3], double Diff_AB[3])
        {
            Diff_AB[0] = A[0] - B[0];
            Diff_AB[1] = A[1] - B[1];
            Diff_AB[2] = A[2] - B[2];
        }
};

/***************************************************************************************/
/* constructor */
EOMSC::EOMSC()
{
    // init
    Num_Vtx_To_Smooth   = 0;
    Vtx_List_To_Smooth  = NULL;
    Num_Sweeps          = 0;
    New_Vtx_Coord       = NULL;
    Mesh                = NULL;
    // there should not be more than 1000 elements sharing a single vertex!
    Vtx_Star.elem.reserve(1000);

    Num_Vtx             = 0;
	GOT_BIAS_GRAD       = false;
    // init vertex information to NULL
    for (int ii = 0; (ii < 3); ii++)
		{
        Vtx_Coord[ii] = NULL;
		Bias_Grad[ii] = NULL;
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
EOMSC::~EOMSC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void EOMSC::Setup_Data(Mesh_Class_For_Star* Mesh_Input,   // inputs
                       const mxArray* mxVtx_List,         // inputs
                       const mxArray* mxNum_Sweep)        // inputs
{
    // access mesh data
    Mesh = Mesh_Input;

    // access vertex list to smooth
    if (mxGetClassID(mxVtx_List)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Vertex_Indices_To_Update must be uint32!");
    Num_Vtx_To_Smooth  = (int) mxGetM(mxVtx_List);
    const int Num_Col  = (const int) mxGetN(mxVtx_List);
    if (Num_Col != 1)
        {
        mexPrintf("ERROR: Vertex_Indices_To_Update has %d columns; expected 1 column.\n", Num_Col);
        mexErrMsgTxt("ERROR: Make sure it is a single column vector!");
        }
    Vtx_List_To_Smooth = (int*) mxGetPr(mxVtx_List);
    Num_Sweeps         = (int) (*mxGetPr(mxNum_Sweep));

    // create list of new vertex coordinates
    New_Vtx_Coord = mxDuplicateArray( Mesh->Return_MATLAB_Vtx_Coord() );

    // access those new vertex coordinates
    Vtx_Coord[0] = mxGetPr(New_Vtx_Coord);
    Num_Vtx      = Mesh->Get_Num_Nodes();
    for (int gd_i = 1; (gd_i < Mesh->Get_GeoDim()); gd_i++)
        Vtx_Coord[gd_i] = Vtx_Coord[gd_i-1] + Num_Vtx;
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void EOMSC::Setup_Bias_Gradient(const mxArray* mxBias_Grad)        // inputs
{
    // error check:
	const int Num_Row = (const int) mxGetM(mxBias_Grad);
	const int Num_Col = (const int) mxGetN(mxBias_Grad);
	const int MeshGeoDim = Mesh->Get_GeoDim();
	if (Num_Vtx!=Num_Row)
		{
		mexPrintf("ERROR: Bias_Gradient has %d rows; expected %d rows.\n", Num_Row, Num_Vtx);
		mexErrMsgTxt("ERROR: The Bias_Gradient data must have the same number of rows as the number of vertices in the mesh!");
		}
	if (MeshGeoDim!=Num_Col)
		{
		mexPrintf("ERROR: Bias_Gradient has %d columns; expected %d columns.\n", Num_Col, MeshGeoDim);
		mexErrMsgTxt("ERROR: The Bias_Gradient data must have the same number of columns as the geometric dimension of the mesh!");
		}

    // indicate that we have valid bias gradient data
	GOT_BIAS_GRAD = true;

    // access the bias gradient data
    Bias_Grad[0] = mxGetPr(mxBias_Grad);
    for (int gd_i = 1; (gd_i < MeshGeoDim); gd_i++)
        Bias_Grad[gd_i] = Bias_Grad[gd_i-1] + Num_Vtx;
}
/***************************************************************************************/


/***************************************************************************************/
/* run the E_ODT smoother several times */
void EOMSC::Run_Smoother()
{
    const int GD = Mesh->Get_GeoDim();

    if (GD==3)
        {
        for (int ind = 0; (ind < Num_Sweeps); ind++)
            Run_Smoother_Once_3D();
        }
    else if (GD==2)
        {
        for (int ind = 0; (ind < Num_Sweeps); ind++)
            Run_Smoother_Once_2D();
        }
    else if (GD==1)
        {
        for (int ind = 0; (ind < Num_Sweeps); ind++)
            Run_Smoother_Once_1D();
        }
    else
        {
        mexPrintf("ERROR: The mesh geometric dimension is %d.\n", GD);
        mexErrMsgTxt("ERROR: The mesh geometric dimension must be 1, 2, or 3!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* run smoother once (for 1-D meshes) */
void EOMSC::Run_Smoother_Once_1D()
{
    double Vtx_Update[1] = {0.0};
    for (int ind = 0; (ind < Num_Vtx_To_Smooth); ind++)
        {
        // get the current vertex index
        const int vi = Vtx_List_To_Smooth[ind] - 1; // C-style indexing
        Read_Vertex_Coord1(vi, Vtx_Update);

        // initialize
        double Vol = 0.0;
        double Weighted_Grad_Vol[1] = {0.0};

        Mesh->Read_Star_For_1D(vi, Vtx_Star); // read this before next line!
        Compute_E_ODT_Star_Gradient_wrt_Vtx2_1D(Vol, Weighted_Grad_Vol);

        // update center vertex
        Vtx_Update[0] = Vtx_Update[0] - 0.5 * (1.0/Vol) * Weighted_Grad_Vol[0];
        Write_Vertex_Coord1(vi, Vtx_Update);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the gradient of E_ODT with respect to the center vertex of the star,
   which is assumed to be local vertex #2.
   Note: "Vtx_Star" must be read in before this runs. */
void EOMSC::Compute_E_ODT_Star_Gradient_wrt_Vtx2_1D(double& Vol, double Weighted_Grad_Vol[1])
{
    // loop through the star
    for (int ti = 0; (ti < Vtx_Star.elem.size()); ti++)
        {
        double vol_temp;
        double vol_grad_temp[1];
        Compute_Weighted_Gradient_Of_T_Vol_wrt_Center_Vtx_1D(Vtx_Star.elem[ti].vtx_indices, vol_temp, vol_grad_temp);
        // add in contribution from one element
        Vol = Vol + vol_temp;
        Weighted_Grad_Vol[0] = Weighted_Grad_Vol[0] + vol_grad_temp[0];
        }
	if (Vol <= 0)
		{
		Star_Volume_Is_Degenerate_Message(Vtx_Star.center_vtx_index);
		Vol = 1.0;
		Weighted_Grad_Vol[0] = 0.0;
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the gradient of the volume of the element with respect to the
   center vertex position */
void EOMSC::Compute_Weighted_Gradient_Of_T_Vol_wrt_Center_Vtx_1D(int* vtx_indices, double& vol, double vol_grad[1])
{
    // read in the vertex coordinates
    double Vtx1[1];
    double Vtx2[1];
    Read_Vertex_Coord1(vtx_indices[0], Vtx1);
    Read_Vertex_Coord1(vtx_indices[1], Vtx2);

    // take the difference
    double d12[1];
    d12[0] = Vtx2[0] - Vtx1[0];

    // start computing gradient
    const int cv = Vtx_Star.center_vtx_index;
    if (cv==vtx_indices[0])
        vol_grad[0] = -1.0;
    else
        vol_grad[0] =  1.0;

    // compute volume of element
    vol = d12[0];

    // finish computing (weighted) gradient
    const double sum_sq = d12[0] * d12[0];
    vol_grad[0] = sum_sq * vol_grad[0];
}
/***************************************************************************************/


/***************************************************************************************/
/* run smoother once (for 2-D meshes) */
void EOMSC::Run_Smoother_Once_2D()
{
    double Vtx_Update[2] = {0.0, 0.0};
    for (int ind = 0; (ind < Num_Vtx_To_Smooth); ind++)
        {
        // get the current vertex index
        const int vi = Vtx_List_To_Smooth[ind] - 1; // C-style indexing
        Read_Vertex_Coord2(vi, Vtx_Update);

        // initialize
        double Vol = 0.0;
        double Weighted_Grad_Vol[2] = {0.0, 0.0};

        Mesh->Read_Star(vi, Vtx_Star); // read this before next line!
        Compute_E_ODT_Star_Gradient_wrt_Vtx2_2D(Vol, Weighted_Grad_Vol);

        // update center vertex
        Vtx_Update[0] = Vtx_Update[0] - 0.5 * (1.0/Vol) * Weighted_Grad_Vol[0];
        Vtx_Update[1] = Vtx_Update[1] - 0.5 * (1.0/Vol) * Weighted_Grad_Vol[1];
		// if (GOT_BIAS_GRAD)
			// {
			// Vtx_Update[0] = Vtx_Update[0] - Bias_Grad[0][vi];
			// Vtx_Update[1] = Vtx_Update[1] - Bias_Grad[1][vi];
			// }
        Write_Vertex_Coord2(vi, Vtx_Update);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the gradient of E_ODT with respect to the center vertex of the star,
   which is assumed to be local vertex #2.
   Note: "Vtx_Star" must be read in before this runs. */
void EOMSC::Compute_E_ODT_Star_Gradient_wrt_Vtx2_2D(double& Vol, double Weighted_Grad_Vol[2])
{
    // loop through the star
    for (int ti = 0; (ti < Vtx_Star.elem.size()); ti++)
        {
        double vol_temp;
        double vol_grad_temp[2];
        Compute_Weighted_Gradient_Of_T_Vol_wrt_Vtx2_2D(Vtx_Star.elem[ti].vtx_indices, vol_temp, vol_grad_temp);
        // add in contribution from one element
        Vol = Vol + vol_temp;
        Weighted_Grad_Vol[0] = Weighted_Grad_Vol[0] + vol_grad_temp[0];
        Weighted_Grad_Vol[1] = Weighted_Grad_Vol[1] + vol_grad_temp[1];
        }
	if (Vol <= 0)
		{
		Star_Volume_Is_Degenerate_Message(Vtx_Star.center_vtx_index);
		Vol = 1.0;
		Weighted_Grad_Vol[0] = 0.0;
		Weighted_Grad_Vol[1] = 0.0;
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the gradient of the volume of the element with respect to vertex #2 */
void EOMSC::Compute_Weighted_Gradient_Of_T_Vol_wrt_Vtx2_2D(int* vtx_indices, double& vol, double vol_grad[2])
{
    // read in the vertex coordinates
    double Vtx1[2];
    double Vtx2[2];
    double Vtx3[2];
    Read_Vertex_Coord2(vtx_indices[0], Vtx1);
    Read_Vertex_Coord2(vtx_indices[1], Vtx2);
    Read_Vertex_Coord2(vtx_indices[2], Vtx3);

    // take the difference
    double d12[2];
    double d13[2];
    double d23[2];
    Vec_Diff2(Vtx2, Vtx1, d12);
    Vec_Diff2(Vtx3, Vtx1, d13);
    Vec_Diff2(Vtx3, Vtx2, d23);

    // start computing gradient
    vol_grad[0] =  0.5 * d13[1];
    vol_grad[1] = -0.5 * d13[0];

    // compute volume of element
    vol = (d12[0]*vol_grad[0]) + (d12[1]*vol_grad[1]);

    // finish computing (weighted) gradient
    const double sum_sq = d12[0]*d12[0] + d12[1]*d12[1] + d23[0]*d23[0] + d23[1]*d23[1];
    vol_grad[0] = sum_sq * vol_grad[0];
    vol_grad[1] = sum_sq * vol_grad[1];
}
/***************************************************************************************/


/***************************************************************************************/
/* run smoother once (for 3-D meshes) */
void EOMSC::Run_Smoother_Once_3D()
{
    double Vtx_Update[3] = {0.0, 0.0, 0.0};
    for (int ind = 0; (ind < Num_Vtx_To_Smooth); ind++)
        {
        // get the current vertex index
        const int vi = Vtx_List_To_Smooth[ind] - 1; // C-style indexing
        Read_Vertex_Coord3(vi, Vtx_Update);

        // initialize
        double Vol = 0.0;
        double Weighted_Grad_Vol[3] = {0.0, 0.0, 0.0};

        Mesh->Read_Star(vi, Vtx_Star); // read this before next line!
        Compute_E_ODT_Star_Gradient_wrt_Vtx2_3D(Vol, Weighted_Grad_Vol);

        // update center vertex
        Vtx_Update[0] = Vtx_Update[0] - 0.5 * (1.0/Vol) * Weighted_Grad_Vol[0];
        Vtx_Update[1] = Vtx_Update[1] - 0.5 * (1.0/Vol) * Weighted_Grad_Vol[1];
		Vtx_Update[2] = Vtx_Update[2] - 0.5 * (1.0/Vol) * Weighted_Grad_Vol[2];
        Write_Vertex_Coord3(vi, Vtx_Update);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the gradient of E_ODT with respect to the center vertex of the star,
   which is assumed to be local vertex #2.
   Note: "Vtx_Star" must be read in before this runs. */
void EOMSC::Compute_E_ODT_Star_Gradient_wrt_Vtx2_3D(double& Vol, double Weighted_Grad_Vol[3])
{
    // loop through the star
    for (int ti = 0; (ti < Vtx_Star.elem.size()); ti++)
        {
        double vol_temp;
        double vol_grad_temp[3];
        Compute_Weighted_Gradient_Of_T_Vol_wrt_Vtx2_3D(Vtx_Star.elem[ti].vtx_indices, vol_temp, vol_grad_temp);
        // add in contribution from one element
        Vol = Vol + vol_temp;
        Weighted_Grad_Vol[0] = Weighted_Grad_Vol[0] + vol_grad_temp[0];
        Weighted_Grad_Vol[1] = Weighted_Grad_Vol[1] + vol_grad_temp[1];
		Weighted_Grad_Vol[2] = Weighted_Grad_Vol[2] + vol_grad_temp[2];
        }
	if (Vol <= 0)
		{
		Star_Volume_Is_Degenerate_Message(Vtx_Star.center_vtx_index);
		Vol = 1.0;
		Weighted_Grad_Vol[0] = 0.0;
		Weighted_Grad_Vol[1] = 0.0;
		Weighted_Grad_Vol[2] = 0.0;
		}
}
/***************************************************************************************/


/***************************************************************************************/
/* compute the gradient of the volume of the element with respect to vertex #2 */
void EOMSC::Compute_Weighted_Gradient_Of_T_Vol_wrt_Vtx2_3D(int* vtx_indices, double& vol, double vol_grad[3])
{
    // read in the vertex coordinates
    double Vtx1[3];
    double Vtx2[3];
    double Vtx3[3];
	double Vtx4[3];
    Read_Vertex_Coord3(vtx_indices[0], Vtx1);
    Read_Vertex_Coord3(vtx_indices[1], Vtx2);
    Read_Vertex_Coord3(vtx_indices[2], Vtx3);
    Read_Vertex_Coord3(vtx_indices[3], Vtx4);

    // take the difference
    double d12[3];
    double d13[3];
    double d14[3];
    double d23[3];
    double d24[3];
    Vec_Diff3(Vtx2, Vtx1, d12);
    Vec_Diff3(Vtx3, Vtx1, d13);
    Vec_Diff3(Vtx4, Vtx1, d14);
    Vec_Diff3(Vtx3, Vtx2, d23);
    Vec_Diff3(Vtx4, Vtx2, d24);

    // start computing gradient
    vol_grad[0] = (1.0/6.0) * ( (d13[1] * d14[2]) - (d13[2] * d14[1]) );
	vol_grad[1] = (1.0/6.0) * ( (d13[2] * d14[0]) - (d13[0] * d14[2]) );
	vol_grad[2] = (1.0/6.0) * ( (d13[0] * d14[1]) - (d13[1] * d14[0]) );
	
    // compute volume of element
    vol = (d12[0]*vol_grad[0]) + (d12[1]*vol_grad[1]) + (d12[2]*vol_grad[2]);

    // finish computing (weighted) gradient
    const double sum_sq = d12[0]*d12[0] + d12[1]*d12[1] + d12[2]*d12[2]
	                    + d23[0]*d23[0] + d23[1]*d23[1] + d23[2]*d23[2]
						+ d24[0]*d24[0] + d24[1]*d24[1] + d24[2]*d24[2];
    vol_grad[0] = sum_sq * vol_grad[0];
    vol_grad[1] = sum_sq * vol_grad[1];
	vol_grad[2] = sum_sq * vol_grad[2];
}
/***************************************************************************************/


/***************************************************************************************/
/* display degenerate star volume warning */
void EOMSC::Star_Volume_Is_Degenerate_Message(const int& vtx_index_c_style)
{
	mexPrintf("WARNING: The volume of the star of elements around vertex #%d is <= 0!  This vertex will *not* be updated!\n", vtx_index_c_style+1);
	mexPrintf("WARNING:     Make sure your mesh connectivity and vertex attachment data is correct.\n");
	//mexErrMsgTxt("ERROR: Fix your mesh and/or vertex attachment data structure!");
}
/***************************************************************************************/

#undef EOMSC

/***/
