/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a custom generated
   FE interpolator.  See other accompanying files for more details.

   NOTE: this code was generated from the FELICITY package:
         Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   plhs[0] = INTERP(1).DATA{:}, INTERP(1).Name, INTERP(2).DATA{:}, INTERP(2).Name, etc...

   NOTE: portions of this code are automatically generated!

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!!!
             Only FULL matrices are allowed as inputs!!!

   Copyright (c) 01-29-2013,  Shawn W. Walker
============================================================================================
*/

// default libraries you need
#include <algorithm>
#include <cstring>
#include <math.h>
#include <mex.h> // <-- This one is required

/*------------ BEGIN: Auto Generate ------------*/
// define input indices
#define PRHS_Hold_All_Mesh_Vertices                                            0
#define PRHS_Hold_All_Mesh_DoFmap                                              1
#define PRHS_EMPTY_1                                                           2
#define PRHS_EMPTY_2                                                           3
#define PRHS_Hold_All_Interp_Data                                              4
#define PRHS_GS_DoFmap                                                         5
#define PRHS_f_Values                                                          6
/*------------   END: Auto Generate ------------*/

/* include classes and other sub-routines */
#include "Misc_Stuff.h"
#include "Generic_FEM_Interpolation.h"
#include "Generic_FEM_Interpolation.cc"

// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /*------------ BEGIN: Auto Generate ------------*/
    /* BEGIN: Error Checking */
    if (nrhs!=7)
        {
        mexPrintf("ERROR: 7 inputs required!\n");
        mexPrintf("\n");
        mexPrintf("      INPUTS                                                          ORDER \n");
        mexPrintf("      -------------------                                             ----- \n");
        mexPrintf("      Hold_All_Mesh_Vertices                                            0 \n");
        mexPrintf("      Hold_All_Mesh_DoFmap                                              1 \n");
        mexPrintf("      EMPTY_1                                                           2 \n");
        mexPrintf("      EMPTY_2                                                           3 \n");
        mexPrintf("      Hold_All_Interp_Data                                              4 \n");
        mexPrintf("      GS_DoFmap                                                         5 \n");
        mexPrintf("      f_Values                                                          6 \n");
        mexPrintf("\n");
        mexPrintf("      OUTPUTS (in consecutive order) \n");
        mexPrintf("      ---------------------------------------- \n");
        mexPrintf("      I_h_f \n");
        mexPrintf("\n");
        mexErrMsgTxt("Check the number of input arguments!");
        }
    if (nlhs!=1) mexErrMsgTxt("1 output is required!");
    /* END: Error Checking */
    /*------------   END: Auto Generate ------------*/


    // declare the FEM interpolation object
    Generic_FEM_Interpolation*   FEM_Interp_obj;
    FEM_Interp_obj = new Generic_FEM_Interpolation(prhs);

    /*** Interpolate! ***/
    FEM_Interp_obj->Evaluate_Interpolations();
	
	// output interpolations back to MATLAB
    FEM_Interp_obj->Init_Output_Data(plhs);
    FEM_Interp_obj->Output_Interpolations(plhs);

    delete(FEM_Interp_obj);
}

/***/
