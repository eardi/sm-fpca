/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a custom generated
   FE matrix assembler.  See other accompanying files for more details.

   NOTE: this code was generated from the FELICITY package:
         Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   plhs[0] = FEM(1).MAT, FEM(1).Type, FEM(2).MAT, FEM(2).Type, etc...

   NOTE: portions of this code are automatically generated!

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!!!
             Only FULL matrices are allowed as inputs!!!
             EXCEPTION: the first input has an identical structure to the output.

   Copyright (c) 01-25-2013,  Shawn W. Walker
============================================================================================
*/

// default libraries you need
#include <algorithm>
#include <cstring>
#include <math.h>
#include <mex.h> // <-- This one is required

/*------------ BEGIN: Auto Generate ------------*/
// define input indices
#define PRHS_OLD_FEM                                                           0
#define PRHS_Omega_Mesh_Vertices                                               1
#define PRHS_Omega_Mesh_DoFmap                                                 2
#define PRHS_EMPTY_1                                                           3
#define PRHS_Omega_Mesh_Subdomains                                             4
#define PRHS_E_Space_DoFmap                                                    5
#define PRHS_M_Space_DoFmap                                                    6
#define PRHS_U_Space_DoFmap                                                    7
#define PRHS_old_soln_Values                                                   8
/*------------   END: Auto Generate ------------*/

/* include classes and other sub-routines */
#include "Misc_Stuff.h"
#include "Generic_FEM_Assembly.h"
#include "Generic_FEM_Assembly.cc"

// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /*------------ BEGIN: Auto Generate ------------*/
    /* BEGIN: Error Checking */
    if (nrhs!=9)
        {
        mexPrintf("ERROR: 9 inputs required!\n");
        mexPrintf("\n");
        mexPrintf("      INPUTS                                                          ORDER \n");
        mexPrintf("      -------------------                                             ----- \n");
        mexPrintf("      OLD_FEM                                                           0 \n");
        mexPrintf("      Omega_Mesh_Vertices                                               1 \n");
        mexPrintf("      Omega_Mesh_DoFmap                                                 2 \n");
        mexPrintf("      EMPTY_1                                                           3 \n");
        mexPrintf("      Omega_Mesh_Subdomains                                             4 \n");
        mexPrintf("      E_Space_DoFmap                                                    5 \n");
        mexPrintf("      M_Space_DoFmap                                                    6 \n");
        mexPrintf("      U_Space_DoFmap                                                    7 \n");
        mexPrintf("      old_soln_Values                                                   8 \n");
        mexPrintf("\n");
        mexPrintf("      OUTPUTS (in consecutive order) \n");
        mexPrintf("      ---------------------------------------- \n");
        mexPrintf("      Bdy_Mass \n");
        mexPrintf("      Bdy_Vec \n");
        mexPrintf("      Mass_Matrix \n");
        mexPrintf("\n");
        mexErrMsgTxt("Check the number of input arguments!");
        }
    if (nlhs!=1) mexErrMsgTxt("1 output is required!");
    /* END: Error Checking */
    /*------------   END: Auto Generate ------------*/


    // declare the FEM assembler object
    Generic_FEM_Assembly*   FEM_Assem_obj;
    FEM_Assem_obj = new Generic_FEM_Assembly(prhs);

    /*** Assemble FEM Matrices ***/
    FEM_Assem_obj->Assemble_Matrices();

    // create the sparse matrices and output them to MATLAB
    FEM_Assem_obj->Init_Output_Matrices(plhs);
    FEM_Assem_obj->Output_Matrices(plhs);

    delete(FEM_Assem_obj);
}

/***/
