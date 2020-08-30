/*
============================================================================================
   Abstract base class for general mesh geometry access.

   Copyright (c) 02-04-2013,  Shawn W. Walker
============================================================================================
*/

/*** C++ (base) class ***/
class Abstract_MESH_GEOMETRY_Class
{
public:
    Abstract_MESH_GEOMETRY_Class (); // constructor
    virtual ~Abstract_MESH_GEOMETRY_Class (); // DE-structor (it MUST be virtual!)
    virtual void Setup_Mesh_Geometry(const mxArray*, const mxArray*, const mxArray*)=0;
    int  Get_Num_Elem()   { return  Num_Elem; }
	int  Get_GeoDim()     { return  GeoDim; }
	int  Get_Sub_TopDim() { return  Sub_TopDim; }
    virtual void Compute_Local_Transformation()=0;

    // local coordinates (only used for custom interpolation and point search routines)
    double   local_coord[3];

protected:
    char*    Name;              // name of the domain that the mesh represents (e.g. "Omega")
    char*    Type;              // specifies the kind of geometry description (only needed for debugging)
    int      Global_TopDim;     // topological dimension of Global Mesh
    int      Sub_TopDim;        // topological dimension of Subdomain
    int      DoI_TopDim;        // topological dimension of Domain of Integration (DoI)
    int      GeoDim;            // geometric dimension
    int      Num_QP;            // number of quadrature points in evaluating local map
    int      Num_Nodes;         // number of mesh nodes
    int      Num_Elem;          // number of elements
    int      Num_Basis;         // number of basis functions for each element
                                // (i.e. number of DoF for geometry description)
};

/***************************************************************************************/
/* constructor */
Abstract_MESH_GEOMETRY_Class::Abstract_MESH_GEOMETRY_Class ()
{
    Name      = NULL;
    Type      = NULL;
    Global_TopDim = 0;
    Sub_TopDim    = 0;
    DoI_TopDim    = 0;
    GeoDim    = 0;
    Num_QP    = 0;
    Num_Nodes = 0;
    Num_Elem  = 0;
    Num_Basis = 0;

    local_coord[0] = 0.0;
    local_coord[1] = 0.0;
    local_coord[2] = 0.0;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
Abstract_MESH_GEOMETRY_Class::~Abstract_MESH_GEOMETRY_Class ()
{
}
/***************************************************************************************/

/***/
