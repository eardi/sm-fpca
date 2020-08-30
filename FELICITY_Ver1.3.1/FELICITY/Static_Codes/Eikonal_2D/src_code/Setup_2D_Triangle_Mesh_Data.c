/*
============================================================================================
   This routine takes the triangle mesh data coming from an outside MATLAB code, and
   puts it into a convenient structure variable.


   OUTPUTS
   -------
   mesh_struct:
       A struct containing the mesh data.
       mesh_struct.NumVtx
                  .NumTri
                  .NumIndices
                  .GeoDim
                  .Vertex_Coord[2][ind]
                  .Tri_Elem[3][ind]

   INPUTS
   ------
   Input_Vtx:
       The (x,y) coordinates of the mesh vertices.
       This is a Vx2 array in MATLAB.

   Input_Tri:
       The triangle element data for the mesh.  In MATLAB, this is a (Num_Tri_Elements x 3)
       array.  The nodal indices lie between 1 and V (number of vertex nodes).

   Copyright (c) 05-01-2008,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// data structure containing vertex data struct
typedef struct
{
  double  *x;             // x-coordinate
  double  *y;             // y-coordinate
  double  *z;             // z-coordinate
}
VERTEX_COORD_STRUCT;

/***************************************************************************************/
// data structure containing triangle mesh data
typedef struct
{
  size_t NumVtx;            // number of mesh vertices
  size_t NumTri;            // number of triangles
  size_t NumIndices;        // number of indices for each triangle element
  size_t GeoDim;            // the dimension of the ambient space
  VERTEX_COORD_STRUCT  Vtx;   // 2-D P1 vertex coordinates (X,Y)
  int *Tri_Elem[3];       // triangle element (nodal) index list
}
TRI_MESH_DATA_STRUCT;


/*** put incoming triangle mesh data from MATLAB into a nice struct ***/
TRI_MESH_DATA_STRUCT  Setup_2D_Input_Triangle_Mesh_Data(
                        const mxArray *Input_Vtx,   // inputs
                        const mxArray *Input_Tri)   // inputs
{
	// define output data
	TRI_MESH_DATA_STRUCT mesh_struct;

	// get the number of vertices
	mesh_struct.NumVtx = mxGetM(Input_Vtx);
	// get the number of triangles
	mesh_struct.NumTri = mxGetM(Input_Tri);
	// set the number of indices for each element triangle
	mesh_struct.NumIndices = 3;
	// get the geometric dimension
	mesh_struct.GeoDim = mxGetN(Input_Vtx);

	/* BEGIN: Error Checking */
	if (mxGetClassID(Input_Tri)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Triangle Elements must be uint32!");
	if ((mesh_struct.GeoDim<2) || (mesh_struct.GeoDim>3)) mexErrMsgTxt("ERROR: Must be 2 or 3 columns in the vertex coordinate list!");
	if (mxGetN(Input_Tri)!=3) mexErrMsgTxt("ERROR: Triangle list must have 3 columns!");
	/* END: Error Checking */


	// split up the (X,Y) coordinates into separate arrays
	mesh_struct.Vtx.x = mxGetPr(Input_Vtx);                           // X coordinates
	mesh_struct.Vtx.y = mesh_struct.Vtx.x + mesh_struct.NumVtx;       // Y coordinates
	if (mesh_struct.GeoDim==3)
	    mesh_struct.Vtx.z = mesh_struct.Vtx.y + mesh_struct.NumVtx;   // Z coordinates
	else
	    mesh_struct.Vtx.z = NULL;

	// split up the columns of the triangle element data into 3 arrays
	mesh_struct.Tri_Elem[0] = (int *) mxGetPr(Input_Tri);                   // 1st column
	mesh_struct.Tri_Elem[1] = mesh_struct.Tri_Elem[0] + mesh_struct.NumTri; // 2nd column
	mesh_struct.Tri_Elem[2] = mesh_struct.Tri_Elem[1] + mesh_struct.NumTri; // 3rd column

	// output the mesh data
	return mesh_struct;
}
/***/
