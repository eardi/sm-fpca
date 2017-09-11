/*
============================================================================================
   This class accesses the mesh subdomain data.  Note: this interfaces with the
   Mesh_Geometry_Class.

   NOTE: portions of this code are automatically generated!

   Copyright (c) 06-05-2012,  Shawn W. Walker
============================================================================================
*/

/*------------ BEGIN: Auto Generate ------------*/
// set subdomain data type name
#define MDC        CLASS_Domain_Omega_embedded_in_Omega_restricted_to_Boundary
// set the name of the Global mesh (TopDim = 2)
#define GLOBAL_MESH_Name  "Omega"
// set the name of the subdomain (TopDim = 2)
#define SUBDOMAIN_Name  "Omega"
// set the name of the domain of integration (TopDim = 1)
#define DOMAIN_INTEGRATION_Name  "Boundary"

// set the number of local entities in subdomain
#define SUB_NE  1
// set the number of local entities in domain of integration
#define DOI_NE  3
/*------------   END: Auto Generate ------------*/

/* C++ (Specific) Domain class definition */
class MDC: public Abstract_DOMAIN_Class // derive from base class
{
public:
    MDC (); // constructor
    ~MDC ();   // DE-structor
    void Setup_Data(const mxArray*, const mxArray*);
	void Read_Embed_Data(const unsigned int&);

private:
};

/***************************************************************************************/
/* constructor */
MDC::MDC () : Abstract_DOMAIN_Class ()
{
    Global_Name = (char*) GLOBAL_MESH_Name;
    Sub_Name    = (char*) SUBDOMAIN_Name;
	DoI_Name    = (char*) DOMAIN_INTEGRATION_Name;
    Num_Sub_Entity = SUB_NE;
	Num_DoI_Entity = DOI_NE;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
MDC::~MDC ()
{
}
/***************************************************************************************/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* setup access to incoming MATLAB data that represents subdomain embedding */
void MDC::Setup_Data(const mxArray* Subdomain_Array, const mxArray* Global_Mesh_DoFmap)  // inputs
{
    // retrieve the particular subdomain we need
    const unsigned int DOM_INDEX = Find_Subdomain_Array_Index(Subdomain_Array,"Omega","Omega","Boundary");
    Parse_mxSubdomain(Subdomain_Array, DOM_INDEX, mxData);
    // get number of elements in the Domain of Integration (DoI)
    Num_Elem = (unsigned int) mxGetM(mxData.mxGlobal_Cell);
    // parse the subdomain data into a DOMAIN_EMBEDDING_DATA struct
    Parse_Subdomain(Global_Mesh_DoFmap, mxData, Data);
    // check that we have the correct data
    const bool Global_Cell_EMPTY = mxIsEmpty(mxData.mxGlobal_Cell);
    const bool Sub_Cell_EMPTY    = mxIsEmpty(mxData.mxSub_Cell);
    const bool Sub_Entity_EMPTY  = mxIsEmpty(mxData.mxSub_Entity);
    const bool DoI_Entity_EMPTY  = mxIsEmpty(mxData.mxDoI_Entity);

    if ( !((!Global_Cell_EMPTY) && (Sub_Cell_EMPTY) && (Sub_Entity_EMPTY) && (!DoI_Entity_EMPTY)) )
        {
        mexPrintf("ERROR: ---> There are problems with this Subdomain:\n");
        mexPrintf("ERROR:         Global Domain: %s\n",Global_Name);
        mexPrintf("ERROR:             Subdomain: %s\n",Sub_Name);
        mexPrintf("ERROR: Domain of Integration: %s\n",DoI_Name);
        mexPrintf("ERROR: See Subdomain number %d.\n",DOM_INDEX+1);
        mexPrintf("ERROR: Subdomain data must include the following information:\n");
        mexPrintf("ERROR:           Global_Cell_Index.\n");
        mexPrintf("ERROR:           DoI_Entity_Index.\n");
        mexErrMsgTxt("ERROR: Fix your subdomain embedding mesh data!");
        }
    // check the entity indices
    Error_Check_DoI_Entity_Indices(Data);
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* read the subdomain embedding data for this domain;
   the input is the current DoI element. */
void MDC::Read_Embed_Data(const unsigned int& doi_elem_index)  // inputs
{
    // read it!
    Global_Cell_Index = Data.Global_Cell_Index[doi_elem_index] - 1; // put into C-style
    Sub_Cell_Index = Global_Cell_Index; // Global==Subdomain!=DoI
    DoI_Entity_Index = Data.DoI_Entity_Index[doi_elem_index];
}
/***************************************************************************************/
/*------------   END: Auto Generate ------------*/

#undef MDC

#undef GLOBAL_MESH_Name
#undef SUBDOMAIN_Name
#undef DOMAIN_INTEGRATION_Name
#undef SUB_NE
#undef DOI_NE

/***/
