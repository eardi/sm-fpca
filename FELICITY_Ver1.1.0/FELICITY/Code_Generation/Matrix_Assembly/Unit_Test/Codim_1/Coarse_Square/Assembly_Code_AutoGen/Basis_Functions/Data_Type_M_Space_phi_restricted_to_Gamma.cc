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
#define SpecificFUNC        Data_Type_M_Space_phi_restricted_to_Gamma
#define SpecificFUNC_str   "Data_Type_M_Space_phi_restricted_to_Gamma"

// set the type of function space
#define SPACE_type  "CG - lagrange_deg2_dim1"
// set the name of function space
#define SPACE_name  "M_Space"

// set the Subdomain topological dimension
#define SUB_TD  1
// set the Domain of Integration (DoI) topological dimension
#define DOI_TD  1
// set the geometric dimension
#define GD  2
// set the number of vector components
#define NC  1
// set the number of quad points
#define NQ  5
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
    // local function evaluated at a quadrature point in reference element
    // (this is a pointer because it will change depending on the local mesh entity)
    SCALAR  (*Func_f_Value)[NB][NQ];
    // arc-length derivative of the function
    SCALAR Func_f_d_ds[NB][NQ];

    // constructor
    SpecificFUNC ();
    ~SpecificFUNC (); // destructor
    void Setup_Function_Space(const mxArray*);
    void Get_Local_to_Global_DoFmap(const int&, int*) const;
                   // need the "const" to ENSURE that nothing in this object will change!
    void Transform_Basis_Functions();
    const CLASS_geom_Gamma_embedded_in_Omega_restricted_to_Gamma*  Mesh;

private:
    void Map_Basis_p1();
    SCALAR Value_p1[NB][NQ];
    void Basis_Value_p1(SCALAR V[NB][NQ]);
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
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        Func_f_d_ds[basis_i][qp_i].Set_To_Zero();
    // init basis function values on local mesh entities
    Basis_Value_p1(Value_p1);
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
// Local Element defined on Subdomain: CG, lagrange_deg2_dim1
// the Subdomain             has topological dimension = 1
// the Domain of Integration has topological dimension = 1
// geometric dimension = 2
// Number of Quadrature Points = 5

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double phi_0_Basis_Val_0_0_0[NQ][NB] = { \
    {8.63670879562042249E-01, -4.25089663766216458E-02, 1.78838086814579439E-01}, \
    {4.14209254015686701E-01, -1.24260056089996393E-01, 7.10050802074309706E-01}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.24260056089996393E-01, 4.14209254015686590E-01, 7.10050802074309817E-01}, \
    {-4.25089663766216458E-02, 8.63670879562042249E-01, 1.78838086814579439E-01}  \
    };

    // Value of basis function, derivatives = [1  0  0], at quadrature points
    static const double phi_0_Basis_Val_1_0_0[NQ][NB] = { \
    {-2.81235969187732771E+00, -8.12359691877327705E-01, 3.62471938375465541E+00}, \
    {-2.07693862021136599E+00, -7.69386202113662154E-02, 2.15387724042273243E+00}, \
    {-1.00000000000000000E+00, 1.00000000000000000E+00, 0.00000000000000000E+00}, \
    {7.69386202113659934E-02, 2.07693862021136599E+00, -2.15387724042273199E+00}, \
    {8.12359691877327705E-01, 2.81235969187732771E+00, -3.62471938375465541E+00}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][SUB_TD] = { \
//     4.69100770306680737E-02, \
//     2.30765344947158446E-01, \
//     5.00000000000000000E-01, \
//     7.69234655052841498E-01, \
//     9.53089922969331926E-01  \
//     };

// // set of quadrature weights
// static const double Quad_Weights[NQ] = { \
//     1.18463442528094556E-01, \
//     2.39314335249683374E-01, \
//     2.84444444444444444E-01, \
//     2.39314335249683430E-01, \
//     1.18463442528094445E-01  \
//     };
/*------------   END: Auto Generate ------------*/
    // set basis function values to the correct mesh entity
    Func_f_Value = &Value_p1; // point to the correct mesh entity

/*------------ BEGIN: Auto Generate ------------*/
    /*** compute basis function quantities ***/
    // compute d/ds of the basis function on the true element in the domain (indexing is in the C style)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // multiply by 1 / Det(Jacobian)
        for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
            {
            Func_f_d_ds[basis_i][qp_i].a = phi_0_Basis_Val_1_0_0[qp_i][basis_i] * Mesh->Map_Inv_Det_Jac[0].a;
            }
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* evaluate basis functions on the local reference element */
void SpecificFUNC::Basis_Value_p1(SCALAR BF_V[NB][NQ])
{

/*------------ BEGIN: Auto Generate ------------*/
// Local Element defined on Subdomain: CG, lagrange_deg2_dim1
// the Subdomain             has topological dimension = 1
// the Domain of Integration has topological dimension = 1
// geometric dimension = 2
// Number of Quadrature Points = 5

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double phi_0_Basis_Val_0_0_0[NQ][NB] = { \
    {8.63670879562042249E-01, -4.25089663766216458E-02, 1.78838086814579439E-01}, \
    {4.14209254015686701E-01, -1.24260056089996393E-01, 7.10050802074309706E-01}, \
    {0.00000000000000000E+00, 0.00000000000000000E+00, 1.00000000000000000E+00}, \
    {-1.24260056089996393E-01, 4.14209254015686590E-01, 7.10050802074309817E-01}, \
    {-4.25089663766216458E-02, 8.63670879562042249E-01, 1.78838086814579439E-01}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][SUB_TD] = { \
//     4.69100770306680737E-02, \
//     2.30765344947158446E-01, \
//     5.00000000000000000E-01, \
//     7.69234655052841498E-01, \
//     9.53089922969331926E-01  \
//     };

// // set of quadrature weights
// static const double Quad_Weights[NQ] = { \
//     1.18463442528094556E-01, \
//     2.39314335249683374E-01, \
//     2.84444444444444444E-01, \
//     2.39314335249683430E-01, \
//     1.18463442528094445E-01  \
//     };
/*------------   END: Auto Generate ------------*/
    // copy function evaluations over (indexing is in the C style)
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // evaluate for each basis function
        for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
            {
            BF_V[basis_i][qp_i].a = phi_0_Basis_Val_0_0_0[qp_i][basis_i];
            }
        }
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
