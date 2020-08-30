/*
============================================================================================
   This class contains data about a given FEM function space, and methods for computing
   transformations of the local basis functions.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 02-17-2011,  Shawn W. Walker
============================================================================================
*/

// define the name of the FEM basis function (should be the same as the filename of this file)
#define SpecificFUNC        Data_Type_CONST_ONE_phi
#define SpecificFUNC_str   "Data_Type_CONST_ONE_phi"
// set the type of function space
#define SPACE_type  "constant_one"
// set the name of function space
#define SPACE_name  "CONSTANT"

/***************************************************************************************/
/* C++ (Specific) FEM Function class definition */
class SpecificFUNC: public ABSTRACT_FEM_Function_Class // derive from base class
{
public:
    // constructor
    SpecificFUNC ();
    ~SpecificFUNC (); // destructor
private:
};

/***************************************************************************************/
/* constructor */
SpecificFUNC::SpecificFUNC () :
ABSTRACT_FEM_Function_Class () // call the base class constructor
{
    Name        = (char*) SpecificFUNC_str;
    Type        = (char*) SPACE_type;
	Space_Name  = (char*) SPACE_name;
    Sub_TopDim  = 0;
	DoI_TopDim  = 0;
    GeoDim      = 0;
    Num_Nodes   = 1;
    Num_Elem    = 0;
    Num_Comp    = 1;
    Num_Basis   = 1;
    Num_QP      = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
SpecificFUNC::~SpecificFUNC ()
{
}
/***************************************************************************************/

// remove those macros!
#undef SpecificFUNC
#undef SpecificFUNC_str
#undef SPACE_type
#undef SPACE_name

/***/
