/*
============================================================================================
   Header file for a C++ Class that contains methods for accessing and manipulating
   the triangle neighbor data array.
   

   Copyright (c) 07-20-2009,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// struct for storing triangle neighbor data
typedef struct
{
  size_t*  Vtx_Indices;
  double*  Tri_Indices; // this needs to be `double *'.  MATLAB does not like `int *'.
}
SPARSE_TND_STRUCT;

/***************************************************************************************/
// struct for storing local star data
typedef struct
{
  int     Max_Tri;
  int     First_Tri_Index;
  int     Last_Tri_Index;
  int     Num_Tri;
  int*    Col1;
  int*    Col2;
  int*    Col3;
}
LOCAL_STAR_STRUCT;

/***************************************************************************************/
class Tri_Neighbor_Data
{
public:
	Tri_Neighbor_Data (); // constructor
	~Tri_Neighbor_Data (); // DE-structor

	// initalize external data dependent stuff
	void Init (const mxArray *, PARAM_STRUCT);
	// setup local star for a given vertex
	void Get_Star (int, TRI_MESH_DATA_STRUCT);

    // these variables are defined from inputs coming from MATLAB
	SPARSE_TND_STRUCT  TriNeighborSparse; // triangle neighbor data structure
	LOCAL_STAR_STRUCT  Star;              // local star of triangles about a mesh node
};

/***/
