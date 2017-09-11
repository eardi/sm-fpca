/*
============================================================================================
   This class is for accessing a set of points to search for in a mesh.

   Copyright (c) 06-27-2014,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* C++ class */
#define SSDC Subdomain_Search_Data_Class
class SSDC
{
private:
    // declare variables for internal use
    const mxArray*        mxData;
    /* mxData is MATLAB data that is a 1x3 cell array:
          {element indices (i.e. cell indices),  point (global) coordinates,  sub-domain neighbor data structure},
          i.e. a 1x3 cell array:
               1st entry: a column vector of unsigned int's that is an initial guess
                          indicating which sub-domain cell a global coordinate could be in.
                          (This can be an empty matrix if no initial guess is given.)
               2nd entry: RxD matrix of point coordinates to search for in the sub-domain.
                          R is the number of points and is the same as the length
                          of <1st entry> (if it is non-empty), and D is the ambient
                          geometric dimension of the sub-domain.
               3rd entry: Mx(T+1) matrix of neighbor cell indices (unsigned int's). The ith row
                          corresponds to cell i in the sub-domain, and contains the indices of
                          the neighboring cells k1, k2, ... k(T+1); the neighboring cells are
                          opposite the vertices of cell i.  A "0" indicates that particular
                          neighbor cell does not exist.  M is the number of cells in the sub-domain,
                          and T is the topological dimension of the cells.
                          Ex: if the sub-domain is a triangle mesh, then each cell is
                          a triangle with 3 neighbors that share a "face" of the triangle.
                          */
    const mxArray*        mxCell_Indices; // pointer to <1st entry> of mxData

public:
    const char*           Domain_Name;  // name of domain to search for the given points
    unsigned int          Geo_Dim;      // geometric (ambient) dimension of the points
    unsigned int          Top_Dim;      // topological dimension of the sub-domain
    const unsigned int*   Cell_Index;   // array of the enclosing cell index for each point
    const double*         Global_X[3];  // allow for up to 3 dimensions
    unsigned int          Num_Pts;      // number of points
    const unsigned int*   Neighbor[4];  // allow for up to 4 neighbors
    unsigned int          Num_Cells;    // number of sub-domain cells

    SSDC (); // constructor
    ~SSDC (); // DE-structor
    void Setup (const char*, unsigned int, const mxArray*);
    void Print_Error_Msg ();
	void Read_Global_X (const unsigned int&, double*) const;
    void Read_Neighbors(const unsigned int& CI, unsigned int a[4]) const;
    const mxArray* Get_mxCell_Ptr () { return mxCell_Indices; }
};

/***************************************************************************************/
/* constructor */
SSDC::SSDC ()
{
    mxData         = NULL;
    mxCell_Indices = NULL;
    Domain_Name    = NULL;
    Geo_Dim        = 0;
    Top_Dim        = 0;
    Cell_Index     = NULL;
    Global_X[0]    = NULL;
    Global_X[1]    = NULL;
    Global_X[2]    = NULL;
    Num_Pts        = 0;
    Neighbor[0]    = NULL;
    Neighbor[1]    = NULL;
    Neighbor[2]    = NULL;
    Neighbor[3]    = NULL;
    Num_Cells      = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
SSDC::~SSDC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* setup access to the point (global) coordinates to search for */
void SSDC::Setup (const char* Dom_Name, unsigned int GD, const mxArray* INPUT_mxData)
{
    Domain_Name  = Dom_Name;
    Geo_Dim      = GD;
    mxData       = INPUT_mxData;

    /* BEGIN: error checking */
    // first make sure it is a length 3 cell array
    if ( (!mxIsCell(mxData)) || ((unsigned int) mxGetNumberOfElements(mxData)!=3) )
        {
        mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The search data must be a 1x3 cell array!\n");
        Print_Error_Msg();
        }

                       mxCell_Indices    = mxGetCell(mxData, (mwIndex) 0);
    const unsigned int Num_Row_Cell      = (unsigned int) mxGetM(mxCell_Indices);
    const unsigned int Num_Col_Cell      = (unsigned int) mxGetN(mxCell_Indices);

    const mxArray*     mxGlobal_X        = mxGetCell(mxData, (mwIndex) 1);
                       Num_Pts           = (unsigned int) mxGetM(mxGlobal_X);
    const unsigned int Num_Col_Global    = (unsigned int) mxGetN(mxGlobal_X);

    const mxArray*     mxNeighbor        = mxGetCell(mxData, (mwIndex) 2);
                       Num_Cells         = (unsigned int) mxGetM(mxNeighbor);
    const unsigned int Num_Col_Neighbor  = (unsigned int) mxGetN(mxNeighbor);
    Top_Dim = Num_Col_Neighbor - 1; // the topological dimension of the sub-domain cells

    const bool mxCell_EMPTY = mxIsEmpty(mxCell_Indices);
    if (!mxCell_EMPTY)
        {
        if (mxGetClassID(mxCell_Indices) != mxUINT32_CLASS)
            {
            mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
            mexPrintf("ERROR: The enclosing cell indices column vector must be uint32!\n");
            Print_Error_Msg();
            }
        if (Num_Col_Cell!=1)
            {
            mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
            mexPrintf("ERROR: The number of columns of enclosing cell indices does NOT equal 1!\n");
            Print_Error_Msg();
            }
        if (Num_Pts!=Num_Row_Cell)
            {
            mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
            mexPrintf("ERROR: The number of cell indices does NOT equal the number of points!\n");
            Print_Error_Msg();
            }
        }
    if (Num_Col_Global!=Geo_Dim)
        {
        mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The number of columns of the global points\n");
        mexPrintf("ERROR:     does not equal %d (i.e. the geometric dimension of the Domain)!\n",Geo_Dim);
        Print_Error_Msg();
        }
    if (Geo_Dim < Top_Dim)
        {
        mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The geometric dimension (%d) of the global points\n");
        mexPrintf("ERROR:     is less than the topological dimension (%d) of the Domain!\n",Geo_Dim,Top_Dim);
        Print_Error_Msg();
        }
    if (mxGetClassID(mxNeighbor) != mxUINT32_CLASS)
        {
        mexPrintf("ERROR: This concerns the search data for the Domain: %s\n",Domain_Name);
        mexPrintf("ERROR: The neighbor data matrix must be uint32!\n");
        Print_Error_Msg();
        }
    /* END: error checking */

    // access the cell indices
    if (!mxCell_EMPTY)
        Cell_Index = (const unsigned int*) mxGetPr(mxCell_Indices);

    // access the global coordinates
    Global_X[0] = (const double*) mxGetPr(mxGlobal_X);
    for (unsigned int ii = 1; (ii < Geo_Dim); ii++)
        Global_X[ii] = Global_X[ii-1] + Num_Pts;

    // access the neighbor data
    Neighbor[0] = (const unsigned int*) mxGetPr(mxNeighbor);
    for (unsigned int ii = 1; (ii < (Top_Dim+1)); ii++)
        Neighbor[ii] = Neighbor[ii-1] + Num_Cells;
}
/***************************************************************************************/


/***************************************************************************************/
/* print generic error message if the data is not in the correct format */
void SSDC::Print_Error_Msg()
{
    mexPrintf("       The point search data from MATLAB must be a 1x3 cell array: \n");
    mexPrintf("       {cell indices,  point (global) coordinates,  sub-Domain neighbor data}:\n");
    mexPrintf("       1st entry: a column vector of uint32's that is an initial guess\n");
    mexPrintf("                  for which sub-Domain cells contain the global points.\n");
    mexPrintf("                  (This can be an empty matrix if no initial guess is given.)\n");
    mexPrintf("       2nd entry: RxD matrix of point coordinates to search for in the sub-Domain.\n");
    mexPrintf("                  R is the number of points and is the same as the length\n");
    mexPrintf("                  of <1st entry> (if it is not-empty), and D is the ambient\n");
    mexPrintf("                  geometric dimension of the sub-Domain.\n");
    mexPrintf("       3rd entry: Mx(T+1) matrix of *neighbor* cell indices (uint32's). Row i corresponds to\n");
    mexPrintf("                  cell i in the sub-Domain, and contains the indices of the neighboring\n");
    mexPrintf("                  cells k1, k2, ... k(T+1); the neighboring cells are opposite the\n");
    mexPrintf("                  vertices of cell i.  A '0' indicates that particular neighbor cell\n");
    mexPrintf("                  does not exist. M is the number of cells in the sub-Domain,\n");
    mexPrintf("                  and T is the topological dimension of the cells.\n");
    mexPrintf("\n");
    mexPrintf("                  Ex: if the sub-Domain is a triangle mesh, then each cell is\n");
    mexPrintf("                  a triangle with 3 neighbors that share a 'face' of the triangle.\n");
    mexErrMsgTxt("Make sure your search data is in the correct format!\n");
}
/***************************************************************************************/


/***************************************************************************************/
/* read the global coordinates (for a given point) */
void SSDC::Read_Global_X(const unsigned int& Pt_Index, double* V) const
{
    if (Pt_Index >= Num_Pts) mexErrMsgTxt("Pt_Index outside valid range!\n");

    // // init to zero
    // a[0] = 0.0; a[1] = 0.0; a[2] = 0.0;
    // copy
    for (unsigned int ii = 0; (ii < Geo_Dim); ii++)
        V[ii] = Global_X[ii][Pt_Index];
}
/***************************************************************************************/


/***************************************************************************************/
/* read the neighbor cell indices (for a given cell) */
void SSDC::Read_Neighbors(const unsigned int& Cell_Index, unsigned int a[4]) const
{
    if (Cell_Index >= Num_Cells) mexErrMsgTxt("Cell_Index outside valid range!\n");

    // // init to zero
    // a[0] = 0.0; a[1] = 0.0; a[2] = 0.0;
    // copy
    for (unsigned int ii = 0; (ii < (Top_Dim+1)); ii++)
        a[ii] = Neighbor[ii][Cell_Index];
}
/***************************************************************************************/

#undef SSDC

/***/
