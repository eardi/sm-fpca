/*
============================================================================================
   This (abstract base) class is for accessing and evaluating finite element functions.

   Copyright (c) 06-07-2012,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* C++ abstract base class */
#define AFC ABSTRACT_FEM_Function_Class
class AFC
{
public:
    char*    Name;                // specifies the name of the finite element function itself
    char*    Type;                // specifies the type of finite element (FE) space (only used for debugging)
    char*    Space_Name;          // specifies the name of FE space (only used for debugging)
    int      Sub_TopDim;          // topological dimension of Subdomain (the FE space is defined on this domain)
    int      DoI_TopDim;          // topological dimension of Domain of Integration (DoI)
    int      GeoDim;              // geometric   dimension of the space that the function space is in
    int      Num_Nodes;           // number of nodes (number of global DoFs)
    int      Num_Comp;            // number of (scalar) components (i.e. is it a vector or scalar?)
    int      Num_Elem;            // number of elements
    int      Num_Basis;           // number of basis functions for each element
                                  // (i.e. number of DoF for element description)
    int      Num_QP;              // number of quadrature points used

    // local coordinates (only used for custom interpolation routines)
    double   local_coord[3];

    // simple local DoFmap for global constant FE spaces
    mxArray* CONST_DoFmap;

    AFC (); // constructor
    virtual ~AFC (); // DE-structor (it MUST be virtual!)
    void Init_Function_Space(const mxArray*);
};


/***************************************************************************************/
/* constructor */
AFC::AFC ()
{
    // init everything else to zero
    Name        = NULL;
    Type        = NULL;
    Space_Name  = NULL;
    Sub_TopDim  = 0;
    DoI_TopDim  = 0;
    GeoDim      = 0;
    Num_Nodes   = 0;
    Num_Elem    = 0;
    Num_Comp    = 0;
    Num_Basis   = 0;
    Num_QP      = 0;

    local_coord[0] = 0.0;
    local_coord[1] = 0.0;
    local_coord[2] = 0.0;

    // setup CONST space DoFmap
    CONST_DoFmap = mxCreateNumericMatrix(1, 1, mxUINT32_CLASS, mxREAL);
    int* CONST_DoFmap_PTR = (int *) mxGetPr(CONST_DoFmap);
    CONST_DoFmap_PTR[0] = 1; // set to 1 for global constant FE space
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
AFC::~AFC ()
{
    mxDestroyArray(CONST_DoFmap);
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming function data from MATLAB into a nice struct  */
void AFC::Init_Function_Space(const mxArray* Elem)      // inputs
{
    // get the number of elements
    Num_Elem  = (int) mxGetM(Elem);
    // get the number of basis functions for each element
    int CHK_Num_Basis = (int) mxGetN(Elem);


    /* BEGIN: Error Checking */
    bool NOT_UINT32           = (mxGetClassID(Elem) != mxUINT32_CLASS);
    bool Num_Basis_NOT_MATCH  = (CHK_Num_Basis != Num_Basis);
    if (NOT_UINT32 || Num_Basis_NOT_MATCH)
        {
        mexPrintf("ERROR: This regards the function: ");
        mexPrintf(Name);
        mexPrintf(", and corresponding function space: ");
        mexPrintf(Space_Name);
        mexPrintf(", of type: ");
        mexPrintf(Type);
        mexPrintf(" ...\n");
        mexPrintf("\n");
        if (NOT_UINT32)
            mexErrMsgTxt("ERROR: the element DoFmap must be uint32!");
        else if (Num_Basis_NOT_MATCH)
            {
            mexPrintf("ERROR: Function's DoFmap has %d columns; expected %d columns.\n", CHK_Num_Basis, Num_Basis);
            mexPrintf("ERROR: A common reason for this error is you are using a finite element space\n");
            mexPrintf("ERROR:     that is higher order than piecewise linear and you forgot to create\n");
            mexPrintf("ERROR:     a distinct DoFmap for that space.\n");
            mexPrintf("ERROR: You *cannot* just use the triangulation data in place of the DoFmap!\n");
            mexPrintf("ERROR:     That only works for continuous piecewise linear finite elements.\n");
            mexErrMsgTxt("ERROR: number of basis functions describing function must match!");
            }
        else
            {
            mexErrMsgTxt("ERROR: THIS SHOULD NOT HAPPEN!  PLEASE REPORT THIS ERROR in 'Abstract_FEM_Function.cc'...");
            }
        }
    /* END: Error Checking */


    // get maximum DoF present
    int* Elem_DoF = (int *) mxGetPr(Elem);
    Num_Nodes   = *std::max_element(Elem_DoF,Elem_DoF+(Num_Elem*Num_Basis));
    int Min_DoF = *std::min_element(Elem_DoF,Elem_DoF+(Num_Elem*Num_Basis));
    if ((Min_DoF < 1) || (Num_Nodes < 1))
        {
        mexPrintf("ERROR: There are DoFs that have indices < 1!\n");
        mexPrintf("ERROR: You should check: Name = %s, Space = %s, Type = %s!\n",Name,Space_Name,Type);
        mexErrMsgTxt("ERROR: Fix your DoFmap!");
        }
}
/***************************************************************************************/

#undef AFC

/***/
