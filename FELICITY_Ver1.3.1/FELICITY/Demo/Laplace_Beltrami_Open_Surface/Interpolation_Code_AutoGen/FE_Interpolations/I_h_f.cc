/*
============================================================================================
   This file contains an implementation of a derived C++ Class from the abstract base class
   in 'FEM_Interpolation.cc'.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 01-31-2013,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// FEM interpolation is:
//
//    matrix([[f_v1_t1], [f_v1_t2], [f_v1_t3]]), on Hold_All.
//
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
// define the name of the FEM interpolation (should be the same as the filename of this file)
#define SpecificFEM        I_h_f
#define SpecificFEM_str   "I_h_f"

// set the number of rows of the expression
#define ROW_NC  3
// set the number of columns of the expression
#define COL_NC  1
/*------------   END: Auto Generate ------------*/

/***************************************************************************************/
/* C++ (Specific) FEM interpolation class */
class SpecificFEM: public FEM_Interpolation_Class // derive from base class
{
public:
    // pointers to arrays of interpolation data
	// (lengths of those arrays correspond to number of interpolation points)
    double*   Interp_Data[ROW_NC][COL_NC];

    /*------------ BEGIN: Auto Generate ------------*/
    // access local mesh geometry info
    const CLASS_geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All*  geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pointers for accessing coefficient functions
    const Data_Type_f_restricted_to_Hold_All*  f_restricted_to_Hold_All;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // constructor
    SpecificFEM (const unsigned int);
    ~SpecificFEM (); // destructor
    void Init_Interpolation_Data_Arrays(const unsigned int);
    void Eval_All_Interpolations (const unsigned int&);
    /*------------   END: Auto Generate ------------*/
private:
    /*------------ BEGIN: Auto Generate ------------*/
    void Eval_Interp_00(double&);
    void Eval_Interp_10(double&);
    void Eval_Interp_20(double&);
    /*------------   END: Auto Generate ------------*/
};


/***************************************************************************************/
/* constructor */
/*------------ BEGIN: Auto Generate ------------*/
SpecificFEM::SpecificFEM (const unsigned int Num_Interp_Points) :
/*------------   END: Auto Generate ------------*/
FEM_Interpolation_Class () // call the base class constructor
{
    // set the 'Name' of the FEM interpolation
    Name = (char*) SpecificFEM_str;      // this should be the same as the Class identifier
    
    // get the "matrix-valued"-ness of the interpolation
    num_row = ROW_NC;
    num_col = COL_NC;

    // init the output data (MATLAB cell array)
    Init_Interpolation_Data_Arrays(Num_Interp_Points);
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor: should not usually need to be modified */
SpecificFEM::~SpecificFEM ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* this initializes the output data arrays that will contain the interpolation data */
void SpecificFEM::Init_Interpolation_Data_Arrays(const unsigned int Num_Interp_Points)
{
    // create a cell array to contain the interpolation data (to be output to MATLAB eventually)
	mwSize ndim = 2;
	mwSize dims[2];
	dims[0] = (mwSize) num_row;
	dims[1] = (mwSize) num_col;
	mxInterp_Data = mxCreateCellArray(ndim, dims);
	
	// initialize the entries of the cell array with vector arrays (to be filled with interpolation data)
	mwIndex SetIndex = 0; // init
	mwIndex subs[2];
    for (unsigned int ri = 0; (ri < num_row); ri++)
        for (unsigned int ci = 0; (ci < num_col); ci++)
		    {
            mxArray* Interp_Data_Vec = mxCreateDoubleMatrix((mwSize) Num_Interp_Points, 1, mxREAL);
			// get the correct index
			subs[0] = (mwIndex) ri;
			subs[1] = (mwIndex) ci;
			SetIndex = mxCalcSingleSubscript(mxInterp_Data, (mwSize) 2, subs);
			mxSetCell(mxInterp_Data, SetIndex, Interp_Data_Vec);
			// get pointer to interpolation data in the cell array
			mxArray* TEMP = mxGetCell(mxInterp_Data, SetIndex);
			Interp_Data[ri][ci] = mxGetPr(TEMP);
			}
}
/***************************************************************************************/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* evaluate all FEM interpolations */
void SpecificFEM::Eval_All_Interpolations (const unsigned int& Interp_Pt_Index)
{
    // loop through the different sub-interpolations
    Eval_Interp_00(Interp_Data[0][0][Interp_Pt_Index]);
    Eval_Interp_10(Interp_Data[1][0][Interp_Pt_Index]);
    Eval_Interp_20(Interp_Data[2][0][Interp_Pt_Index]);
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* evaluate component-wise interpolation expression */
void SpecificFEM::Eval_Interp_00(double& INTERP)
{

    // Compute interpolation

    // only one point for interpolation
    for (unsigned int qp = 0; qp < 1; qp++)
          INTERP = f_restricted_to_Hold_All->Func_f_Value[0][qp].a;
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* evaluate component-wise interpolation expression */
void SpecificFEM::Eval_Interp_10(double& INTERP)
{

    // Compute interpolation

    // only one point for interpolation
    for (unsigned int qp = 0; qp < 1; qp++)
          INTERP = f_restricted_to_Hold_All->Func_f_Value[1][qp].a;
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* evaluate component-wise interpolation expression */
void SpecificFEM::Eval_Interp_20(double& INTERP)
{

    // Compute interpolation

    // only one point for interpolation
    for (unsigned int qp = 0; qp < 1; qp++)
          INTERP = f_restricted_to_Hold_All->Func_f_Value[2][qp].a;
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

// remove those macros!
#undef SpecificFEM
#undef SpecificFEM_str

#undef ROW_NC
#undef COL_NC

/***/
