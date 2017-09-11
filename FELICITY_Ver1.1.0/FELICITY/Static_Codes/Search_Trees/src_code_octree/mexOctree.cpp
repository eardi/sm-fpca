/*
============================================================================================
   This is the main "gateway" routine for point searching with a point-region (PR) OCTREE.
   It uses the tree traversal methods from the following paper:
   
   S. F. Frisken and R. N. Perry,
   ``Simple and Efficient Traversal Methods for Quadtrees and Octrees,''
   Journal of Graphics Tools, 2002, Vol. 7, pg. 1-11

   NOTE: this code is part of the FELICITY package:
   Finite ELement Implementation and Computational Interface Tool (for You).


   COMMAND STRINGS
   ---------------
   The following methods are interfaced below:
       'new'         = create and build a new tree.
	   'delete'      = delete a C++ instance of the tree class.
	   'print_tree'  = prints info (text to MATLAB display) about the tree cells.
	   'tree_data'   = collects data about the tree and returns it to MATLAB.
	   'knn_search'  = k-nearest neighbor search.
	   'update_tree' = update the tree structure using new point positions.

   OUTPUTS
   -------
   Depends on how this is called (see below).

   INPUTS
   ------
   See below.

   See other files for more info.

   Copyright (c) 01-14-2014,  Shawn W. Walker   ---   email:  walker@math.lsu.edu
============================================================================================
*/

// include any C++ libraries you need here
#include <math.h> // <-- This is needed because on Linux no fabs-command in std available
#include <mex.h>  // <-- This one is required

// define input indices for creating the octree
#define INPUT_Command_String          0
#define INPUT_Points                  1
#define INPUT_Bounding_Box            2
#define INPUT_Max_Tree_Levels         3
#define INPUT_Bucket_Size             4

/* include classes and other sub-routines */
#include "../src_hdr/class_handle.hpp"
#include "../src_hdr/MATLAB_Matrix_ReadOnly.cc"
#include "../src_hdr/MATLAB_Matrix_ReadWrite.cc"
#include "../src_hdr/basetree.cc"
#include "octree.cc"

// note: 'prhs' represents the Right-Hand-Side arguments from MATLAB (inputs)
//       'plhs' represents the  Left-Hand-Side arguments from MATLAB (outputs)


/***************************************************************************************/
// define the "gateway" function
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // get the command string
    char cmd[64];
    if (nrhs < 1 || mxGetString(prhs[INPUT_Command_String], cmd, sizeof(cmd)))
        {
        mexPrintf("mexOctree:\n");
        mexPrintf("\n");
        mexPrintf("ERROR: first input should be a command string less than 64 characters long.\n");
        mexPrintf("\n");
        mexPrintf("       List of Acceptable Command Strings:\n");
        mexPrintf("       -----------------------------------\n");
        mexPrintf("       'new'\n");
        mexPrintf("       'delete'\n");
        mexPrintf("       'print_tree'\n");
		mexPrintf("       'tree_data'\n");
        mexPrintf("       'knn_search'\n");
        mexPrintf("       'update_tree'\n");
        mexPrintf("\n");
        mexPrintf("       The number of additional inputs depends on the command string.\n");
        mexErrMsgTxt("Check your inputs!");
        }

    // if we are creating a new instance (and, thus, building the tree), then
    if (!strcmp("new", cmd))
        {
        /* BEGIN: Error Checking */
        if ( (nrhs>5) || (nlhs!=1) )
            {
            mexPrintf("mexOctree: 'new'\n");
            mexPrintf("\n");
            mexPrintf("ERROR: need 2~5 inputs and 1 output!\n");
            mexPrintf("\n");
            mexPrintf("      INPUTS                                                               ORDER \n");
            mexPrintf("      -------------------------------------------------                    ----- \n");
            mexPrintf("      Command String = 'new'                                                 0 \n");
            mexPrintf("      Points (Mx3 matrix of point coordinates)                               1 \n");
            mexPrintf("      Bounding Box Coordinates: [Min_X, Max_X, Min_Y, Max_Y, Min_Z, Max_Z]   2 \n");
            mexPrintf("        (Default = [Min_X - Ex, Max_X + Ex,\n");
			mexPrintf("                    Min_Y - Ey, Max_Y + Ey,\n");
			mexPrintf("                    Min_Z - Ez, Max_Z + Ez], where\n");
            mexPrintf("         Ex = 0.001 * (Max_X - Min_X),\n");
			mexPrintf("         Ey = 0.001 * (Max_Y - Min_Y),\n");
			mexPrintf("         Ez = 0.001 * (Max_Z - Min_Z),\n");
            mexPrintf("         and  Min_X, ..., Max_Z are the bounds of Points.)\n");
            mexPrintf("      Max_Levels  (default = 32) (max octree levels; at least 2!)            3 \n");
            mexPrintf("      Bucket_Size (default = 20) (max points to store in a octree cell)      4 \n");
            mexPrintf("\n");
            mexPrintf("      OUTPUT\n");
            mexPrintf("      ------------------------------------------------- \n");
            mexPrintf("      'Pointer' (handle) to the C++ octree class instance\n");
            mexPrintf("\n");
            mexErrMsgTxt("Check the arguments!");
            }
        /* END: Error Checking */

        // declare the object
        octree*  Oc_Tree_Obj;
        Oc_Tree_Obj = new octree;

        /* pass the inputs */

        // setup input point data
        Oc_Tree_Obj->Points.Setup_Data(prhs[INPUT_Points]);
        pt_type  Min_X, Max_X, Min_Y, Max_Y, Min_Z, Max_Z;
        Oc_Tree_Obj->Get_Bounding_Box_From_Points(Min_X, Max_X, Min_Y, Max_Y, Min_Z, Max_Z);

        // set the size of the root node of the tree (i.e. the big bounding box)
        if (nrhs>=3) // let the user set the bounding box
            Oc_Tree_Obj->Set_Bounding_Box_From_User(Min_X, Max_X, Min_Y, Max_Y,
			                                        Min_Z, Max_Z, prhs[INPUT_Bounding_Box]);
        else // set a default bounding box
            Oc_Tree_Obj->Set_Bounding_Box_DEFAULT(Min_X, Max_X, Min_Y, Max_Y, Min_Z, Max_Z);

        // declare max number of levels for the octree (i.e. the depth of the tree)
        if (nrhs>=4)
            {
            const UINT_type Max_Levels = (UINT_type) *mxGetPr(prhs[INPUT_Max_Tree_Levels]);
            Oc_Tree_Obj->Setup_Levels(Max_Levels);
            }
        // declare the max number of points to store in any leaf node
        if (nrhs>=5)
            {
            const UINT_type Bucket = (UINT_type) *mxGetPr(prhs[INPUT_Bucket_Size]);
            Oc_Tree_Obj->Setup_Bucket_Size(Bucket);
            }

        // build the tree
        Oc_Tree_Obj->Build_Tree();

        // Return a handle to the new C++ instance
        plhs[0] = convertPtr2Mat<octree>(Oc_Tree_Obj);
        return;
        }

    // otherwise, the second input should be the class instance handle
    if (nrhs < 2)
        mexErrMsgTxt("Second input should be a C++ octree class instance handle.");

    // Delete
    if (!strcmp("delete", cmd))
        {
        // Destroy the C++ object
        destroyObject<octree>(prhs[1]);
        // Warn if other commands were ignored
        if (nlhs > 0 || nrhs > 2)
           mexWarnMsgTxt("delete: does not require additional inputs or any outputs.");
        return;
        }

    // otherwise, the object was created before, so
    //    get the C++ octree instance pointer from the second input
    octree* Oc_Tree_Obj = convertMat2Ptr<octree>(prhs[1]);

    // print the octree partition as ASCII text
    if (!strcmp("print_tree", cmd))
        {
        // Check parameters
        if ((nlhs!=0) || (nrhs!=2))
            {
            mexPrintf("mexOctree: 'print_tree'\n");
            mexPrintf("\n");
            mexPrintf("ERROR: need 2 inputs and 0 outputs!\n");
            mexPrintf("\n");
            mexPrintf("      INPUTS                                                               ORDER \n");
            mexPrintf("      -------------------------------------------------                    ----- \n");
            mexPrintf("      Command String = 'print_tree'                                          0 \n");
            mexPrintf("      'Pointer' (handle) to the C++ octree class instance                    1 \n");
            mexErrMsgTxt("Check the arguments!");
            }
        Oc_Tree_Obj->Print_Tree();
        return;
        }

	// output data for plotting octree in MATLAB
    if (!strcmp("tree_data", cmd))
        {
        // Check parameters
        if ((nlhs!=1) || (nrhs!=3))
            {
            mexPrintf("mexOctree: 'tree_data'\n");
            mexPrintf("\n");
            mexPrintf("ERROR: need 2 inputs and 0 outputs!\n");
            mexPrintf("\n");
            mexPrintf("      INPUTS                                                               ORDER \n");
            mexPrintf("      -------------------------------------------------                    ----- \n");
            mexPrintf("      Command String = 'tree_data'                                           0 \n");
            mexPrintf("      'Pointer' (handle) to the C++ octree class instance                    1 \n");
			mexPrintf("      Lowest Level Node To Plot (>= 0)                                       2 \n");
            mexErrMsgTxt("Check the arguments!");
            }
		// get desired level
		const UINT_type desired_level = (UINT_type) *mxGetPr(prhs[2]);
		if (desired_level < 0) mexErrMsgTxt("Desired level must be >= 0!\n");
		// output the data
		plhs[0] = Oc_Tree_Obj->Get_Tree_Data(desired_level);
        return;
        }

    // perform a k-nearest neighbor search
    if (!strcmp("knn_search", cmd))
        {
        // Check parameters
        if ((nlhs<1) || (nlhs>2) || (nrhs<3) || (nrhs>4))
            {
            mexPrintf("mexOctree: 'knn_search'\n");
            mexPrintf("\n");
            mexPrintf("ERROR: need 3 or 4 inputs and 1 or 2 outputs!\n");
            mexPrintf("\n");
            mexPrintf("      INPUTS                                                               ORDER \n");
            mexPrintf("      -------------------------------------------------                    ----- \n");
            mexPrintf("      Command String = 'knn_search'                                          0 \n");
            mexPrintf("      'Pointer' (handle) to the C++ octree class instance                    1 \n");
            mexPrintf("      Points (Rx3 matrix of query point coordinates)                         2 \n");
            mexPrintf("      Number of Nearest Neighbors To Find =: K                               3 \n");
            mexPrintf("\n");
            mexPrintf("      OUTPUTS\n");
            mexPrintf("      ------------------------------------------------- \n");
            mexPrintf("      Indices of Closest Points in Octree (RxK matrix of indices)\n");
            mexPrintf("      Distances to Closest Points         (RxK matrix)\n");
            mexPrintf("\n");
            mexErrMsgTxt("Check the arguments!");
            }
        /* pass the inputs */

        // setup input point data
        MATLAB_Matrix_ReadOnly<pt_type,3> Input_Pts;
        Input_Pts.Setup_Data(prhs[2]);
        const unsigned int Num_Neighbors = (unsigned int) *mxGetPr(prhs[3]);
        if (Num_Neighbors < 1)
            {
            mexErrMsgTxt("Number of neighbors must be > 0!");
            }
        if (Num_Neighbors > 10000)
            {
            mexPrintf("Are you sure you want to find %d neighbors?\n",Num_Neighbors);
            mexErrMsgTxt("Check your inputs!");
            }
        // check that the number of desired neighbors does not exceed
        //       the number of points in the tree!
        const UINT_type NP = Oc_Tree_Obj->Points.Get_Num_Rows();
        if (Num_Neighbors > NP)
            {
            mexPrintf("You specified %d neighbors.\n",Num_Neighbors);
            mexPrintf("But there are only %d points in the tree.\n",NP);
            mexPrintf("The number of neighbors cannot exceed the number of points in the tree!\n");
            mexErrMsgTxt("Set the number of neighbors <= number of points in the tree.");
            }

        // setup output data
        plhs[0] = mxCreateNumericMatrix((mwSize) Input_Pts.Get_Num_Rows(), (mwSize) Num_Neighbors,
                                         mxUINT32_CLASS, mxREAL);
        MATLAB_Matrix_ReadWrite<UINT_type> Output_Indices;
        Output_Indices.Setup_Data(plhs[0]);
        MATLAB_Matrix_ReadWrite<pt_type> Output_Dist; // empty object
        if (nlhs==2)
            {
            plhs[1] = mxCreateDoubleMatrix((mwSize) Input_Pts.Get_Num_Rows(), (mwSize) Num_Neighbors, mxREAL);
            Output_Dist.Setup_Data(plhs[1]); // access the data
            }

        // do the search
        if (nlhs==2) // return the distances also
            Oc_Tree_Obj->kNN_Search(Input_Pts, Output_Indices, Output_Dist, true);
        else // do not return the distances
            Oc_Tree_Obj->kNN_Search(Input_Pts, Output_Indices, Output_Dist, false);

        return;
        }

    // this will replace the current point coordinates (same number of points)
    //      and update the octree structure
    if (!strcmp("update_tree", cmd))
        {
        /* BEGIN: Error Checking */
        if ( (nrhs>3) || (nlhs!=0) )
            {
            mexPrintf("mexOctree: 'update_tree'\n");
            mexPrintf("\n");
            mexPrintf("ERROR: need 3 inputs and 0 outputs!\n");
            mexPrintf("\n");
            mexPrintf("      INPUTS                                                               ORDER \n");
            mexPrintf("      -------------------------------------------------                    ----- \n");
            mexPrintf("      Command String = 'update_tree'                                         0 \n");
            mexPrintf("      'Pointer' (handle) to the C++ octree class instance                    1 \n");
            mexPrintf("      Points (Mx3 matrix of point coordinates)                               2 \n");
            // mexPrintf("      Bucket_Size (default = 20) (max points to store in a octree cell)    3 \n");
            mexPrintf("\n");
            mexErrMsgTxt("Check the arguments!");
            }
        /* END: Error Checking */

        /* pass the inputs */

        // setup input point data
        const UINT_type NP_old = Oc_Tree_Obj->Points.Get_Num_Rows();
        const UINT_type NP_new = (UINT_type) mxGetM(prhs[2]);
        if (NP_new != NP_old)
            {
            mexPrintf("There are %d input points.\n",NP_new);
            mexPrintf("But there are %d points in the tree.\n",NP_old);
            mexPrintf("You can only update a tree with the *same* number of points!\n");
            mexErrMsgTxt("Check your inputs!");
            }
        Oc_Tree_Obj->Points.Setup_Data(prhs[2]);
        // make sure the bounding box is still respected
        Oc_Tree_Obj->Check_Points_Against_Bounding_Box(Oc_Tree_Obj->Points);

        // modify the tree to accomodate the new points
        Oc_Tree_Obj->Update_Tree();
        return;
        }

    // if we got here, then the command was not recognized
    mexPrintf("\n");
    mexPrintf("This command was not recognized:  ");
    mexPrintf(cmd);
    mexPrintf("\n\n");
    mexErrMsgTxt("Call this mex file with no inputs to see a list of acceptable command strings.\n");

	/* TEST CODE: */
    // // output the leaf that contains the given point
    // trCell* N1 = Oc_Tree_Obj->Locate_Cell(0.234, 0.6134, 0.154);
    // mexPrintf("Node N1:\n");
    // Oc_Tree_Obj->Print_Node_Info(N1);
    // trCell* NL = Oc_Tree_Obj->Locate_Left_Neighbor(N1);
	// trCell* NR = Oc_Tree_Obj->Locate_Right_Neighbor(N1);
    // mexPrintf("Node NL:\n");
    // Oc_Tree_Obj->Print_Node_Info(NL);
	// if (NL!=NULL)
		// {
		// mexPrintf("This is the parent of NL!\n\n");
		// Oc_Tree_Obj->Print_Node_Info(NL->parent);
		// }
    // mexPrintf("Node NR:\n");
    // Oc_Tree_Obj->Print_Node_Info(NR);
}

/***/
