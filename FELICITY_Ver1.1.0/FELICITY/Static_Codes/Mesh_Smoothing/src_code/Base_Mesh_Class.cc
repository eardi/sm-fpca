/*
============================================================================================
   Base class for general mesh geometry access.

   Copyright (c) 04-23-2013,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* this struct is for storing the vertex indices of an element */
typedef struct {
    int vtx_indices[4];
} FOUR_INDICES;
/***************************************************************************************/

/***************************************************************************************/
/* this struct is for storing info about the elements attached to a vertex */
typedef struct {
    int center_vtx_index;
    std::vector<FOUR_INDICES>  elem;
} STAR;
/***************************************************************************************/

/*** C++ (base) class ***/
class Base_Mesh_Class
{
public:
    Base_Mesh_Class (); // constructor
    virtual ~Base_Mesh_Class (); // DE-structor (it MUST be virtual!)
    virtual void Setup_Mesh(const mxArray*, const mxArray*)=0;
	int  Get_Num_Nodes() { return  Num_Nodes; }
    int  Get_Num_Elem()  { return  Num_Elem; }
	int  Get_GeoDim()    { return  GeoDim; }
    virtual void Read_Star(const int&, STAR&)=0;

protected:
    int      TopDim;            // topological dimension of Mesh
    int      GeoDim;            // geometric dimension
    int      Num_Nodes;         // number of mesh nodes
    int      Num_Elem;          // number of elements
    int      Num_Basis;         // number of basis functions for each element
                                // (i.e. number of DoF for geometry description)
};

/***************************************************************************************/
/* constructor */
Base_Mesh_Class::Base_Mesh_Class ()
{
    TopDim        = 0;
    GeoDim        = 0;
    Num_Nodes     = 0;
    Num_Elem      = 0;
    Num_Basis     = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
Base_Mesh_Class::~Base_Mesh_Class ()
{
}
/***************************************************************************************/

/***/
