/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a LEPP (Longest Edge
   Propagation Path) bisection routine for 2-D triangulations (see Rivara, et al).
   See other accompanying files for more details.

   NOTE: this code is part of the FELICITY package:
   Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   plhs[0] = {VTX, TRI},
   VTX     = New Vertex Coordinates (N x D), where N is the number of vertices,
                                             and   D is the geometric dimension.
   TRI     = New Triangle (connectivity) Data (M x 3), where M is the number of triangles.

   see below (in main body) for more info.

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!
             Only FULL matrices are allowed as inputs!

   Copyright (c) 09-12-2011,  Shawn W. Walker
============================================================================================
*/

// include any libraries you need here
#include <algorithm>
#include <cstring>
#include <math.h>
#include <mex.h> // <-- This one is required

// define input indices
#define PRHS_Mesh                                               0
#define PRHS_Triangle_Neighbor_Data                             1
#define PRHS_Marked_Triangles                                   2
#define PRHS_Subdomain                                          3

/* include classes and other sub-routines */
#include "Generic_Data.cc"
#include "Subdomain_Data.cc"
#include "Rivara_Bisection.cc"
#include "Triangle_Mesh.cc"


// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* BEGIN: Error Checking */
    if (nrhs<3)
        {
        mexPrintf("mexLEPP_Bisection_2D:\n");
        mexPrintf("\n");
        mexPrintf("ERROR: need at least 3 inputs!\n");
        mexPrintf("\n");
        mexPrintf("      Note: curly braces {} indicates a cell array.\n");
        mexPrintf("\n");
        mexPrintf("      INPUTS                                                               ORDER \n");
        mexPrintf("      -------------------                                                  ----- \n");
        mexPrintf("      {Vertex_Coordinates, Triangle_Connectivity (type is uint32)}           0 \n");
        mexPrintf("      Triangle_Neighbor_Data (type is uint32)                                1 \n");
        mexPrintf("      Marked_Triangles (type is uint32)                                      2 \n");
        mexPrintf("      Subdomain: (optional) an array of structs of the form:                 3 \n");
        mexPrintf("                .Name = 'string'\n");
        mexPrintf("                .Dim  = topological dimension\n");
        mexPrintf("                .Data = pointer data for embedded subdomains (type is int32)\n");
        mexPrintf("\n");
        mexPrintf("      OUTPUTS (in consecutive order) \n");
        mexPrintf("      ---------------------------------------- \n");
        mexPrintf("      {Vertex_Coordinates, Triangle_Connectivity} (new)\n");
        mexPrintf("      Triangle_Neighbor_Data (new)\n");
        mexPrintf("      Subdomain (new)\n");
        mexPrintf("\n");
        mexErrMsgTxt("Check the number of input arguments!");
        }
    if (nlhs<1) mexErrMsgTxt("At least 1 output is required!");
    /* END: Error Checking */

    // declare mesh object
    Triangle_Mesh_Class   Mesh;
    Mesh.Setup_Data(nrhs, prhs);

    Mesh.Execute_Rivara_Bisection();

    Mesh.Output_Final_Data(nlhs, plhs);
}

/***/
