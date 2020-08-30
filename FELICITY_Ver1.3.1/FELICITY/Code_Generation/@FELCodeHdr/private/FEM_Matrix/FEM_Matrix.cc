/*
============================================================================================
   This (abstract base) class is for assembling each FEM matrix.

   Copyright (c) 06-20-2012,  Shawn W. Walker
============================================================================================
*/

ERROR: do not use!!!!


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
#define FMC FEM_MATRIX_Class
class FMC
{
protected:
    // pointers to data in 'Generic_FEM_Assembly' class
    const PTR_TO_SPARSE*   Sparse_Data;
    
    // declare variables for internal use
    int  global_num_row, global_num_col;
    int  Num_Sub_Matrices;

public:
    AbstractAssembler* MAT;  // data structure for storing and assembling the sparse FEM matrix
    char*              Name; // name of the particular FEM matrix
    FMC (); // constructor
    virtual ~FMC (); // DE-structor (it MUST be virtual!)
};


/***************************************************************************************/
/* constructor */
FMC::FMC ()
{
	Sparse_Data = NULL;
	MAT         = NULL;
	Name        = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
FMC::~FMC ()
{
}
/***************************************************************************************/

#undef FMC

/***/
