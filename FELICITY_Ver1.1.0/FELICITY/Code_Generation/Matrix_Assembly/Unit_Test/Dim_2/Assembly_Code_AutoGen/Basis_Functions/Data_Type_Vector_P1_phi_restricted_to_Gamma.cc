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
#define SpecificFUNC        Data_Type_Vector_P1_phi_restricted_to_Gamma
#define SpecificFUNC_str   "Data_Type_Vector_P1_phi_restricted_to_Gamma"

// set the type of function space
#define SPACE_type  "CG - lagrange_deg1_dim2"
// set the name of function space
#define SPACE_name  "Vector_P1"

// set the Subdomain topological dimension
#define SUB_TD  2
// set the Domain of Integration (DoI) topological dimension
#define DOI_TD  2
// set the geometric dimension
#define GD  3
// set the number of vector components
#define NC  3
// set the number of quad points
#define NQ  19
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

    // constructor
    SpecificFUNC ();
    ~SpecificFUNC (); // destructor
    void Setup_Function_Space(const mxArray*);
    void Get_Local_to_Global_DoFmap(const int&, int*) const;
                   // need the "const" to ENSURE that nothing in this object will change!
    void Transform_Basis_Functions();
    const CLASS_geom_Gamma_embedded_in_Gamma_restricted_to_Gamma*  Mesh;

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
// Local Element defined on Subdomain: CG, lagrange_deg1_dim2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 2
// geometric dimension = 3
// Number of Quadrature Points = 19

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double phi_0_Basis_Val_0_0_0[NQ][NB] = { \
    {3.33333333333333315E-01, 3.33333333333333315E-01, 3.33333333333333315E-01}, \
    {2.06349616025247595E-02, 4.89682519198737620E-01, 4.89682519198737620E-01}, \
    {4.89682519198737620E-01, 4.89682519198737620E-01, 2.06349616025247456E-02}, \
    {4.89682519198737620E-01, 2.06349616025247456E-02, 4.89682519198737620E-01}, \
    {1.25820817014126729E-01, 4.37089591492936635E-01, 4.37089591492936635E-01}, \
    {4.37089591492936635E-01, 4.37089591492936635E-01, 1.25820817014126729E-01}, \
    {4.37089591492936635E-01, 1.25820817014126729E-01, 4.37089591492936635E-01}, \
    {6.23592928761934617E-01, 1.88203535619032719E-01, 1.88203535619032719E-01}, \
    {1.88203535619032664E-01, 1.88203535619032719E-01, 6.23592928761934617E-01}, \
    {1.88203535619032664E-01, 6.23592928761934617E-01, 1.88203535619032719E-01}, \
    {9.10540973211094617E-01, 4.47295133944527121E-02, 4.47295133944527121E-02}, \
    {4.47295133944526704E-02, 4.47295133944527121E-02, 9.10540973211094617E-01}, \
    {4.47295133944526704E-02, 9.10540973211094617E-01, 4.47295133944527121E-02}, \
    {7.41198598784498008E-01, 3.68384120547362859E-02, 2.21962989160765706E-01}, \
    {7.41198598784498008E-01, 2.21962989160765706E-01, 3.68384120547362859E-02}, \
    {2.21962989160765706E-01, 3.68384120547362859E-02, 7.41198598784498008E-01}, \
    {2.21962989160765706E-01, 7.41198598784498008E-01, 3.68384120547362859E-02}, \
    {3.68384120547362859E-02, 2.21962989160765706E-01, 7.41198598784498008E-01}, \
    {3.68384120547362859E-02, 7.41198598784498008E-01, 2.21962989160765706E-01}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][SUB_TD] = { \
//     {3.33333333333333315E-01, 3.33333333333333315E-01}, \
//     {4.89682519198737620E-01, 4.89682519198737620E-01}, \
//     {4.89682519198737620E-01, 2.06349616025247456E-02}, \
//     {2.06349616025247456E-02, 4.89682519198737620E-01}, \
//     {4.37089591492936635E-01, 4.37089591492936635E-01}, \
//     {4.37089591492936635E-01, 1.25820817014126729E-01}, \
//     {1.25820817014126729E-01, 4.37089591492936635E-01}, \
//     {1.88203535619032719E-01, 1.88203535619032719E-01}, \
//     {1.88203535619032719E-01, 6.23592928761934617E-01}, \
//     {6.23592928761934617E-01, 1.88203535619032719E-01}, \
//     {4.47295133944527121E-02, 4.47295133944527121E-02}, \
//     {4.47295133944527121E-02, 9.10540973211094617E-01}, \
//     {9.10540973211094617E-01, 4.47295133944527121E-02}, \
//     {3.68384120547362859E-02, 2.21962989160765706E-01}, \
//     {2.21962989160765706E-01, 3.68384120547362859E-02}, \
//     {3.68384120547362859E-02, 7.41198598784498008E-01}, \
//     {7.41198598784498008E-01, 3.68384120547362859E-02}, \
//     {2.21962989160765706E-01, 7.41198598784498008E-01}, \
//     {7.41198598784498008E-01, 2.21962989160765706E-01}  \
//     };

// // set of quadrature weights
// static const double Quad_Weights[NQ] = { \
//     4.85678981413994182E-02, \
//     1.56673501135695357E-02, \
//     1.56673501135695357E-02, \
//     1.56673501135695357E-02, \
//     3.89137705023871391E-02, \
//     3.89137705023871391E-02, \
//     3.89137705023871391E-02, \
//     3.98238694636051244E-02, \
//     3.98238694636051244E-02, \
//     3.98238694636051244E-02, \
//     1.27888378293490156E-02, \
//     1.27888378293490156E-02, \
//     1.27888378293490156E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02  \
//     };
/*------------   END: Auto Generate ------------*/
    // set basis function values to the correct mesh entity
    Func_f_Value = &Value_p1; // point to the correct mesh entity

/*------------ BEGIN: Auto Generate ------------*/
    /*** compute basis function quantities ***/
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
// Local Element defined on Subdomain: CG, lagrange_deg1_dim2
// the Subdomain             has topological dimension = 2
// the Domain of Integration has topological dimension = 2
// geometric dimension = 3
// Number of Quadrature Points = 19

    // Value of basis function, derivatives = [0  0  0], at quadrature points
    static const double phi_0_Basis_Val_0_0_0[NQ][NB] = { \
    {3.33333333333333315E-01, 3.33333333333333315E-01, 3.33333333333333315E-01}, \
    {2.06349616025247595E-02, 4.89682519198737620E-01, 4.89682519198737620E-01}, \
    {4.89682519198737620E-01, 4.89682519198737620E-01, 2.06349616025247456E-02}, \
    {4.89682519198737620E-01, 2.06349616025247456E-02, 4.89682519198737620E-01}, \
    {1.25820817014126729E-01, 4.37089591492936635E-01, 4.37089591492936635E-01}, \
    {4.37089591492936635E-01, 4.37089591492936635E-01, 1.25820817014126729E-01}, \
    {4.37089591492936635E-01, 1.25820817014126729E-01, 4.37089591492936635E-01}, \
    {6.23592928761934617E-01, 1.88203535619032719E-01, 1.88203535619032719E-01}, \
    {1.88203535619032664E-01, 1.88203535619032719E-01, 6.23592928761934617E-01}, \
    {1.88203535619032664E-01, 6.23592928761934617E-01, 1.88203535619032719E-01}, \
    {9.10540973211094617E-01, 4.47295133944527121E-02, 4.47295133944527121E-02}, \
    {4.47295133944526704E-02, 4.47295133944527121E-02, 9.10540973211094617E-01}, \
    {4.47295133944526704E-02, 9.10540973211094617E-01, 4.47295133944527121E-02}, \
    {7.41198598784498008E-01, 3.68384120547362859E-02, 2.21962989160765706E-01}, \
    {7.41198598784498008E-01, 2.21962989160765706E-01, 3.68384120547362859E-02}, \
    {2.21962989160765706E-01, 3.68384120547362859E-02, 7.41198598784498008E-01}, \
    {2.21962989160765706E-01, 7.41198598784498008E-01, 3.68384120547362859E-02}, \
    {3.68384120547362859E-02, 2.21962989160765706E-01, 7.41198598784498008E-01}, \
    {3.68384120547362859E-02, 7.41198598784498008E-01, 2.21962989160765706E-01}  \
    };

// // set of quadrature points
// static const double Quad_Points[NQ][SUB_TD] = { \
//     {3.33333333333333315E-01, 3.33333333333333315E-01}, \
//     {4.89682519198737620E-01, 4.89682519198737620E-01}, \
//     {4.89682519198737620E-01, 2.06349616025247456E-02}, \
//     {2.06349616025247456E-02, 4.89682519198737620E-01}, \
//     {4.37089591492936635E-01, 4.37089591492936635E-01}, \
//     {4.37089591492936635E-01, 1.25820817014126729E-01}, \
//     {1.25820817014126729E-01, 4.37089591492936635E-01}, \
//     {1.88203535619032719E-01, 1.88203535619032719E-01}, \
//     {1.88203535619032719E-01, 6.23592928761934617E-01}, \
//     {6.23592928761934617E-01, 1.88203535619032719E-01}, \
//     {4.47295133944527121E-02, 4.47295133944527121E-02}, \
//     {4.47295133944527121E-02, 9.10540973211094617E-01}, \
//     {9.10540973211094617E-01, 4.47295133944527121E-02}, \
//     {3.68384120547362859E-02, 2.21962989160765706E-01}, \
//     {2.21962989160765706E-01, 3.68384120547362859E-02}, \
//     {3.68384120547362859E-02, 7.41198598784498008E-01}, \
//     {7.41198598784498008E-01, 3.68384120547362859E-02}, \
//     {2.21962989160765706E-01, 7.41198598784498008E-01}, \
//     {7.41198598784498008E-01, 2.21962989160765706E-01}  \
//     };

// // set of quadrature weights
// static const double Quad_Weights[NQ] = { \
//     4.85678981413994182E-02, \
//     1.56673501135695357E-02, \
//     1.56673501135695357E-02, \
//     1.56673501135695357E-02, \
//     3.89137705023871391E-02, \
//     3.89137705023871391E-02, \
//     3.89137705023871391E-02, \
//     3.98238694636051244E-02, \
//     3.98238694636051244E-02, \
//     3.98238694636051244E-02, \
//     1.27888378293490156E-02, \
//     1.27888378293490156E-02, \
//     1.27888378293490156E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02, \
//     2.16417696886446881E-02  \
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
