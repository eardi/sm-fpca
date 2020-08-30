/*
============================================================================================
   This is the main "gateway" routine that interfaces MATLAB with my own isosurface
   2D triangle mesh generation algorithm (TIGER).


   NOTE: this code is part of the FELICITY package:
   Finite ELement Implementation and Computational Interface Tool for You

   To see the inputs and outputs, compile the mex file and run it without arguments;
   or look at the "print" messages below.

   Copyright (c) 01-01-2012,  Shawn W. Walker
============================================================================================
*/

// include any libraries you need here
#include <math.h>
#include <mex.h> // <-- This one is required
#include <time.h>

// define input indices
#define PRHS_bcc_mesh                                           0
#define PRHS_cut_info                                           1
#define PRHS_ls_val                                             2
// define output indices
#define PLHS_out_tri                                            0
#define PLHS_out_vtx                                            1
#define PLHS_out_inmsk                                          2
#define PLHS_out_ambind                                         3

/* include classes and other sub-routines */
#include <algorithm>
#include "../src_hdr/Generic_Data.cc"
#include "bcc_mesh.cc"
#include "cut_info.cc"
#include "meshgen_algorithm.cc"


// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* BEGIN: Error Checking */
    if (nrhs!=3)
        {
        mexPrintf("mexMeshGen_2D:\n");
        mexPrintf("\n");
        mexPrintf("ERROR: need exactly 3 inputs!\n");
        mexPrintf("\n");
        mexPrintf("      Note: curly braces {} indicates a cell array.\n");
        mexPrintf("\n");
        mexPrintf("      INPUTS                                                               ORDER \n");
        mexPrintf("      -------------------                                                  ----- \n");
        mexPrintf("      bcc_mesh: (Body-Centered-Cubic Mesh Data) struct of the form:          0 \n");
        mexPrintf("                .V = vertex coordinates (Px2 array)\n");
        mexPrintf("                .T = triangle data (Qx3 array)\n");
        mexPrintf("                .edge: mesh edge info:\n");
        mexPrintf("                       .short = short edge data (Nx2 array)\n");
        mexPrintf("                       .long  =  long edge data (Mx2 array)\n");
        mexPrintf("                       .short_attach = triangle indices attached to short edges {Nx1 cell array}\n");
        mexPrintf("                       .long_attach  = triangle indices attached to long  edges {Mx1 cell array}\n");
        mexPrintf("                       .short_bdy_indicator = logical indices indicating if short edges are on the boundary of the BCC mesh (Nx1 logical array)\n");
        mexPrintf("                       .long_bdy_indicator  = similar, except for long edges (Mx1 logical array)\n");
        mexPrintf("                       .len.short    =  length of short edges\n");
        mexPrintf("                       .len.long     =  length of long  edges\n");
        mexPrintf("                .vertex: mesh vertex info:\n");
        mexPrintf("                       .attach        = triangle indices attached to vertices {Px1 cell array}\n");
        mexPrintf("                       .bdy_indicator = logical indices indicating if vertices are on the boundary of the BCC mesh (Px1 logical array)\n");
        mexPrintf("\n");
        mexPrintf("      cut_info: (mesh edges cut by an isosurface) struct of the form:        1 \n");
        mexPrintf("                .short: struct of the form:\n");
        mexPrintf("                        .edge_indices = list of global (short) edge indices that are cut by isosurface (Rx1 array)\n");
        mexPrintf("                        .points       = list of cut point coordinates (corresponds to .edge_indices) (Rx3 array)\n");
        mexPrintf("                        .V2E          = vertex-to-(short)cut edge index data (PxP sparse matrix)\n");
        mexPrintf("                .long:  (similar to '.short' except for the cut long edges of the mesh)\n");
        mexPrintf("\n");
        mexPrintf("      LS_value: level set values at each BCC mesh vertex (Px1 array)         2 \n");
        mexPrintf("\n");
        mexPrintf("      OUTPUTS (in consecutive order) \n");
        mexPrintf("      ---------------------------------------- \n");
        mexPrintf("      Triangle Connectivity (new)\n");
        mexPrintf("      Vertex Coordinates (new)\n");
        mexPrintf("      Inside/Outside Mask\n");
        mexPrintf("      Ambiguous Triangle Indices\n");
        mexPrintf("\n");
        mexErrMsgTxt("Check the number of input arguments!");
        }
    if (nlhs!=4) mexErrMsgTxt("4 outputs are required!");
    /* END: Error Checking */

    // stuff for generating timings
	int t0, t1, diff;

    t0 = clock();
    // read outside mesh data
    BCC_Mesh_Class   BCC_Mesh;
    BCC_Mesh.Setup_Data(prhs[PRHS_bcc_mesh]);
    // read outside cut edge information
    CUT_Info_Class   CUT_Info;
    CUT_Info.Setup_Data(prhs[PRHS_cut_info],&BCC_Mesh);

    // declare mesh generation object
    MeshGen_Algorithm_Class  MG;
    MG.Setup_Data(&BCC_Mesh,&CUT_Info,prhs[PRHS_ls_val]);
    // init output data (must be done after .Setup_Data)
    plhs[PLHS_out_tri]    = MG.mxOutTri;
    plhs[PLHS_out_vtx]    = MG.mxOutVtx;
    plhs[PLHS_out_inmsk]  = MG.mxOutInMsk;
	t1 = clock();
	diff = t1 - t0;
	mexPrintf("Step (2+) Timing (setting up data): %2.3f sec\n",((double)diff)/CLOCKS_PER_SEC);

    /*** execute mesh generation algorithm ***/
    mexPrintf("======================================================\n");
    mexPrintf("Begin Mesh Generation...\n");

    t0 = clock();
    MG.Initial_Vertex_Labeling();
	t1 = clock();
	diff = t1 - t0;
	mexPrintf("Step (3) Timing: %2.3f sec\n",((double)diff)/CLOCKS_PER_SEC);

	t0 = clock();
    MG.Run_Back_Labeling();
    t1 = clock();
	diff = t1 - t0;
    mexPrintf("Step (4) Timing: %2.3f sec\n",((double)diff)/CLOCKS_PER_SEC);

	t0 = clock();
    MG.Find_Long_Edges_With_Manifold_End_Points();

    MG.Perform_Edge_Flips();

    MG.Find_Isolated_Ambiguous_Tri();

    MG.Choose_Inside_Outside_Tri();

    plhs[PLHS_out_ambind] = MG.mxOutAmbIndices; // don't forget to pass it...
    t1 = clock();
	diff = t1 - t0;
    mexPrintf("Steps (5)-(8) Timing: %2.3f sec\n",((double)diff)/CLOCKS_PER_SEC);
	
    mexPrintf("\n");
    mexPrintf("Mesh Generation Complete!\n");
    mexPrintf("======================================================\n\n");
}

/***/
