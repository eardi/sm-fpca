/*
============================================================================================
   This class is for storing, and read/writing local reference points corresponding to
   given global points.

   Copyright (c) 06-29-2014,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* C++ class */
#define ULPC Unstructured_Local_Points_Class
class ULPC
{
private:
    // declare variables for internal use
    mxArray*        mxLocal_Points;
    /* mxLocal_Points is MATLAB data that looks like:
          {element indices (i.e. cell indices),  local coordinates},
          i.e. a 1x2 cell array:
               1st entry: a column vector of unsigned int's that index which
                          computational cell a local point corresponds to.
               2nd entry: RxT matrix of local coordinates (within reference cell).
                          R is the number of points and is the same as the length
                          of <1st entry>, and T is the topological dimension
                          of the cell. */

public:
    const char*           Domain_Name; // name of domain on which to search
    unsigned int          Top_Dim;     // topological dimension of the cells in the domain
    unsigned int*         Cell_Index;  // array of the enclosing cell index for each local point
    double*               Local_X[3];  // allow for up to 3-dimensions
    unsigned int          Num_Pts;     // number of points

    ULPC (); // constructor
    ~ULPC (); // DE-structor
    void Setup (Subdomain_Search_Data_Class*, unsigned int);
    //void Print_Error_Msg ();
    void Read_Local_X  (const unsigned int&, double*);
    void Write_Local_X (const unsigned int&, const double*);
    mxArray* Get_mxLocal_Points_Ptr () { return mxLocal_Points; }
};

/***************************************************************************************/
/* constructor */
ULPC::ULPC ()
{
    mxLocal_Points = NULL;
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
ULPC::~ULPC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* setup local point data to find */
void ULPC::Setup (Subdomain_Search_Data_Class* Given_Points, unsigned int TD)
{
    Domain_Name     = Given_Points->Domain_Name;
    Top_Dim         = TD;
    Num_Pts         = Given_Points->Num_Pts;

    // create (initialize) local point data (1 x 2 cell array)
    mxLocal_Points = mxCreateCellMatrix((mwSize)1, (mwSize)2);

    // copy over initial guess for the enclosing cell indices
    const mxArray* mxCell_Indices_TEMP = Given_Points->Get_mxCell_Ptr();
    mxArray* mxCell_Indices_Init_Guess; // declare it
    if (mxIsEmpty(mxCell_Indices_TEMP))
        {
        // create new array
        mxCell_Indices_Init_Guess = mxCreateNumericMatrix((mwSize) Num_Pts, (mwSize) 1, mxUINT32_CLASS, mxREAL);
        // init to first cell
        unsigned int* CI_Ptr = (unsigned int*) mxGetPr(mxCell_Indices_Init_Guess);
        for (unsigned int kk = 0; (kk < Num_Pts); kk++)
            CI_Ptr[kk] = 1; // first cell (MATLAB indexing)
        }
    else // copy over
        mxCell_Indices_Init_Guess = mxDuplicateArray(mxCell_Indices_TEMP);
    mxSetCell(mxLocal_Points, (mwSize) 0, mxCell_Indices_Init_Guess);

    // init the local coordinates
    mxArray* mxLocal_Coord = mxCreateDoubleMatrix( (mwSize) Num_Pts, (mwSize) Top_Dim, mxREAL);
    mxSetCell(mxLocal_Points, (mwSize) 1, mxLocal_Coord);

    // access the cell indices
    Cell_Index = (unsigned int*) mxGetPr(mxCell_Indices_Init_Guess);

    // access the local coordinates
    Local_X[0] = (double*) mxGetPr(mxLocal_Coord);
    for (unsigned int ii = 1; (ii < Top_Dim); ii++)
        Local_X[ii] = Local_X[ii-1] + Num_Pts;
}
/***************************************************************************************/


// /***************************************************************************************/
// /* print generic error message if interpolation points are not in the correct format */
// void ULPC::Print_Error_Msg()
// {
    // mexPrintf("       The interpolation points (data) from MATLAB must look like: \n");
    // mexPrintf("       {element indices (i.e. cell indices),  local coordinates}, i.e. a 1x2 cell array:\n");
    // mexPrintf("       1st entry: a column vector of uint32's that index which\n");
    // mexPrintf("                  computational cell to interpolate over.\n");
    // mexPrintf("       2nd entry: RxT matrix of local coordinates (within reference cell)\n");
    // mexPrintf("                  to interpolate at.  R is the number of points and\n");
    // mexPrintf("                  is the same as the length of <1st entry>, and T\n");
    // mexPrintf("                  is the topological dimension of the cell.\n");
    // mexErrMsgTxt("Make sure your interpolation points are in the correct format!\n");
// }
// /***************************************************************************************/


/***************************************************************************************/
/* read the local (reference) coordinates (for a given point) */
void ULPC::Read_Local_X(const unsigned int& Pt_Index, double* a)
{
    if (Pt_Index >= Num_Pts) mexErrMsgTxt("Pt_Index outside valid range!\n");

    // copy to a[]
    for (unsigned int ii = 0; (ii < Top_Dim); ii++)
        a[ii] = Local_X[ii][Pt_Index];
}
/***************************************************************************************/


/***************************************************************************************/
/* write the local (reference) coordinates (for a given point) */
void ULPC::Write_Local_X(const unsigned int& Pt_Index, const double* a)
{
    if (Pt_Index >= Num_Pts) mexErrMsgTxt("Pt_Index outside valid range!\n");

    // write over Local_X
    for (unsigned int ii = 0; (ii < Top_Dim); ii++)
        Local_X[ii][Pt_Index] = a[ii];
}
/***************************************************************************************/

#undef ULPC

/***/
