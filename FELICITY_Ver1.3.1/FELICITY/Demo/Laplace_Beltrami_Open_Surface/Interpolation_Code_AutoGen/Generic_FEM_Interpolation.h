/*
============================================================================================
   Header file for a C++ Class that contains methods for generic finite element
   interpolation.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 01-29-2013,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set the number of FEM interpolations to evaluate
#define NUM_FEM_INTERP    1

// In MATLAB, the output (INTERP) interpolation data should look like:
//            INTERP.DATA
//                  .Name
//
// Here, we define the strings that makes these variable names
#define OUT_DATA_str    "DATA"
#define OUT_NAME_str    "Name"
/*------------   END: Auto Generate ------------*/

/***************************************************************************************/
/*** C++ class ***/
class Generic_FEM_Interpolation
{
public:
    //Generic_FEM_Interpolation (); // constructor
    Generic_FEM_Interpolation (const mxArray *[]); // constructor
    ~Generic_FEM_Interpolation (); // DE-structor

    /*------------ BEGIN: Auto Generate ------------*/
    // create access routines
    const Data_Type_f_restricted_to_Hold_All* Get_f_restricted_to_Hold_All_ptr() const { return &(f_restricted_to_Hold_All); }

    void Setup_Data (const mxArray*[]);
    void Evaluate_Interpolations ();
    void Output_Interpolations (mxArray*[]);
    void Init_Output_Data (mxArray*[]);
    void Output_Single_Interpolation (mwIndex, mxArray*, mxArray*, mxArray*);

private:
    // these variables are defined from inputs coming from MATLAB

    // classes for (sub)domain(s) and topological entities
    CLASS_Domain_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All    Domain_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All;

    // classes for accessing interpolation points on subdomains
    Unstructured_Interpolation_Class    Hold_All_Interp_Data;

    // mesh geometry classes (can be higher order)
    CLASS_geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All   geom_Hold_All_embedded_in_Hold_All_restricted_to_Hold_All;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // pointers to each specific FEM interpolation
    I_h_f*    Iobj_I_h_f;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing and evaulating FEM (local) basis functions
    Data_Type_GS_phi_restricted_to_Hold_All      GS_phi_restricted_to_Hold_All;
    /*------------   END: Auto Generate ------------*/

    /*------------ BEGIN: Auto Generate ------------*/
    // create variables for accessing external functions
    Data_Type_f_restricted_to_Hold_All      f_restricted_to_Hold_All;
    /*------------   END: Auto Generate ------------*/

};

/***/
