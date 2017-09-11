/*
============================================================================================
   This routine organizes some incoming data lists.


   OUTPUTS
   -------
   node_struct:
       A struct containing the boundary/fixed (and adjacent) node data.
       node_struct.Fixed
                  .Adj

   INPUTS
   ------
   Fixed_Nodes:
       List of nodes where the dirichlet data is defined.

   Adj_Nodes:
       List of nodes that are adjacent to the fixed nodes.

   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// data structure
typedef struct
{
  size_t      NumFixed;          // number of fixed nodes
  size_t      NumAdj;            // number of adjacent nodes
  int     *Fixed;             // fixed node array
  int     *Adj;               // adjacent node array
}
FIXED_NODE_STRUCT;

/*** put incoming node data from MATLAB into a nice struct ***/
FIXED_NODE_STRUCT  Setup_Node_Data(
                        TRI_MESH_DATA_STRUCT  Mesh,      // inputs
                        const mxArray *Input_Fixed,      // inputs
                        const mxArray *Input_Adj)        // inputs
{
	// define output data
	FIXED_NODE_STRUCT  node_struct;

	// get the number of fixed nodes
	node_struct.NumFixed = mxGetM(Input_Fixed);
	// get the number of adjacent nodes
	node_struct.NumAdj = mxGetM(Input_Adj);

	/* BEGIN: Error Checking */
	if (mxGetClassID(Input_Fixed)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Fixed Node list must be uint32!");
	if (mxGetClassID(Input_Adj)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Adjacent Node list must be uint32!");
	if (mxGetN(Input_Fixed)!=1) mexErrMsgTxt("ERROR: Fixed Node list must be a column vector!");
	if (mxGetN(Input_Adj)!=1) mexErrMsgTxt("ERROR: Adjacent Node list must be a column vector!");
	if (node_struct.NumFixed>Mesh.NumVtx) mexErrMsgTxt("ERROR: There are more Fixed Nodes than there are vertices in the mesh!");
	if (node_struct.NumAdj>Mesh.NumVtx) mexErrMsgTxt("ERROR: There are more Adjacent Nodes than there are vertices in the mesh!");
	/* END: Error Checking */

	// get pointers to the node lists
	node_struct.Fixed       = (int *) mxGetPr(Input_Fixed);
	node_struct.Adj         = (int *) mxGetPr(Input_Adj);
	
	// output the mesh data
	return node_struct;
}
/***/
