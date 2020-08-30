/*
============================================================================================
   This class points to outside MATLAB data which contains info about a given FE function.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 01-18-2018,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// define the name of the FEM function (should be the same as the filename of this file)
#define SpecificNAME       "NV_h"
#define SpecificFUNC        Data_Type_NV_h_restricted_to_dGamma
#define SpecificFUNC_str   "Data_Type_NV_h_restricted_to_dGamma"

// set the type of function space
#define SPACE_type  "CG - lagrange_deg2_dim2"

// set the number of cartesian tuple components (m*n) = 3 * 1
#define NC  3
// NOTE: the (i,j) tuple component is accessed by the linear index k = i + (j-1)*m
// set the number of quad points
#define NQ  5
// set the number of basis functions
#define NB  6
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* C++ (Specific) FEM Function class definition */
class SpecificFUNC
{
public:
    // pointer to basis function that drives this coefficient function
    const Data_Type_G_h_phi_restricted_to_dGamma*     basis_func;

    double*  Node_Value[NC];  // node values

    char*    Name;              // specifies the name of the finite element function itself
    char*    CPP_Routine;       // specifies the name of the C++ routine itself (only needed for debugging)
    char*    Type;              // specifies the name of function space (only needed for debugging)
    int      Num_Nodes;         // number of nodes (number of global DoFs)
    int      Num_Comp;          // number of (scalar) components (i.e. is it a vector or scalar?)
    int      Num_QP;            // number of quadrature points used

    // data structure containing information on the function evaluations.
    // Note: this data is evaluated at several quadrature points!
    // coefficient function evaluated at a quadrature point in reference element
    SCALAR Func_f_Value[NC][NQ];

    // constructor
    SpecificFUNC ();
    ~SpecificFUNC (); // destructor
    void Setup_Function_Space(const mxArray*, const Data_Type_G_h_phi_restricted_to_dGamma*);
    void Compute_Func();
private:
};
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* constructor */
SpecificFUNC::SpecificFUNC ()
{
    Name        = (char*) SpecificNAME;
    CPP_Routine = (char*) SpecificFUNC_str;
    Type        = (char*) SPACE_type;
    Num_Nodes   = 0;
    Num_Comp    = NC;
    Num_QP      = NQ;

    // init pointers
    basis_func = NULL;
    for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)
        Node_Value[nc_i] = NULL;

    // init everything to zero
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
    for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)
        Func_f_Value[nc_i][qp_i].Set_To_Zero();
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/


/***************************************************************************************/
/* DE-structor */
SpecificFUNC::~SpecificFUNC ()
{
}
/***************************************************************************************/


/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* put incoming function data from MATLAB into a nice struct  */
void SpecificFUNC::Setup_Function_Space(const mxArray* Values,        // inputs
                                        const Data_Type_G_h_phi_restricted_to_dGamma*   basis_func_input)          // inputs
{
    basis_func = basis_func_input;
/*------------   END: Auto Generate ------------*/

    // get the number of columns (components)
    int CHK_Num_Comp = (int) mxGetN(Values);
    // get the number of vertices
    int Temp_Num_Nodes = (int) mxGetM(Values);

    /* BEGIN: Error Checking */
    if (CHK_Num_Comp != Num_Comp)
        {
        mexPrintf("ERROR: Function Nodal Value List for %s has %d columns; expected %d columns.\n", Name, CHK_Num_Comp, Num_Comp);
        mexPrintf("ERROR: You should check the function: Name = %s, Type = %s!\n",Name,Type);
        mexErrMsgTxt("ERROR: number of function components must match!");
        }
    if (Temp_Num_Nodes < basis_func->Num_Nodes)
        {
        mexPrintf("ERROR: Function Nodal Value List for %s has %d rows; expected at least %d rows.\n", Name, Temp_Num_Nodes, basis_func->Num_Nodes);
        mexPrintf("ERROR: You should check the function: Name = %s, Type = %s, \n",Name,Type);
        mexPrintf("ERROR:     and make sure you are using the correct DoFmap.\n");
        mexErrMsgTxt("ERROR: number of given function values must >= what the DoFmap references!");
        }
    if (basis_func->Num_Basis != NB)
        {
        mexPrintf("ERROR: Coefficient Function %s has %d basis functions,\n", Name, NB);
        mexPrintf("ERROR:         but reference function space has %d basis functions,\n", basis_func->Num_Basis);
        mexPrintf("ERROR: You should check the function: Name = %s, Type = %s, \n",Name,Type);
        mexPrintf("ERROR:     and make sure you are using the correct DoFmap.\n");
        mexErrMsgTxt("ERROR: number of basis functions describing function must match!");
        }
    /* END: Error Checking */

    // if we make it here, then update the number of DoFs
    Num_Nodes = Temp_Num_Nodes;
    // split up the columns of the node data
    Node_Value[0] = mxGetPr(Values);
    for (int nc_i = 1; (nc_i < Num_Comp); nc_i++)
        Node_Value[nc_i] = Node_Value[nc_i-1] + Num_Nodes;
}
/***************************************************************************************/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* compute the local transformation from the standard reference element
          to an element in the Domain     */
void SpecificFUNC::Compute_Func()
{
// get current FE space element index
const int elem_index = basis_func->Mesh->Domain->Sub_Cell_Index;

int kc[NB];      // for indexing through the function's DoFmap

basis_func->Get_Local_to_Global_DoFmap(elem_index, kc);

/*------------ BEGIN: Auto Generate ------------*/
    /*** compute coefficient function quantities ***/
    // get coefficient function values
    // loop through quad points
    for (int qp_i = 0; (qp_i < Num_QP); qp_i++)
        {
        // loop through all components (indexing is in the C style)
        for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)
            {
            Func_f_Value[nc_i][qp_i].a = (*basis_func->Func_f_Value)[0][qp_i].a * Node_Value[nc_i][kc[0]]; // first basis function
            // sum over basis functions
            for (int basis_i = 1; (basis_i < NB); basis_i++)
                {
                Func_f_Value[nc_i][qp_i].a += (*basis_func->Func_f_Value)[basis_i][qp_i].a * Node_Value[nc_i][kc[basis_i]];
                }
            }
        }
/*------------   END: Auto Generate ------------*/
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

// remove those macros!
#undef SpecificNAME
#undef SpecificFUNC
#undef SpecificFUNC_str

#undef SPACE_type
#undef NC
#undef NQ
#undef NB

/***/
