/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a Hamilton-Jacobi
   solver on unstructured triangular meshes.

   NOTE: this code is now part of the FELICITY package:
   Finite ELement Interface and Computational Implementation Tool (for You).


   OUTPUTS
   -------
   plhs[0] = Hamilton-Jacobi solution (as a piecewise linear function over the triangulation)
   plhs[1] = max L^\infty error between the last two iterations

   INPUTS
   ------
   Mesh_Vertex_Coord         = prhs[0]
   Tri_Elements              = prhs[1]
   Tri_Neighbor_Data         = prhs[2]  <-- NOTE: a sparse array
   Fixed_Node_List           = prhs[3]  <-- e.g. the boundary nodes
   Adjacent_Node_List        = prhs[4]  <-- i.e. the nodes adjacent to the fixed/boundary nodes
   Initial_Soln              = prhs[5]  <-- i.e. the Dirichlet data
   Parameters                = prhs[6]
   Matrix                    = prhs[7]  <-- a struct that has the given distance metric to use

   See other files for more info.

   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

// include any C++ libraries you need here
#include <math.h> // <-- This is needed because on Linux no fabs-command in std available
#include <mex.h>  // <-- This one is required

// define input indices
#define INPUT_Vertex_Coord         0
#define INPUT_Tri_Elements         1
#define INPUT_Tri_Neighbor_Data    2
#define INPUT_Fixed_Node_List      3
#define INPUT_Adj_Node_List        4
#define INPUT_Initial_Soln         5
#define INPUT_Parameters           6
#define INPUT_Mat                  7

/* include classes and other sub-routines */
#include "Misc_Stuff.h"
#include "HJB_Solver.cc"


// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* BEGIN: Error Checking */
    if (nrhs!=8) mexErrMsgTxt("8 inputs required!");
    if (nlhs!=2) mexErrMsgTxt("2 outputs required!");
    /* END: Error Checking */

    // declare the HJB solver
    HJB_Solver Solver_Obj;
    // initialize solver stuff
    Solver_Obj.Init(prhs);
    // setup the output data
    Solver_Obj.Setup_Output(prhs[INPUT_Initial_Soln],  plhs);

    // solve it!
    Solver_Obj.Compute_Soln();
}

/***/
