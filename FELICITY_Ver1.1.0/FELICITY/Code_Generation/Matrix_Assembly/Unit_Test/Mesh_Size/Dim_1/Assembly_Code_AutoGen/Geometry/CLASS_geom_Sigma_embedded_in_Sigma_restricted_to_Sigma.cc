/*
============================================================================================
   This class accesses the mesh geometry data and computes the local transformation from
   the reference element to a `general' element in the mesh.
   
   Several things are computed, such as the gradient of the transformation and Jacobian,
   as well as many other ``custom items''.
   
   This code references the header files:
   
   matrix_vector_defn.h
   matrix_vector_ops.h
   geometric_computations.h
   

   NOTE: portions of this code are automatically generated!

   Copyright (c) 06-06-2012,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set mesh geometry data type name
#define MGC        CLASS_geom_Sigma_embedded_in_Sigma_restricted_to_Sigma
// set the type of map
#define MAP_type  "CG - lagrange_deg1_dim1"

// set the Global mesh topological dimension
#define GLOBAL_TD  1
// set the Subdomain topological dimension
#define SUB_TD  1
// set the Domain of Integration (DoI) topological dimension
#define DOI_TD  1
// set the (ambient) geometric dimension
#define GD  2
// set the number of quad points
#define NQ  1
// set the number of basis functions
#define NB  2
// set whether to access the local simplex (facet) orientation
#define ORIENT  false
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/* C++ (Specific) Mesh class definition */
class MGC: public Abstract_MESH_GEOMETRY_Class // derive from base class
{
public:
    /***************************************************************************************/
    // data structures containing information about the local mapping from a
    // reference simplex to the actual element in the mesh.
    // Note: this data is evaluated at several quadrature points.
    // local mesh size of reference element
    SCALAR Map_Mesh_Size[1];
    // gradient of the transformation (matrix)
    MAT_2x1 Map_PHI_Grad[1];
    // metric tensor of the map
    MAT_1x1 Map_PHI_Metric[1];
    // determinant of the metric matrix
    SCALAR Map_Det_Metric[1];
    // determinant of the transformation (Jacobian)
    SCALAR Map_Det_Jac[1];
    // determinant of Jacobian multiplied by quadrature weight
    SCALAR Map_Det_Jac_w_Weight[NQ];

    MGC (); // constructor
    ~MGC ();   // DE-structor
    void Setup_Mesh_Geometry(const mxArray*, const mxArray*, const mxArray*);
    void Compute_Local_Transformation();
    double Orientation[SUB_TD+1]; // mesh "facet" orientation direction for the current subdomain element
    // pointer to Domain class
    const CLASS_Domain_Sigma_embedded_in_Sigma_restricted_to_Sigma*   Domain;

private:
    double*  Node_Value[GD];    // mesh node values
    int*     Elem_DoF[NB];      // element DoF list
    bool*    Elem_Orient[SUB_TD+1]; // element facet orientation
                                    // true  = face has an outward normal vector (+1)
                                    // false = face has an  inward normal vector (-1)

    void Get_Local_to_Global_DoFmap(const int&, int*);
    void Get_Local_Orientation(const int&);
    void Compute_Map_p1(const int&);
};
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* constructor */
MGC::MGC () : Abstract_MESH_GEOMETRY_Class ()
{
    Type      = (char*) MAP_type;
    Global_TopDim = GLOBAL_TD;
    Sub_TopDim    = SUB_TD;
    DoI_TopDim    = DOI_TD;
    GeoDim    = GD;
    Num_QP    = NQ;
    Num_Basis = NB;

    // init mesh information to NULL
    Num_Nodes = 0;
    Num_Elem  = 0;
    for (int gd_i = 0; (gd_i < GeoDim); gd_i++)
        Node_Value[gd_i] = NULL;
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = NULL;
    for (int o_i = 0; (o_i < (Sub_TopDim+1)); o_i++)
        {
        Orientation[o_i] = +1.0;
        Elem_Orient[o_i] = NULL;
        }

    // init everything to zero
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_Mesh_Size[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_PHI_Grad[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_PHI_Metric[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_Det_Metric[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_Det_Jac[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        Map_Det_Jac_w_Weight[qp_i].Set_To_Zero();
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/***************************************************************************************/
/* DE-structor */
MGC::~MGC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void MGC::Setup_Mesh_Geometry(const mxArray *Vtx,       // inputs
                              const mxArray *Elem,      // inputs
                              const mxArray *Orient)    // inputs
{
    // get the ambient geometric dimension
    int CHK_GeoDim = (int) mxGetN(Vtx);
    // get the number of vertices
    Num_Nodes = (int) mxGetM(Vtx);
    // get the number of elements
    Num_Elem  = (int) mxGetM(Elem);
    // get the number of basis functions for each element
    int CHK_Num_Basis = (int) mxGetN(Elem);
    // get the number of rows, columns in the orientation data
    int CHK_Num_Row_Orient = (int) mxGetM(Orient);
    int CHK_Num_Col_Orient = (int) mxGetN(Orient);

    /* BEGIN: Simple Error Checking */
    if (mxGetClassID(Elem)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Geometry DoFmap must be uint32!");
    if (CHK_GeoDim != GeoDim)
        {
        mexPrintf("ERROR: Vertex Coordinate List has %d columns; expected %d columns.\n", CHK_GeoDim, GeoDim);
        mexErrMsgTxt("ERROR: ambient geometric dimension must match!");
        }
    if (CHK_Num_Basis!=Num_Basis)
        {
        mexPrintf("ERROR: Mesh DoFmap has %d columns; expected %d columns.\n", CHK_Num_Basis, Num_Basis);
        mexPrintf("ERROR: A common reason for this error is you are using a finite element space\n");
        mexPrintf("ERROR:     to represent the mesh that is higher order than piecewise linear\n");
        mexPrintf("ERROR:     and you forgot to create a distinct DoFmap for that space.\n");
        mexPrintf("ERROR: You *cannot* just use the plain triangulation data!\n");
        mexPrintf("ERROR:     That only works for linear elements.\n");
        mexErrMsgTxt("ERROR: number of basis functions describing geometry must match!");
        }
    if (ORIENT) // if we should access orientation data, then make some checks
        {
        if (mxGetClassID(Orient)!=mxLOGICAL_CLASS) mexErrMsgTxt("ERROR: Mesh Orientation must be logical!");
        if (CHK_Num_Row_Orient!=Num_Elem)
            {
            mexPrintf("ERROR: Mesh Orientation has %d rows; expected %d rows.\n", CHK_Num_Row_Orient, Num_Elem);
            mexErrMsgTxt("ERROR: Orientation rows should match the Mesh DoFmap rows!");
            }
        if (CHK_Num_Col_Orient!=(Sub_TopDim+1))
            {
            mexPrintf("ERROR: Mesh Orientation has %d columns; expected %d columns.\n", CHK_Num_Col_Orient, (Sub_TopDim+1));
            mexErrMsgTxt("ERROR: Orientation cols should match the Mesh topological dimension + 1!");
            }
        }
    /* END: Simple Error Checking */


    // split up the columns of the node data
    Node_Value[0] = mxGetPr(Vtx);
    for (int gd_i = 1; (gd_i < GeoDim); gd_i++)
        Node_Value[gd_i] = Node_Value[gd_i-1] + Num_Nodes;

    // split up the columns of the element data
    Elem_DoF[0] = (int *) mxGetPr(Elem);
    for (int basis_i = 1; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = Elem_DoF[basis_i-1] + Num_Elem;

    // split up the columns of the element (facet) orientation data
    if (ORIENT)
        {
        Elem_Orient[0] = (bool *) mxGetPr(Orient);
        for (int o_i = 1; (o_i < (Sub_TopDim+1)); o_i++)
            Elem_Orient[o_i] = Elem_Orient[o_i-1] + Num_Elem;
        }

    // get maximum DoF present in Elem
    int Elem_Num_Nodes  = *std::max_element(Elem_DoF[0],Elem_DoF[0] + (Num_Elem*Num_Basis));
    int Min_DoF         = *std::min_element(Elem_DoF[0],Elem_DoF[0] + (Num_Elem*Num_Basis));
    if ((Min_DoF < 1) || (Elem_Num_Nodes < 1))
        {
        mexPrintf("ERROR: There are Mesh DoFs that have indices < 1!\n");
        mexPrintf("ERROR: There are problems with this Mesh Type = %s!\n",Type);
        mexErrMsgTxt("ERROR: Fix your Mesh DoFmap!");
        }
    if (Elem_Num_Nodes > Num_Nodes)
        {
        mexPrintf("ERROR: There are Mesh DoFs that have indices > number of Mesh Values!\n");
        mexPrintf("ERROR: There are problems with this Mesh Type = %s!\n",Type);
        mexErrMsgTxt("ERROR: Fix your Mesh Values or DoFmap!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get the local DoFs on the given element */
void MGC::Get_Local_to_Global_DoFmap(const int& elem_index, int* Indices)  // inputs
{
    // get local to global indexing for geometry DoFmap
    for (int basis_i = 0; (basis_i < NB); basis_i++)
        {
        int DoF_index = Elem_DoF[basis_i][elem_index] - 1; // shifted for C - style indexing
        Indices[basis_i] = DoF_index;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get the local orientation of the given element */
void MGC::Get_Local_Orientation(const int& elem_index)  // inputs
{
    // translate logical info to +/- 1.0
    for (int o_i = 0; (o_i < (SUB_TD+1)); o_i++)
        {
        const bool Orient_TF = Elem_Orient[o_i][elem_index];
        if (Orient_TF) Orientation[o_i] = +1.0;
        else           Orientation[o_i] = -1.0;
        }
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation based on the given mesh entity */
void MGC::Compute_Local_Transformation()
{
    // read in the embedding info
    const int Global_Cell_Index = Domain->Global_Cell_Index;

    // compute "facet" orientation directions of current simplex
    if (ORIENT)  Get_Local_Orientation(Global_Cell_Index);

    /* compute local map */

    Compute_Map_p1(Global_Cell_Index);
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_p1(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Intrinsic Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim1
// the Global mesh           has topological dimension = 1
// the Subdomain             has topological dimension = 1
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 1

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {5.00000000000000000E-01, 5.00000000000000000E-01}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     5.00000000000000000E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    1.00000000000000000E+00  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
// basis function evaluations at the local element vertices
    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Vtx_Basis_Val_0_0_0[2][NB] = { \
    {1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     0.00000000000000000E+00, \
//     1.00000000000000000E+00  \
//     };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    VEC_2x1  Pt1;
    VEC_2x1  Pt2;
    // compute vertex positions by summing over basis functions
    Pt1.v[0] = Geo_Vtx_Basis_Val_0_0_0[0][0]*Node_Value[0][kc[0]]+Geo_Vtx_Basis_Val_0_0_0[0][1]*Node_Value[0][kc[1]];
    Pt2.v[0] = Geo_Vtx_Basis_Val_0_0_0[1][0]*Node_Value[0][kc[0]]+Geo_Vtx_Basis_Val_0_0_0[1][1]*Node_Value[0][kc[1]];
    Pt1.v[1] = Geo_Vtx_Basis_Val_0_0_0[0][0]*Node_Value[1][kc[0]]+Geo_Vtx_Basis_Val_0_0_0[0][1]*Node_Value[1][kc[1]];
    Pt2.v[1] = Geo_Vtx_Basis_Val_0_0_0[1][0]*Node_Value[1][kc[0]]+Geo_Vtx_Basis_Val_0_0_0[1][1]*Node_Value[1][kc[1]];
    // compute the local mesh size
    VEC_2x1  TEMP_Vec;
    Subtract_Vector(Pt2, Pt1, TEMP_Vec);
    Map_Mesh_Size[0].a = l2_norm(TEMP_Vec);
    
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x1& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]];
        }
    // compute metric tensor from jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_1x1& Map_PHI_Metric_qp_i = Map_PHI_Metric[qp_i];
        Mat_Transpose_Mat_Self(Map_PHI_Grad[qp_i], Map_PHI_Metric_qp_i);
        }
    // compute determinant of Metric: det(PHI_Metric)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Metric_qp_i = Map_Det_Metric[qp_i];
        Map_Det_Metric_qp_i.a = Determinant(Map_PHI_Metric[qp_i]);
        }
    // compute determinant of Jacobian
    // note: det(Jac) = sqrt(det(PHI_Metric))
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = sqrt(Map_Det_Metric[qp_i].a);
        }
    // multiply det(jacobian) by quadrature weight
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_w_Weight_qp_i = Map_Det_Jac_w_Weight[qp_i];
        Map_Det_Jac_w_Weight_qp_i.a = Map_Det_Jac[0].a * Quad_Weights[qp_i];
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

#undef MGC

#undef MAP_type
#undef GLOBAL_TD
#undef SUB_TD
#undef DOI_TD
#undef GD
#undef NQ
#undef NB
#undef ORIENT

/***/
