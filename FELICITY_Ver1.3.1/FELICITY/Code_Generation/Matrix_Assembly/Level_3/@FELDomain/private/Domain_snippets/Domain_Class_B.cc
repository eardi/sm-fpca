
/* C++ (Specific) Domain class definition */
class MDC: public Abstract_DOMAIN_Class // derive from base class
{
public:
    MDC (); // constructor
    ~MDC ();   // DE-structor
    void Setup_Data(const mxArray*, const mxArray*, const mxArray*);
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

