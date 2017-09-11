/*
============================================================================================
   This class is for storing and accessing interpolation points.

   Copyright (c) 02-04-2013,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* C++ class */
#define UIC Unstructured_Interpolation_Class
class UIC
{
private:
    // declare variables for internal use
    const mxArray*        mxInterp_Points;
    /* mxInterp_Points is MATLAB data that looks like:
          {element indices (i.e. cell indices),  local coordinates},
          i.e. a 1x2 cell array:
               1st entry: a column vector of unsigned int's that index which
                          computational cell to interpolate over.
               2nd entry: RxT matrix of local coordinates (within reference cell)
                          to interpolate AT.  R is the number of points and
                          is the same as the length of <1st entry>, and T
                          is the topological dimension of the cell. */

public:
    const char*           Domain_Name; // name of interpolation domain
    unsigned int          Top_Dim;     // topological dimension of the cells to interpolate over
    const unsigned int*   Cell_Index;  // array of the enclosing cell index for each interpolation point
    const double*         Local_X[3];  // allow for up to 3-dimensions
    unsigned int          Num_Pts;     // number of interpolation points

    UIC (); // constructor
    ~UIC (); // DE-structor
    void Setup (const char*, unsigned int, const mxArray*);
    void Print_Error_Msg ();
    void Copy_Local_X (const unsigned int&, double*);
};

/***************************************************************************************/
/* constructor */
UIC::UIC ()
{
    mxInterp_Points = NULL;
    Domain_Name  = NULL;
    Top_Dim      = 0;
    Cell_Index   = NULL;
    Local_X[0]   = NULL;
    Local_X[1]   = NULL;
    Local_X[2]   = NULL;
    Num_Pts      = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
UIC::~UIC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* setup access to interpolation point data */
void UIC::Setup (const char* Dom_Name, unsigned int TD, const mxArray* INPUT_mxInterp_Points)
{
    Domain_Name     = Dom_Name;
    Top_Dim         = TD;
    mxInterp_Points = INPUT_mxInterp_Points;

    /* BEGIN: error checking */
    const mxArray* mxInterp_Cell_Indices = mxGetCell(mxInterp_Points, (mwIndex) 0);
    Num_Pts                          = (unsigned int) mxGetM(mxInterp_Cell_Indices);
    const unsigned int Num_Col_Cell  = (unsigned int) mxGetN(mxInterp_Cell_Indices);
    const mxArray* mxInterp_Local_X  = mxGetCell(mxInterp_Points, (mwIndex) 1);
    const unsigned int Num_Row_Local = (unsigned int) mxGetM(mxInterp_Local_X);
    const unsigned int Num_Col_Local = (unsigned int) mxGetN(mxInterp_Local_X);

    if (mxGetClassID(mxInterp_Cell_Indices) != mxUINT32_CLASS)
        {
        mexPrintf("ERROR: This concerns the interpolation points on the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The interpolation cell indices column vector must be uint32!\n");
        Print_Error_Msg();
        }
    if (Num_Col_Cell!=1)
        {
        mexPrintf("ERROR: This concerns the interpolation points on the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The number of columns of interpolation cell indices does NOT equal 1!\n");
        Print_Error_Msg();
        }
    if (Num_Pts!=Num_Row_Local)
        {
        mexPrintf("ERROR: This concerns the interpolation points on the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The number of cell indices does NOT equal the number of local interpolation points!\n");
        Print_Error_Msg();
        }
    if (Num_Col_Local!=Top_Dim)
        {
        mexPrintf("ERROR: This concerns the interpolation points on the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The number of columns of the local interpolation points!\n");
        mexPrintf("ERROR:     does not equal %d (i.e. the topological dimension of the cell)!\n",Top_Dim);
        Print_Error_Msg();
        }
    /* END: error checking */

    // access the cell indices
    Cell_Index = (const unsigned int*) mxGetPr(mxInterp_Cell_Indices);

    // access the local coordinates
    Local_X[0] = (const double*) mxGetPr(mxInterp_Local_X);
    for (unsigned int ii = 1; (ii < Top_Dim); ii++)
        Local_X[ii] = Local_X[ii-1] + Num_Pts;
}
/***************************************************************************************/


/***************************************************************************************/
/* print generic error message if interpolation points are not in the correct format */
void UIC::Print_Error_Msg()
{
    mexPrintf("       The interpolation points (data) from MATLAB must look like: \n");
    mexPrintf("       {element indices (i.e. cell indices),  local coordinates}, i.e. a 1x2 cell array:\n");
    mexPrintf("       1st entry: a column vector of uint32's that index which\n");
    mexPrintf("                  computational cell to interpolate over.\n");
    mexPrintf("       2nd entry: RxT matrix of local coordinates (within reference cell)\n");
    mexPrintf("                  to interpolate at.  R is the number of points and\n");
    mexPrintf("                  is the same as the length of <1st entry>, and T\n");
    mexPrintf("                  is the topological dimension of the cell.\n");
    mexErrMsgTxt("Make sure your interpolation points are in the correct format!\n");
}
/***************************************************************************************/


/***************************************************************************************/
/* copy the local coordinates (for a given interpolation point) */
void UIC::Copy_Local_X(const unsigned int& Pt_Index, double* a)
{
    if (Pt_Index >= Num_Pts) mexErrMsgTxt("Pt_Index outside valid range!\n");

    // // init to zero
    // a[0] = 0.0; a[1] = 0.0; a[2] = 0.0;
    // copy
    for (unsigned int ii = 0; (ii < Top_Dim); ii++)
        a[ii] = Local_X[ii][Pt_Index];
}
/***************************************************************************************/

#undef UIC

/***/
