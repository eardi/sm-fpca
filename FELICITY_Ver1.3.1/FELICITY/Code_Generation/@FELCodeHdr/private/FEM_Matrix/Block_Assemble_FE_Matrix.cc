/*
============================================================================================
   This (abstract base) class is for *assembling* a global FE matrix consisting of many
   "blocks".  Each "block" corresponds to a *single* particular "form", e.g.
   Bilinear Form, Linear Form, or "Real" Form, where each "block" is assembled by
   adding in the contribution from many *local* FE matrices.
   
   So, this matrix consists of several global FE matrices that are concatenated together
   (e.g. like in a mixed method).  It can, of course, contain only a single "block",
   which is the more standard situation.
   
   Note: there is no "computing" of the local FE matrix here.  This class simply inserts
   many local FE matrices into a global matrix.

   Copyright (c) 06-16-2016,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
// a struct for holding pointers to sparse data structures
typedef struct
{
    bool       valid;
    char*      name;
    int        m;
    int        n;
    mwIndex*   jc;
    mwIndex*   ir;
	double*    pr;
}
PTR_TO_SPARSE;


/***************************************************************************************/
/* C++ abstract base class */
#define BAFEMC Block_Assemble_FE_MATRIX_Class
class BAFEMC
{
protected:
    // pointers to data in 'Generic_FEM_Assembly' class
    const PTR_TO_SPARSE*   Sparse_Data;
    
    // declare variables for internal use
    int  global_num_row, global_num_col; // size of "big" FE matrix
    int  Num_Blocks; // number of sub-blocks of the "big" FE matrix

public:
    AbstractAssembler* MAT;  // data structure for storing and assembling the sparse FEM matrix
    char*              Name; // name of the particular FE matrix
    BAFEMC (); // constructor
    virtual ~BAFEMC (); // DE-structor (it MUST be virtual!)
};


/***************************************************************************************/
/* constructor */
BAFEMC::BAFEMC ()
{
	Sparse_Data = NULL;
	MAT         = NULL;
	Name        = NULL;
	
	global_num_row = 0;
	global_num_col = 0;
	Num_Blocks     = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
BAFEMC::~BAFEMC ()
{
}
/***************************************************************************************/

#undef BAFEMC

/***/
