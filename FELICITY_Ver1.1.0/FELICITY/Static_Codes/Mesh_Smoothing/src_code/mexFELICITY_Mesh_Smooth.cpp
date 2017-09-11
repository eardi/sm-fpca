/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with an optimization based
   mesh smoother.  It is based on the E_ODT functional.  The connectivity of the mesh
   is not changed.  Only the vertex positions are updated.
   See other accompanying files for more details.

   NOTE: this code is part of the FELICITY package:
   Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   plhs[0] = VTX
   VTX     = New Vertex Coordinates (N x D), where N is the number of vertices,
                                             and   D is the geometric dimension.

   see below (in main body) for more info.

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!
             Only FULL matrices are allowed as inputs!

   Copyright (c) 04-23-2013,  Shawn W. Walker
============================================================================================
*/

// include any libraries you need here
#include <algorithm>
#include <vector>
#include <math.h>
#include <mex.h> // <-- This one is required

// define input indices
#define PRHS_Mesh                                               0
#define PRHS_Vertex_Attachments                                 1
#define PRHS_Vertex_Indices_To_Update                           2
#define PRHS_Num_Sweeps                                         3
#define PRHS_Bias_Gradient                                      4

/* include classes and other sub-routines */
#include "Base_Mesh_Class.cc"
#include "Mesh_Class_For_Star.cc"
#include "E_ODT_Mesh_Smoother.cc"


// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* BEGIN: Error Checking */
    if (nrhs!= 4)
        {
        mexPrintf("mexFELICITY_Mesh_Smooth:\n");
        mexPrintf("\n");
        mexPrintf("ERROR: need 4 inputs!\n");
        mexPrintf("\n");
        mexPrintf("      Note: curly braces {} indicates a cell array.\n");
        mexPrintf("\n");
        mexPrintf("      INPUTS                                                               ORDER \n");
        mexPrintf("      -------------------                                                  ----- \n");
        mexPrintf("      {Vertex_Coordinates, Element_Connectivity (type is uint32)}            0 \n");
        mexPrintf("      Vertex_Attachments                                                     1 \n");
        mexPrintf("      Vertex_Indices_To_Update (type is uint32)                              2 \n");
        mexPrintf("      Number_of_Sweeps (number of times to sweep the mesh)                   3 \n");
		//mexPrintf("      Bias Gradient (optional)                                               4 \n");
        mexPrintf("\n");
        mexPrintf("      OUTPUTS (in consecutive order) \n");
        mexPrintf("      ---------------------------------------- \n");
        mexPrintf("      Vertex_Coordinates (new)\n");
        mexPrintf("\n");
        mexErrMsgTxt("Check the number of input arguments!");
        }
    if (nlhs!=1) mexErrMsgTxt("1 output is required!");
    /* END: Error Checking */

    // declare mesh object
    Mesh_Class_For_Star   Mesh;
    Mesh.Setup_Mesh(prhs[PRHS_Mesh],prhs[PRHS_Vertex_Attachments]);
	
	// declare mesh smoother object
	E_ODT_Mesh_Smoother_Class  Smoother;
	Smoother.Setup_Data(&Mesh, prhs[PRHS_Vertex_Indices_To_Update], prhs[PRHS_Num_Sweeps]);
	
	//if (nrhs==5) Smoother.Setup_Bias_Gradient(prhs[PRHS_Bias_Gradient]);
	
	Smoother.Run_Smoother();
	
	// output new vertices
	plhs[0] = Smoother.New_Vtx_Coord;
}

/***/
