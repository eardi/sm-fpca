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
#define MGC        CLASS_geom_Omega_embedded_in_Omega_restricted_to_Gamma
// set the type of map
#define MAP_type  "CG - lagrange_deg1_dim2"

// set the Global mesh topological dimension
#define GLOBAL_TD  2
// set the Subdomain topological dimension
#define SUB_TD  2
// set the Domain of Integration (DoI) topological dimension
#define DOI_TD  1
// set the (ambient) geometric dimension
#define GD  2
// set the number of quad points
#define NQ  8
// set the number of basis functions
#define NB  3
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
    // gradient of the transformation (matrix)
    MAT_2x2 Map_PHI_Grad[1];
    // determinant of the transformation (Jacobian)
    SCALAR Map_Det_Jac[1];
    // inverse of determinant of Jacobian
    SCALAR Map_Inv_Det_Jac[1];
    // inverse of the gradient of the map
    MAT_2x2 Map_PHI_Inv_Grad[1];

    MGC (); // constructor
    ~MGC ();   // DE-structor
    void Setup_Mesh_Geometry(const mxArray*, const mxArray*, const mxArray*);
    void Compute_Local_Transformation();
    double Orientation[SUB_TD+1]; // mesh "facet" orientation direction for the current subdomain element
    // pointer to Domain class
    const CLASS_Domain_Omega_embedded_in_Omega_restricted_to_Gamma*   Domain;

private:
    double*  Node_Value[GD];    // mesh node values
    int*     Elem_DoF[NB];      // element DoF list
    bool*    Elem_Orient[SUB_TD+1]; // element facet orientation
                                    // true  = face has an outward normal vector (+1)
                                    // false = face has an  inward normal vector (-1)

    void Get_Local_to_Global_DoFmap(const int&, int*);
    void Get_Local_Orientation(const int&);
    void Compute_Map_p1(const int&);
    void Compute_Map_n1(const int&);
    void Compute_Map_p2(const int&);
    void Compute_Map_n2(const int&);
    void Compute_Map_p3(const int&);
    void Compute_Map_n3(const int&);
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
        Map_PHI_Grad[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_Det_Jac[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_Inv_Det_Jac[qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        Map_PHI_Inv_Grad[qp_i].Set_To_Zero();
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
    const int DoI_Entity_Index  = Domain->DoI_Entity_Index;

    // compute "facet" orientation directions of current simplex
    if (ORIENT)  Get_Local_Orientation(Global_Cell_Index);

    /* compute local map */

    // if orientation is positive
    if (DoI_Entity_Index > 0)
        {
        // pick the correct one
        if (DoI_Entity_Index==1) Compute_Map_p1(Global_Cell_Index);
        else if (DoI_Entity_Index==2) Compute_Map_p2(Global_Cell_Index);
        else if (DoI_Entity_Index==3) Compute_Map_p3(Global_Cell_Index);
        else mexErrMsgTxt("ERROR: DoI_Entity_Index outside valid range or is zero!");
        }
    else // else it is negative
        {
        // pick the correct one
        if (DoI_Entity_Index==-1) Compute_Map_n1(Global_Cell_Index);
        else if (DoI_Entity_Index==-2) Compute_Map_n2(Global_Cell_Index);
        else if (DoI_Entity_Index==-3) Compute_Map_n3(Global_Cell_Index);
        else mexErrMsgTxt("ERROR: DoI_Entity_Index outside valid range or is zero!");
        }
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
// Restriction Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 8

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {0.00000000000000000E+00, 9.80144928248768088E-01, 1.98550717512319119E-02}, \
    {0.00000000000000000E+00, 8.98333238706813364E-01, 1.01666761293186636E-01}, \
    {0.00000000000000000E+00, 7.62766204958164384E-01, 2.37233795041835616E-01}, \
    {0.00000000000000000E+00, 5.91717321247824946E-01, 4.08282678752175054E-01}, \
    {0.00000000000000000E+00, 4.08282678752174943E-01, 5.91717321247825057E-01}, \
    {0.00000000000000000E+00, 2.37233795041835616E-01, 7.62766204958164384E-01}, \
    {0.00000000000000000E+00, 1.01666761293186525E-01, 8.98333238706813475E-01}, \
    {0.00000000000000000E+00, 1.98550717512320229E-02, 9.80144928248767977E-01}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     1.98550717512319119E-02, \
//     1.01666761293186636E-01, \
//     2.37233795041835616E-01, \
//     4.08282678752175054E-01, \
//     5.91717321247825057E-01, \
//     7.62766204958164384E-01, \
//     8.98333238706813475E-01, \
//     9.80144928248767977E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    5.06142681451882195E-02, \
    1.11190517226687283E-01, \
    1.56853322938943662E-01, \
    1.81341891689181078E-01, \
    1.81341891689181162E-01, \
    1.56853322938943607E-01, \
    1.11190517226687283E-01, \
    5.06142681451882542E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]];
        }
    // compute determinant of Jacobian
    // note: det(Jac) = det(PHI_Grad)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = Determinant(Map_PHI_Grad[qp_i]);
        }
    // compute 1 / det(Jacobian)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // inverse of Jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Grad_qp_i = Map_PHI_Inv_Grad[qp_i];
        Matrix_Inverse(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_PHI_Inv_Grad_qp_i);
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_n1(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Restriction Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 8

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {0.00000000000000000E+00, 1.98550717512319119E-02, 9.80144928248768088E-01}, \
    {0.00000000000000000E+00, 1.01666761293186636E-01, 8.98333238706813364E-01}, \
    {0.00000000000000000E+00, 2.37233795041835616E-01, 7.62766204958164384E-01}, \
    {0.00000000000000000E+00, 4.08282678752175054E-01, 5.91717321247824946E-01}, \
    {0.00000000000000000E+00, 5.91717321247825057E-01, 4.08282678752174943E-01}, \
    {0.00000000000000000E+00, 7.62766204958164384E-01, 2.37233795041835616E-01}, \
    {0.00000000000000000E+00, 8.98333238706813475E-01, 1.01666761293186525E-01}, \
    {0.00000000000000000E+00, 9.80144928248767977E-01, 1.98550717512320229E-02}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     1.98550717512319119E-02, \
//     1.01666761293186636E-01, \
//     2.37233795041835616E-01, \
//     4.08282678752175054E-01, \
//     5.91717321247825057E-01, \
//     7.62766204958164384E-01, \
//     8.98333238706813475E-01, \
//     9.80144928248767977E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    5.06142681451882195E-02, \
    1.11190517226687283E-01, \
    1.56853322938943662E-01, \
    1.81341891689181078E-01, \
    1.81341891689181162E-01, \
    1.56853322938943607E-01, \
    1.11190517226687283E-01, \
    5.06142681451882542E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]];
        }
    // compute determinant of Jacobian
    // note: det(Jac) = det(PHI_Grad)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = Determinant(Map_PHI_Grad[qp_i]);
        }
    // compute 1 / det(Jacobian)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // inverse of Jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Grad_qp_i = Map_PHI_Inv_Grad[qp_i];
        Matrix_Inverse(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_PHI_Inv_Grad_qp_i);
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_p2(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Restriction Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 8

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {1.98550717512319119E-02, 0.00000000000000000E+00, 9.80144928248768088E-01}, \
    {1.01666761293186636E-01, 0.00000000000000000E+00, 8.98333238706813364E-01}, \
    {2.37233795041835616E-01, 0.00000000000000000E+00, 7.62766204958164384E-01}, \
    {4.08282678752175054E-01, 0.00000000000000000E+00, 5.91717321247824946E-01}, \
    {5.91717321247825057E-01, 0.00000000000000000E+00, 4.08282678752174943E-01}, \
    {7.62766204958164384E-01, 0.00000000000000000E+00, 2.37233795041835616E-01}, \
    {8.98333238706813475E-01, 0.00000000000000000E+00, 1.01666761293186525E-01}, \
    {9.80144928248767977E-01, 0.00000000000000000E+00, 1.98550717512320229E-02}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     1.98550717512319119E-02, \
//     1.01666761293186636E-01, \
//     2.37233795041835616E-01, \
//     4.08282678752175054E-01, \
//     5.91717321247825057E-01, \
//     7.62766204958164384E-01, \
//     8.98333238706813475E-01, \
//     9.80144928248767977E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    5.06142681451882195E-02, \
    1.11190517226687283E-01, \
    1.56853322938943662E-01, \
    1.81341891689181078E-01, \
    1.81341891689181162E-01, \
    1.56853322938943607E-01, \
    1.11190517226687283E-01, \
    5.06142681451882542E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]];
        }
    // compute determinant of Jacobian
    // note: det(Jac) = det(PHI_Grad)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = Determinant(Map_PHI_Grad[qp_i]);
        }
    // compute 1 / det(Jacobian)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // inverse of Jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Grad_qp_i = Map_PHI_Inv_Grad[qp_i];
        Matrix_Inverse(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_PHI_Inv_Grad_qp_i);
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_n2(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Restriction Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 8

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {9.80144928248768088E-01, 0.00000000000000000E+00, 1.98550717512319119E-02}, \
    {8.98333238706813364E-01, 0.00000000000000000E+00, 1.01666761293186636E-01}, \
    {7.62766204958164384E-01, 0.00000000000000000E+00, 2.37233795041835616E-01}, \
    {5.91717321247824946E-01, 0.00000000000000000E+00, 4.08282678752175054E-01}, \
    {4.08282678752174943E-01, 0.00000000000000000E+00, 5.91717321247825057E-01}, \
    {2.37233795041835616E-01, 0.00000000000000000E+00, 7.62766204958164384E-01}, \
    {1.01666761293186525E-01, 0.00000000000000000E+00, 8.98333238706813475E-01}, \
    {1.98550717512320229E-02, 0.00000000000000000E+00, 9.80144928248767977E-01}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     1.98550717512319119E-02, \
//     1.01666761293186636E-01, \
//     2.37233795041835616E-01, \
//     4.08282678752175054E-01, \
//     5.91717321247825057E-01, \
//     7.62766204958164384E-01, \
//     8.98333238706813475E-01, \
//     9.80144928248767977E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    5.06142681451882195E-02, \
    1.11190517226687283E-01, \
    1.56853322938943662E-01, \
    1.81341891689181078E-01, \
    1.81341891689181162E-01, \
    1.56853322938943607E-01, \
    1.11190517226687283E-01, \
    5.06142681451882542E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]];
        }
    // compute determinant of Jacobian
    // note: det(Jac) = det(PHI_Grad)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = Determinant(Map_PHI_Grad[qp_i]);
        }
    // compute 1 / det(Jacobian)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // inverse of Jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Grad_qp_i = Map_PHI_Inv_Grad[qp_i];
        Matrix_Inverse(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_PHI_Inv_Grad_qp_i);
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_p3(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Restriction Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 8

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {9.80144928248768088E-01, 1.98550717512319119E-02, 0.00000000000000000E+00}, \
    {8.98333238706813364E-01, 1.01666761293186636E-01, 0.00000000000000000E+00}, \
    {7.62766204958164384E-01, 2.37233795041835616E-01, 0.00000000000000000E+00}, \
    {5.91717321247824946E-01, 4.08282678752175054E-01, 0.00000000000000000E+00}, \
    {4.08282678752174943E-01, 5.91717321247825057E-01, 0.00000000000000000E+00}, \
    {2.37233795041835616E-01, 7.62766204958164384E-01, 0.00000000000000000E+00}, \
    {1.01666761293186525E-01, 8.98333238706813475E-01, 0.00000000000000000E+00}, \
    {1.98550717512320229E-02, 9.80144928248767977E-01, 0.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     1.98550717512319119E-02, \
//     1.01666761293186636E-01, \
//     2.37233795041835616E-01, \
//     4.08282678752175054E-01, \
//     5.91717321247825057E-01, \
//     7.62766204958164384E-01, \
//     8.98333238706813475E-01, \
//     9.80144928248767977E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    5.06142681451882195E-02, \
    1.11190517226687283E-01, \
    1.56853322938943662E-01, \
    1.81341891689181078E-01, \
    1.81341891689181162E-01, \
    1.56853322938943607E-01, \
    1.11190517226687283E-01, \
    5.06142681451882542E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]];
        }
    // compute determinant of Jacobian
    // note: det(Jac) = det(PHI_Grad)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = Determinant(Map_PHI_Grad[qp_i]);
        }
    // compute 1 / det(Jacobian)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // inverse of Jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Grad_qp_i = Map_PHI_Inv_Grad[qp_i];
        Matrix_Inverse(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_PHI_Inv_Grad_qp_i);
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Mesh    */
void MGC::Compute_Map_n3(const int& elem_index)           // current mesh element index
{
int kc[NB];      // for indexing through the mesh DoFmap

Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
// Restriction Map
// Local Map Element on Global mesh: CG, lagrange_deg1_dim2
// the Global mesh           has topological dimension = 2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 1
// Map has geometric dimension = 2
// Number of Quadrature Points = 8

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double Geo_Basis_Val_0_0_0[NQ][NB] = { \
    {1.98550717512319119E-02, 9.80144928248768088E-01, 0.00000000000000000E+00}, \
    {1.01666761293186636E-01, 8.98333238706813364E-01, 0.00000000000000000E+00}, \
    {2.37233795041835616E-01, 7.62766204958164384E-01, 0.00000000000000000E+00}, \
    {4.08282678752175054E-01, 5.91717321247824946E-01, 0.00000000000000000E+00}, \
    {5.91717321247825057E-01, 4.08282678752174943E-01, 0.00000000000000000E+00}, \
    {7.62766204958164384E-01, 2.37233795041835616E-01, 0.00000000000000000E+00}, \
    {8.98333238706813475E-01, 1.01666761293186525E-01, 0.00000000000000000E+00}, \
    {9.80144928248767977E-01, 1.98550717512320229E-02, 0.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double Geo_Basis_Val_0_1_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double Geo_Basis_Val_1_0_0[NQ][NB] = { \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][GLOBAL_TD] = { \
//     1.98550717512319119E-02, \
//     1.01666761293186636E-01, \
//     2.37233795041835616E-01, \
//     4.08282678752175054E-01, \
//     5.91717321247825057E-01, \
//     7.62766204958164384E-01, \
//     8.98333238706813475E-01, \
//     9.80144928248767977E-01  \
//     };
// set of quadrature weights
static const double Quad_Weights[NQ] = { \
    5.06142681451882195E-02, \
    1.11190517226687283E-01, \
    1.56853322938943662E-01, \
    1.81341891689181078E-01, \
    1.81341891689181162E-01, \
    1.56853322938943607E-01, \
    1.11190517226687283E-01, \
    5.06142681451882542E-02  \
    };
/*------------   END: Auto Generate ------------*/
/*------------ BEGIN: Auto Generate ------------*/
    /*** compute geometric quantities ***/
    // compute the gradient of the local map
    // note: indexing is in the C style
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        // sum over basis functions
        MAT_2x2& Map_PHI_Grad_qp_i = Map_PHI_Grad[qp_i];
        Map_PHI_Grad_qp_i.m[0][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[0][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[0][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[0][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[0][kc[2]];
        Map_PHI_Grad_qp_i.m[1][0] = Geo_Basis_Val_1_0_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_1_0_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_1_0_0[qp_i][2]*Node_Value[1][kc[2]];
        Map_PHI_Grad_qp_i.m[1][1] = Geo_Basis_Val_0_1_0[qp_i][0]*Node_Value[1][kc[0]]+Geo_Basis_Val_0_1_0[qp_i][1]*Node_Value[1][kc[1]]+Geo_Basis_Val_0_1_0[qp_i][2]*Node_Value[1][kc[2]];
        }
    // compute determinant of Jacobian
    // note: det(Jac) = det(PHI_Grad)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Det_Jac_qp_i = Map_Det_Jac[qp_i];
        Map_Det_Jac_qp_i.a = Determinant(Map_PHI_Grad[qp_i]);
        }
    // compute 1 / det(Jacobian)
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        SCALAR& Map_Inv_Det_Jac_qp_i = Map_Inv_Det_Jac[qp_i];
        Map_Inv_Det_Jac_qp_i.a = 1.0 / Map_Det_Jac[qp_i].a;
        }
    // inverse of Jacobian matrix
    // evaluate at one point
    for (int qp_i = 0; (qp_i < 1); qp_i++)
        {
        //
        MAT_2x2& Map_PHI_Inv_Grad_qp_i = Map_PHI_Inv_Grad[qp_i];
        Matrix_Inverse(Map_PHI_Grad[qp_i], Map_Inv_Det_Jac[qp_i], Map_PHI_Inv_Grad_qp_i);
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
