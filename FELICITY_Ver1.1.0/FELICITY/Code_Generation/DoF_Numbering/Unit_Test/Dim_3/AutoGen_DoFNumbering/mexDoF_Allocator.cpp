/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with a custom
   FEM Degree-of-Freedom (DoF) allocator for a particular finite element.

   NOTE: this code is part of the FELICITY package:
   Finite ELement Implementation and Computational Interface Tool for You

   OUTPUTS
   -------
   Matrix where each row is the local-to-global DoF map for an element in the mesh.
   (see code below for more info)

   NOTE: portions of this code are automatically generated!

   WARNING!: Make sure all inputs to this mex function are NOT sparse matrices!!!
             Only FULL matrices are allowed as inputs!!!

   Copyright (c) 05-21-2013,  Shawn W. Walker
============================================================================================
*/

// include any libraries you need here
#include <algorithm>
#include <mex.h> // <-- This one is required

/*------------ BEGIN: Auto Generate ------------*/
// define  input indices
#define PRHS_Tet_List                                                         0

// define output indices
#define PLHS_Elem1_Test_DoF_Map                                               0
#define PLHS_Elem2_Test_DoF_Map                                               1
#define PLHS_Elem3_Test_DoF_Map                                               2
#define PLHS_Elem4_Test_DoF_Map                                               3
#define PLHS_Elem5_Test_DoF_Map                                               4
/*------------   END: Auto Generate ------------*/

/* include classes and other sub-routines */
#include "Misc_Files.h"
#include "Tetrahedron_Data.cc"
#include "Elem1_Test_DoF_Allocator.cc"
#include "Elem2_Test_DoF_Allocator.cc"
#include "Elem3_Test_DoF_Allocator.cc"
#include "Elem4_Test_DoF_Allocator.cc"
#include "Elem5_Test_DoF_Allocator.cc"


// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /*------------ BEGIN: Auto Generate ------------*/
    /* BEGIN: Error Checking */
    if (nrhs!=1)
        {
        printf("ERROR: 1 inputs required!\n");
        printf("\n");
        printf("      INPUTS                                                         ORDER \n");
        printf("      -------------------                                            ----- \n");
        printf("      Tet_List                                                         0 \n");
        printf("\n");
        printf("      OUTPUTS                                                        ORDER \n");
        printf("      -------------------                                            ----- \n");
        printf("      Elem1_Test_DoF_Map                                               0 \n");
        printf("      Elem2_Test_DoF_Map                                               1 \n");
        printf("      Elem3_Test_DoF_Map                                               2 \n");
        printf("      Elem4_Test_DoF_Map                                               3 \n");
        printf("      Elem5_Test_DoF_Map                                               4 \n");
        printf("\n");
        mexErrMsgTxt("Check the number of input arguments!");
        }
    if ((nlhs < 1)||(nlhs > 5)) mexErrMsgTxt("1~5 outputs are needed!");
    /* END: Error Checking */
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // declare tetrahedron data object
    TETRAHEDRON_DATA    Tet_Data;
    Tet_Data.Setup_Mesh(prhs[PRHS_Tet_List]);

    // declare DoF allocator
    Elem1_Test_DoF_Allocator      Elem1_Test_DoF_Obj;
    // do some initial allocation
    plhs[PLHS_Elem1_Test_DoF_Map] = Elem1_Test_DoF_Obj.Init_DoF_Map(Tet_Data.Num_Tet);
    // create the DoFmap
    Elem1_Test_DoF_Obj.Fill_DoF_Map(&Tet_Data);

    // declare DoF allocator
    Elem2_Test_DoF_Allocator      Elem2_Test_DoF_Obj;
    // do some initial allocation
    plhs[PLHS_Elem2_Test_DoF_Map] = Elem2_Test_DoF_Obj.Init_DoF_Map(Tet_Data.Num_Tet);
    // create the DoFmap
    Elem2_Test_DoF_Obj.Fill_DoF_Map(&Tet_Data);

    // declare DoF allocator
    Elem3_Test_DoF_Allocator      Elem3_Test_DoF_Obj;
    // do some initial allocation
    plhs[PLHS_Elem3_Test_DoF_Map] = Elem3_Test_DoF_Obj.Init_DoF_Map(Tet_Data.Num_Tet);
    // create the DoFmap
    Elem3_Test_DoF_Obj.Fill_DoF_Map(&Tet_Data);

    // declare DoF allocator
    Elem4_Test_DoF_Allocator      Elem4_Test_DoF_Obj;
    // do some initial allocation
    plhs[PLHS_Elem4_Test_DoF_Map] = Elem4_Test_DoF_Obj.Init_DoF_Map(Tet_Data.Num_Tet);
    // create the DoFmap
    Elem4_Test_DoF_Obj.Fill_DoF_Map(&Tet_Data);

    // declare DoF allocator
    Elem5_Test_DoF_Allocator      Elem5_Test_DoF_Obj;
    // do some initial allocation
    plhs[PLHS_Elem5_Test_DoF_Map] = Elem5_Test_DoF_Obj.Init_DoF_Map(Tet_Data.Num_Tet);
    // create the DoFmap
    Elem5_Test_DoF_Obj.Fill_DoF_Map(&Tet_Data);

    /*------------   END: Auto Generate ------------*/

    // output the Euler characteristic of the domain
    const int CHI = Tet_Data.Num_Unique_Vertices - Tet_Data.Num_Unique_Edges + Tet_Data.Num_Unique_Faces - Tet_Data.Num_Tet;
    const bool INVALID = (Tet_Data.Num_Unique_Vertices==0) || (Tet_Data.Num_Unique_Edges==0) || (Tet_Data.Num_Unique_Faces==0) || (Tet_Data.Num_Tet==0);
    if (!INVALID)
        {
        mexPrintf("Euler Characteristic of the Domain: CHI = V - E + F - T\n");
        mexPrintf("                                     %d = %d - %d + %d - %d \n",CHI,Tet_Data.Num_Unique_Vertices,Tet_Data.Num_Unique_Edges,Tet_Data.Num_Unique_Faces,Tet_Data.Num_Tet);
        }
}

/***/
