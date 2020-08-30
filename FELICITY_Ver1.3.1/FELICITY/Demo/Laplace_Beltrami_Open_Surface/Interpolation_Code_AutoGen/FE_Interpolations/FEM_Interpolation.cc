/*
============================================================================================
   This (abstract base) class is for interpolating a FEM expression.

   Copyright (c) 01-30-2013,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* C++ abstract base class */
#define FIC FEM_Interpolation_Class
class FIC
{
protected:
    // declare variables for internal use
    unsigned int  num_row, num_col; // size of interpolation data

public:
    mxArray*   mxInterp_Data;
    char*      Name; // name of the particular FEM interpolation
    FIC (); // constructor
    ~FIC (); // DE-structor
};


/***************************************************************************************/
/* constructor */
FIC::FIC ()
{
    mxInterp_Data = NULL;
    Name          = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
FIC::~FIC ()
{
}
/***************************************************************************************/

#undef FIC

/***/
