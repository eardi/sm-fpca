/*
============================================================================================
   This class contains data about a given FEM function space, and methods for computing
   transformations of the local basis functions.

   This code references the header files:

   matrix_vector_defn.h
   matrix_vector_ops.h
   geometric_computations.h
   basis_function_computations.h


   NOTE: portions of this code are automatically generated!

   Copyright (c) 06-07-2012,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// define the name of the FEM basis function (should be the same as the filename of this file)
#define SpecificFUNC        Data_Type_RT0_phi_restricted_to_Omega
#define SpecificFUNC_str   "Data_Type_RT0_phi_restricted_to_Omega"

// set the type of function space
#define SPACE_type  "CG - raviart_thomas_deg0_dim2"
// set the name of function space
#define SPACE_name  "RT0"

// set the Subdomain topological dimension
#define SUB_TD  2
// set the Domain of Integration (DoI) topological dimension
#define DOI_TD  2
// set the geometric dimension
#define GD  2
// set the number of vector components
#define NC  1
// set the number of quad points
#define NQ  6
// set the number of basis functions
#define NB  3
/*------------   END: Auto Generate ------------*/

/* C++ (Specific) FEM Function class definition */
class SpecificFUNC: public ABSTRACT_FEM_Function_Class // derive from base class
{
public:
    int*     Elem_DoF[NB];    // element DoF list

    // data structure containing information on the function evaluations.
    // Note: this data is evaluated at several quadrature points!
    // orientation of each vector basis function
    SCALAR Func_vv_Orient[NB][1];
    // vector valued H(div) basis functions
    VEC_2x1 Func_vv_Value[NB][NQ];
    // divergence of vector valued H(div) basis functions
    SCALAR Func_vv_Div[NB][NQ];

    // constructor
    SpecificFUNC ();
    ~SpecificFUNC (); // destructor
    void Setup_Function_Space(const mxArray*);
    void Get_Local_to_Global_DoFmap(const int&, int*) const;
                   // need the "const" to ENSURE that nothing in this object will change!
    void Transform_Basis_Functions();
    const CLASS_geom_Omega_embedded_in_Omega_restricted_to_Omega*  Mesh;

private:
    void Map_Basis_p1();
};

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* constructor */
SpecificFUNC::SpecificFUNC () :
ABSTRACT_FEM_Function_Class () // call the base class constructor
{
    Name       = (char*) SpecificFUNC_str;
    Type       = (char*) SPACE_type;
    Space_Name = (char*) SPACE_name;
    Sub_TopDim = SUB_TD;
    DoI_TopDim = DOI_TD;
    GeoDim     = GD;
    Num_Basis  = NB;
    Num_Comp   = NC;
    Num_QP     = NQ;
    Mesh       = NULL;

    // init DoF information to NULL
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = NULL;

    // init everything to zero
    for (int qp_i = 0; (qp_i < 1); qp_i++)
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Func_vv_Orient[basis_i][qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Func_vv_Value[basis_i][qp_i].Set_To_Zero();
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Func_vv_Div[basis_i][qp_i].Set_To_Zero();
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/***************************************************************************************/
/* DE-structor */
SpecificFUNC::~SpecificFUNC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming function data from MATLAB into a nice struct  */
void SpecificFUNC::Setup_Function_Space(const mxArray* Elem)          // inputs
{
    Init_Function_Space(Elem);

    // split up the columns of the element data
    Elem_DoF[0] = (int *) mxGetPr(Elem);
    for (int basis_i = 1; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = Elem_DoF[basis_i-1] + Num_Elem;
}
/***************************************************************************************/


/***************************************************************************************/
/* get the local DoFs on the given element */
void SpecificFUNC::Get_Local_to_Global_DoFmap(const int& elem_index, int* Indices) const  // inputs
{
    // get local to global index map for the current element
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        {
        int DoF_index = Elem_DoF[basis_i][elem_index] - 1; // shifted for C - style indexing
        Indices[basis_i] = DoF_index;
        }
}
/***************************************************************************************/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the correct local transformation */
void SpecificFUNC::Transform_Basis_Functions()
{
    Map_Basis_p1();
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* map derivative calculations of the basis functions from the standard reference element
           to an element in the Domain     */
void SpecificFUNC::Map_Basis_p1()
{

/*------------ BEGIN: Auto Generate ------------*/
// Local Element defined on Subdomain: CG, raviart_thomas_deg0_dim2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 2
// geometric dimension = 2
// Number of Quadrature Points = 6

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double phi_0_Basis_Val_0_0_0[NQ][NB] = { \
    {8.16847572980458958E-01, -1.83152427019541042E-01, 8.16847572980458958E-01}, \
    {9.15762135097710067E-02, -9.08423786490229035E-01, 9.15762135097710067E-02}, \
    {9.15762135097710067E-02, -9.08423786490229035E-01, 9.15762135097710067E-02}, \
    {1.08103018168069998E-01, -8.91896981831930002E-01, 1.08103018168069998E-01}, \
    {4.45948490915965001E-01, -5.54051509084034999E-01, 4.45948490915965001E-01}, \
    {4.45948490915965001E-01, -5.54051509084034999E-01, 4.45948490915965001E-01}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double phi_0_Basis_Val_0_1_0[NQ][NB] = { \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double phi_0_Basis_Val_1_0_0[NQ][NB] = { \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double phi_1_Basis_Val_0_0_0[NQ][NB] = { \
    {9.15762135097710067E-02, 9.15762135097710067E-02, -9.08423786490229035E-01}, \
    {8.16847572980458958E-01, 8.16847572980458958E-01, -1.83152427019541042E-01}, \
    {9.15762135097710067E-02, 9.15762135097710067E-02, -9.08423786490229035E-01}, \
    {4.45948490915965001E-01, 4.45948490915965001E-01, -5.54051509084034999E-01}, \
    {1.08103018168069998E-01, 1.08103018168069998E-01, -8.91896981831930002E-01}, \
    {4.45948490915965001E-01, 4.45948490915965001E-01, -5.54051509084034999E-01}  \
    };

    // Value of basis function, derivatives = [0  1  0], at quadrature points
    static const double phi_1_Basis_Val_0_1_0[NQ][NB] = { \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}, \
    {1.00000000000000000E+00, 1.00000000000000000E+00, 1.00000000000000000E+00}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double phi_1_Basis_Val_1_0_0[NQ][NB] = { \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 0.00000000000000000E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][SUB_TD] = { \
//     {8.16847572980458958E-01, 9.15762135097710067E-02}, \
//     {9.15762135097710067E-02, 8.16847572980458958E-01}, \
//     {9.15762135097710067E-02, 9.15762135097710067E-02}, \
//     {1.08103018168069998E-01, 4.45948490915965001E-01}, \
//     {4.45948490915965001E-01, 1.08103018168069998E-01}, \
//     {4.45948490915965001E-01, 4.45948490915965001E-01}  \
//     };

// // set of quadrature weights
// static const double Quad_Weights[NQ] = { \
//     5.49758718276609978E-02, \
//     5.49758718276609978E-02, \
//     5.49758718276609978E-02, \
//     1.11690794839005500E-01, \
//     1.11690794839005500E-01, \
//     1.11690794839005500E-01  \
//     };
/*------------   END: Auto Generate ------------*/
    // get local orientation of (vector) basis functions
    Func_vv_Orient[0][0].a = Mesh->Orientation[0];
    Func_vv_Orient[1][0].a = Mesh->Orientation[1];
    Func_vv_Orient[2][0].a = Mesh->Orientation[2];

/*------------ BEGIN: Auto Generate ------------*/
    /*** compute basis function quantities ***/
    // see orientation computation above!
    
    // map basis vectors over (indexing is in the C style)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // evaluate for each basis function
        for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
            {
            VEC_2x1 vv_orient, vv_temp;
            // initialize with orientation adjustment
            vv_orient.v[0] = Func_vv_Orient[basis_i][0].a * phi_0_Basis_Val_0_0_0[qp_i][basis_i];
            vv_orient.v[1] = Func_vv_Orient[basis_i][0].a * phi_1_Basis_Val_0_0_0[qp_i][basis_i];
            // pre-multiply by 1/det(Jac)
            Scalar_Mult_Vector(vv_orient, Mesh->Map_Inv_Det_Jac[0], vv_temp);
            Mat_Vec(Mesh->Map_PHI_Grad[0], vv_temp, Func_vv_Value[basis_i][qp_i]);
            }
        }
    // map divergence of basis vectors over (indexing is in the C style)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // evaluate for each basis function
        for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
            {
            // initialize with orientation adjustment
            const double dv0_dx0 = Func_vv_Orient[basis_i][0].a * phi_0_Basis_Val_1_0_0[qp_i][basis_i];
            const double dv1_dx1 = Func_vv_Orient[basis_i][0].a * phi_1_Basis_Val_0_1_0[qp_i][basis_i];
            // pre-multiply by 1/det(Jac)
            Func_vv_Div[basis_i][qp_i].a = (dv0_dx0 + dv1_dx1) * Mesh->Map_Inv_Det_Jac[0].a;
            }
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

// remove those macros!
#undef SpecificFUNC
#undef SpecificFUNC_str

#undef SPACE_type
#undef SPACE_name
#undef SUB_TD
#undef DOI_TD
#undef GD
#undef NC
#undef NB
#undef NQ

/***/
