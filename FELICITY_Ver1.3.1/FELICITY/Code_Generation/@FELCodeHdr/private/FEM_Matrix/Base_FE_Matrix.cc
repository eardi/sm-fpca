/*
============================================================================================
   This (abstract base) class is for computing the *local* FE matrix on a given element,
   and for recording the structure of the corresponding global FE matrix.  I.e., this
   computes the local matrix and stores it in some internal data arrays that are in the
   sub-class of this class.  The local FE matrix corresponds to a particular "form",
   e.g. Bilinear Form, Linear Form, or "Real" Form.
   
   Note: no assembly happens in this class, but the "layout" of the sub-matrices of the
   global FE matrix is recorded.  Moreover, only ONE "form" is computed here.

   Copyright (c) 06-16-2016,  Shawn W. Walker
============================================================================================
*/

enum Form_Data_Type { invalid=0, real, linear, bilinear };


/***************************************************************************************/
/* C++ abstract base class */
#define BFEMC Base_FE_MATRIX_Class
class BFEMC
{
protected:
    // declare variables for internal use
    int  global_num_row, global_num_col; // size of the global FE matrix
	int  Num_Sub_Matrices; // not sure why I need this...

public:
    char*              Form_Name; // name of the particular "form" corresponding to the
	                              // local FE matrix
	Form_Data_Type     Form_Type; // enum storing the type of "form".
    BFEMC (); // constructor
    virtual ~BFEMC (); // DE-structor (it MUST be virtual!)
	
	int get_global_num_row() const { return global_num_row; }
	int get_global_num_col() const { return global_num_col; }
};


/***************************************************************************************/
/* constructor */
BFEMC::BFEMC ()
{
	Form_Name          = NULL;
	Form_Type          = invalid;
	global_num_row     = 0;
	global_num_col     = 0;
	Num_Sub_Matrices   = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
BFEMC::~BFEMC ()
{
}
/***************************************************************************************/

#undef BFEMC

/***/
