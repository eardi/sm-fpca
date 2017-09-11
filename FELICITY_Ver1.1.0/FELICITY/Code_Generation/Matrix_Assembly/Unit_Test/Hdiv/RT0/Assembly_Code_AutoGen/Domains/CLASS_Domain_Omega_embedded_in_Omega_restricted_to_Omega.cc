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
#define MDC        CLASS_Domain_Omega_embedded_in_Omega_restricted_to_Omega
// set the name of the Global mesh (TopDim = 2)
#define GLOBAL_MESH_Name  "Omega"
// set the name of the subdomain (TopDim = 2)
#define SUBDOMAIN_Name  "Omega"
// set the name of the domain of integration (TopDim = 2)
#define DOMAIN_INTEGRATION_Name  "Omega"

// set the number of local entities in subdomain
#define SUB_NE  1
// set the number of local entities in domain of integration
#define DOI_NE  1
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
    // just get number of cells in the global mesh because: Global==Subdomain==DoI
    Num_Elem = (unsigned int) mxGetM(Global_Mesh_DoFmap);
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
    Global_Cell_Index = doi_elem_index; // the DoI must be the Global domain (already in C-style)
    Sub_Cell_Index = doi_elem_index; // Global==Subdomain==DoI (already in C-style)
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
