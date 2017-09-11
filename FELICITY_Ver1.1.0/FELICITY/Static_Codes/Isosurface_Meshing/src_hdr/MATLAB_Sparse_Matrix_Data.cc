/*
============================================================================================
   Class for accessing sparse matrix from MATLAB.
   
   Copyright (c) 12-20-2011,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// struct for sparse matrix data
typedef struct
{
	size_t* col_indices;
	double* entries; // this needs to be `double *'.  MATLAB does not like `int *'.
}
SPARSE_STRUCT;


#define SPD Sparse_Data_Class
/***************************************************************************************/
class SPD
{
public:
	SPD (); // constructor
	~SPD (); // DE-structor

	// initalize external data pointers
	void Setup_Data (const mxArray *);
	// get nonzero entries in given column index
	void Get_Nonzero_Entries (const unsigned int, int&, double*);

    // these variables are defined from inputs coming from MATLAB
    int num_row; // size of matrix
    int num_col; // ...

private:
	SPARSE_STRUCT  Sparse_Data; // sparse data structure
};

/***************************************************************************************/
/* constructor */
SPD::SPD ()
{
	// init
	Sparse_Data.col_indices = NULL;
	Sparse_Data.entries     = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
SPD::~SPD ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* initializer */
void SPD::Setup_Data (const mxArray *mxSparseMatrix)
{
	// minor error checking
	if (!mxIsSparse(mxSparseMatrix)) mexErrMsgTxt("ERROR: incoming data must be a sparse matrix!");
	
	// get the pointers
    Sparse_Data.col_indices = (size_t*) mxGetJc(mxSparseMatrix);
	Sparse_Data.entries     = mxGetPr(mxSparseMatrix);
	
	// get matrix size
	num_row = (int) mxGetM(mxSparseMatrix);
	num_col = (int) mxGetN(mxSparseMatrix);
}
/***************************************************************************************/


/***************************************************************************************/
/* get the non-zero entries in the given column index.
   Note: "nonzero_entries" must be pre-allocated! */
void SPD::Get_Nonzero_Entries (const unsigned int col_index, int& num_nonzero, double* nonzero_entries)
{
	// note: the given column index is in MATLAB indexing style (i.e. 1 is first)
	
    int first_entry = (int) Sparse_Data.col_indices[col_index-1];
    int last_entry  = (int) Sparse_Data.col_indices[col_index] - 1;
    num_nonzero = last_entry - first_entry + 1;
    
    // loop through the non-zero entries
    int COUNT = -1;
    for (int index = first_entry; (index <= last_entry); index++)
        {
	    COUNT++;
        nonzero_entries[COUNT] = Sparse_Data.entries[index];
        }
}
/***************************************************************************************/

#undef SPD

/***/
