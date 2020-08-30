/*
============================================================================================
   Abstract base class for simple (mesh) subdomain access of embedding information.

   Copyright (c) 06-20-2012,  Shawn W. Walker
============================================================================================
*/

/*
Notes about the Domain class and how embedded domains are captured.

Remark: Suppose the Domain of Integation (DoI) consists of one element.
Multiple elements are handled by a for loop (i.e. assembly loop).

Global Cell Index: refers to a particular ``cell'' in the Global mesh.  From
this cell, we can reconstruct the local geometry of the Subdomain from the
information described below.

Subdomain Cell Index: refers to the ``local'' cell index of the Subdomain.
For example, a subdomain always consists of a collection of cells, though
these cells may be of lower topological dimension than the Global cells.
Anyway, we always need to know what the local cell index is of the Subdomain.
This is useful when a function is defined on the Subdomain, but we want to
evaluate it on the Domain of Integration (DoI; see below).

Subdomain Entity Index: refers to the local topological entity (with respect
to the Global Cell) that the Subdomain is represented by.  For example, if the
Global mesh consists of tetrahedra, and the Subdomain is a surface embedded in
a set of faces in the tetrahedra, then

         Subdomain Entity Index = +/- 1,2,3,4,

where the index is the local face number of the tetrahedron referenced by
Global Cell Index.  The sign gives the orientation.

DoI Entity Index: refers to the local topological entity (with respect
to the *Subdomain Cell*) that the *DoI is represented by*. Otherwise, similar
to Subdomain Entity Index.

Remarks: All of the above data structures are column vectors of the same
length, where each row corresponds to one element of the DoI.

Remarks: The Global and Subdomain Cell Indices are always needed.  You only
need the Subdomain Entity Index if the topological dimensions of the Global
mesh and the Subdomain are different.  Likewise, you only need the DoI Entity
Index when the topological dimensions of the Subdomain and the DoI differ.

Note: this implies that the only time when you need all indices, is when the
Global mesh is 3-D, the Subdomain is 2-D, and the DoI is 1-D.

This table shows when the different indices are used.
TD = Topological Dimension, Y = used, N = not used.
+--------+-----+-----+-------------+----------+------------+------------+
| Global | Sub | DoI | Global Cell | Sub Cell | Sub Entity | DoI Entity |
|  TD    | TD  | TD  | Index       | Index    | Index      | Index      |
+--------+-----+-----+-------------+----------+------------+------------+
|   1    |  1  |  1  |      Y      |     Y    |      N     |     N      |
|   2    |  2  |  2  |      Y      |     Y    |      N     |     N      |
|   2    |  2  |  1  |      Y      |     Y    |      N     |     Y      |
|   2    |  1  |  1  |      Y      |     Y    |      Y     |     N      |
|   3    |  3  |  3  |      Y      |     Y    |      N     |     N      |
|   3    |  3  |  2  |      Y      |     Y    |      N     |     Y      |
|   3    |  3  |  1  |      Y      |     Y    |      N     |     Y      |
|   3    |  2  |  2  |      Y      |     Y    |      Y     |     N      |
|   3    |  2  |  1  |      Y      |     Y    |      Y     |     Y      |
|   3    |  1  |  1  |      Y      |     Y    |      Y     |     N      |
+--------+-----+-----+-------------+----------+------------+------------+

The struct in MATLAB that contains the Subdomain Embedding info looks like this:

Embed.Global_Name             = Name of the Global Mesh;
Embed.Subdomain_Name          = Name of the Subdomain;
Embed.Integration_Domain_Name = Name of the DoI;

Embed.Global_Cell_Index      = column vector containing Global Mesh cell indices;
Embed.Subdomain_Cell_Index   = ... Subdomain cell indices;
Embed.Subdomain_Entity_Index = ... Subdomain *entity* indices;
Embed.Integration_Domain_Entity_Index = ... DoI *entity* indices;
*/

#include <vector>

/***************************************************************************************/
// a struct for holding the mxArray pointers described in the next struct (see below).
typedef struct
{
    const mxArray*  mxGlobal_Cell;
    const mxArray*  mxSub_Cell;
    const mxArray*  mxSub_Entity;
    const mxArray*  mxDoI_Entity;
}
mxDOMAIN_EMBEDDING_DATA;

/***************************************************************************************/
/* a struct for holding pointers to the subdomain embedding data
   note: the four arrays in this struct all have the same length. */
typedef struct
{
    const int*   Global_Cell_Index; // array of indices to "bulk" global mesh elements
    const int*      Sub_Cell_Index; // array of indices to "bulk" subdomain elements

    // array of indices indicating local mesh entity of co-dim > 0.
    const int*    Sub_Entity_Index; // i.e. the index of the local topological entity
                                    // (e.g. local edge #3)
    const int*    DoI_Entity_Index; // topological entity indices for Domain of Integration (DoI)
}
DOMAIN_EMBEDDING_DATA;

/*** C++ (base) class ***/
class Abstract_DOMAIN_Class
{
public:
    Abstract_DOMAIN_Class (); // constructor
    virtual ~Abstract_DOMAIN_Class (); // DE-structor (it MUST be virtual!)
    unsigned int Get_Num_Elem() { return  Num_Elem; }
    virtual void Setup_Data(const mxArray*, const mxArray*, const mxArray*)=0;
    void Verify_MATLAB_Struct(const mxArray*);
    unsigned int Find_Subdomain_Array_Index(const mxArray*, const char*, const char*, const char*);
    void Parse_mxSubdomain(const mxArray*, const unsigned int&, mxDOMAIN_EMBEDDING_DATA&);
    void Parse_Subdomain(const mxArray*, const mxDOMAIN_EMBEDDING_DATA&, DOMAIN_EMBEDDING_DATA&);
    void Error_Check_Sub_Entity_Indices(DOMAIN_EMBEDDING_DATA&);
    void Error_Check_DoI_Entity_Indices(DOMAIN_EMBEDDING_DATA&);

    // current domain element info
    int   Global_Cell_Index;
    int   Sub_Cell_Index;
    int   Sub_Entity_Index;
    int   DoI_Entity_Index;

    std::vector<unsigned int> Sub_Assem_List; // list of elements to actually loop over in the DoI in the sub-domain

protected:
    char*    Global_Name;       // name of the Global mesh represents (e.g. "Global")
    char*    Sub_Name;          // name of the Subdomain embedded in the Global mesh (e.g. "Gamma")
    char*    DoI_Name;          // name of the Domain of Integration (DoI) that the subdomain is restricted to (e.g. "Boundary")
    unsigned int  Num_Elem;          // number of elements (cells) in the DoI in the sub-domain
    unsigned int  Num_Sub_Entity;    // number of local mesh entities in the corresponding Global cell
                                     // e.g. a Global triangle has 3 edge entities
    unsigned int  Num_DoI_Entity;    // number of local entities in the DoI contained in the Subdomain cell

    mxDOMAIN_EMBEDDING_DATA  mxData;
    DOMAIN_EMBEDDING_DATA      Data;
};

/***************************************************************************************/
/* constructor */
Abstract_DOMAIN_Class::Abstract_DOMAIN_Class ()
{
    Global_Name     = NULL;
    Sub_Name        = NULL;
    DoI_Name        = NULL;
    Num_Elem        = 0;
    Num_Sub_Entity  = 0;
    Num_DoI_Entity  = 0;

    mxData.mxGlobal_Cell  = NULL;
    mxData.mxSub_Cell     = NULL;
    mxData.mxSub_Entity   = NULL;
    mxData.mxDoI_Entity   = NULL;

    Data.Global_Cell_Index  = NULL;
    Data.Sub_Cell_Index     = NULL;
    Data.Sub_Entity_Index   = NULL;
    Data.DoI_Entity_Index   = NULL;

    Global_Cell_Index  = -1; // invalid
    Sub_Cell_Index     = -1; // invalid
    Sub_Entity_Index   = -1; // invalid
    DoI_Entity_Index   = -1; // invalid

    Sub_Assem_List.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
Abstract_DOMAIN_Class::~Abstract_DOMAIN_Class ()
{
    Sub_Assem_List.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* performs some basic error checking on the MATLAB struct fields */
void Abstract_DOMAIN_Class::Verify_MATLAB_Struct(const mxArray*  Subdomain_Array)
{
	/* error check: verify that the data struct has the correct format */
	const int mxGlobal_Input_state = mxGetFieldNumber(Subdomain_Array,"Global_Name");
	const int mxSub_Input_state    = mxGetFieldNumber(Subdomain_Array,"Subdomain_Name");
	const int mxDoI_Input_state    = mxGetFieldNumber(Subdomain_Array,"Integration_Domain_Name");
	const int mxGlobal_Cell_state  = mxGetFieldNumber(Subdomain_Array,"Global_Cell_Index");
	const int mxSub_Cell_state     = mxGetFieldNumber(Subdomain_Array,"Subdomain_Cell_Index");
	const int mxSub_Entity_state   = mxGetFieldNumber(Subdomain_Array,"Subdomain_Entity_Index");
	const int mxDoI_Entity_state   = mxGetFieldNumber(Subdomain_Array,"Integration_Domain_Entity_Index");
    const bool INVALID = ( (mxGlobal_Input_state==-1) || (mxSub_Input_state==-1)   ||
	                       (mxDoI_Input_state==-1)    || (mxGlobal_Cell_state==-1) ||
						   (mxSub_Cell_state==-1)     || (mxSub_Entity_state==-1)  ||
						   (mxDoI_Entity_state==-1) );
	if (INVALID)
        {
        mexPrintf("ERROR: The subdomain embedding data from MATLAB does not have the correct format.\n");
		mexPrintf("ERROR: The struct should look like this:\n");
		mexPrintf("ERROR:            .Global_Name\n");
		mexPrintf("ERROR:            .Subdomain_Name\n");
		mexPrintf("ERROR:            .Integration_Domain_Name\n");
		mexPrintf("ERROR:            .Global_Cell_Index\n");
		mexPrintf("ERROR:            .Subdomain_Cell_Index\n");
		mexPrintf("ERROR:            .Subdomain_Entity_Index\n");
		mexPrintf("ERROR:            .Integration_Domain_Entity_Index\n");
		mexPrintf("ERROR:\n");
        mexErrMsgTxt("ERROR: make sure you provide the correct embedding data structure!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* given an array of possible subdomains, this returns the index of the one that
   matches the given strings */
unsigned int Abstract_DOMAIN_Class::Find_Subdomain_Array_Index(
                      const mxArray* Subdomain_Array,                                       // inputs
                      const char* Global_Name, const char* Sub_Name, const char* DoI_Name)  // inputs
{
    int ARRAY_INDEX = -1; // init
	Verify_MATLAB_Struct(Subdomain_Array);

    const size_t Num_Subdomains = mxGetNumberOfElements(Subdomain_Array);
	// determine which index of the subdomain array is the one we want
    for (unsigned int index = 0; index < Num_Subdomains; index++)
        {
        // point to the MATLAB data
        const mxArray* mxGlobal_Input = mxGetFieldByNumber(Subdomain_Array,(mwIndex)index,
                                        mxGetFieldNumber(Subdomain_Array,"Global_Name"));
        const mxArray* mxSub_Input    = mxGetFieldByNumber(Subdomain_Array,(mwIndex)index,
                                        mxGetFieldNumber(Subdomain_Array,"Subdomain_Name"));
        const mxArray* mxDoI_Input    = mxGetFieldByNumber(Subdomain_Array,(mwIndex)index,
                                        mxGetFieldNumber(Subdomain_Array,"Integration_Domain_Name"));

        // if they match, then return this index!
        mwSize global_len = mxGetNumberOfElements(mxGlobal_Input) + 1;
        mwSize sub_len    = mxGetNumberOfElements(mxSub_Input) + 1;
        mwSize doi_len    = mxGetNumberOfElements(mxDoI_Input) + 1;
        char* global_in   = (char*) mxCalloc(global_len, sizeof(char));
        char* sub_in      = (char*) mxCalloc(sub_len, sizeof(char));
        char* doi_in      = (char*) mxCalloc(doi_len, sizeof(char));
        /* Copy the string data over... */
        if (mxGetString(mxGlobal_Input, global_in, global_len) != 0)
            mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Subdomain string data.");
        if (mxGetString(mxSub_Input, sub_in, sub_len) != 0)
            mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Subdomain string data.");
        if (mxGetString(mxDoI_Input, doi_in, doi_len) != 0)
            mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Subdomain string data.");
        const bool global_equal = (strcmp(Global_Name,global_in)==0);
        const bool sub_equal    = (strcmp(Sub_Name,sub_in)==0);
        const bool doi_equal    = (strcmp(DoI_Name,doi_in)==0);
        mxFree(global_in);
        mxFree(sub_in);
        mxFree(doi_in);
        if (global_equal && sub_equal && doi_equal)
            {
            ARRAY_INDEX = index;
            break;
            }
        }
    // if it wasn't found, then output an error message
    if (ARRAY_INDEX < 0)
        {
		mexPrintf("==============================================================================================\n");
        mexPrintf("ERROR: The following subdomain embedding data could not be found:\n");
        mexPrintf("ERROR:         Global Domain: %s\n",Global_Name);
        mexPrintf("ERROR:             Subdomain: %s\n",Sub_Name);
        mexPrintf("ERROR: Domain of Integration: %s\n",DoI_Name);
		mexPrintf("\n");
		mexPrintf("There are four possible reasons for this error message:\n");
		mexPrintf("(1) The subdomain embedding data was not created with the built-in command.\n");
		mexPrintf("(2) You did not *name* your subdomains correctly.\n");
		mexPrintf("        Note: make sure your Global mesh is called %s.\n",Global_Name);
		mexPrintf("(3) You did not define the subdomains of your Global mesh correctly.\n");
		mexPrintf("(4) You made an error when you defined your forms (i.e. review your script file).\n");
		mexPrintf("\n");
		mexPrintf("Example: You may have defined a form involving spaces defined over %s,\n",Sub_Name);
		mexPrintf("         and integrated over %s.\n",DoI_Name);
		mexPrintf("         But %s is not a subset of %s.\n",DoI_Name,Sub_Name);
		mexPrintf("         Thus, you either made error #3 or #4.\n");
		mexPrintf("\n");
		mexPrintf("Check your code!\n");
		mexPrintf("==============================================================================================\n");
        mexErrMsgTxt("ERROR: make sure you provide the correct embedding data, and define your subdomains and forms correctly!\n");
        }
    return (unsigned int) ARRAY_INDEX;
}
/***************************************************************************************/


/***************************************************************************************/
/* parse the (mx data) subdomain data into useful struct */
void Abstract_DOMAIN_Class::Parse_mxSubdomain(const mxArray* Subdomain_Array,      // inputs
                                              const unsigned int& Subdomain_Index, // inputs
                                              mxDOMAIN_EMBEDDING_DATA&  mx_Embed)  // outputs
{
    // determine which index of the subdomain array is the one we want
    mx_Embed.mxGlobal_Cell = mxGetFieldByNumber(Subdomain_Array,(mwIndex)Subdomain_Index,
                             mxGetFieldNumber(Subdomain_Array,"Global_Cell_Index"));
    mx_Embed.mxSub_Cell    = mxGetFieldByNumber(Subdomain_Array,(mwIndex)Subdomain_Index,
                             mxGetFieldNumber(Subdomain_Array,"Subdomain_Cell_Index"));
    mx_Embed.mxSub_Entity  = mxGetFieldByNumber(Subdomain_Array,(mwIndex)Subdomain_Index,
                             mxGetFieldNumber(Subdomain_Array,"Subdomain_Entity_Index"));
    mx_Embed.mxDoI_Entity  = mxGetFieldByNumber(Subdomain_Array,(mwIndex)Subdomain_Index,
                             mxGetFieldNumber(Subdomain_Array,"Integration_Domain_Entity_Index"));
    const bool Global_Cell_EMPTY = mxIsEmpty(mx_Embed.mxGlobal_Cell);
    const bool Sub_Cell_EMPTY    = mxIsEmpty(mx_Embed.mxSub_Cell);
    const bool Sub_Entity_EMPTY  = mxIsEmpty(mx_Embed.mxSub_Entity);
    const bool DoI_Entity_EMPTY  = mxIsEmpty(mx_Embed.mxDoI_Entity);
    if ((Global_Cell_EMPTY) && (!Sub_Cell_EMPTY))
        {
        mexPrintf("ERROR: A subdomain does not have consistent embedding data!\n");
        mexPrintf("ERROR: The problem is with Subdomain number %d.\n",Subdomain_Index+1);
        mexPrintf("ERROR: You cannot have empty *Global Cell* Index Data and non-empty *Subdomain Cell*!\n");
        mexErrMsgTxt("ERROR: make sure you provide the correct embedding data!");
        }
    // check number of elements!
    const unsigned int GLOBAL_Num_Elem = (unsigned int) mxGetM(mx_Embed.mxGlobal_Cell);
    const unsigned int SUB_Num_Elem    = (unsigned int) mxGetM(mx_Embed.mxSub_Cell);
    if ((GLOBAL_Num_Elem!=SUB_Num_Elem) && (!Global_Cell_EMPTY) && (!Sub_Cell_EMPTY))
        {
        mexPrintf("ERROR: A subdomain does not have consistent embedding data!\n");
        mexPrintf("ERROR: The problem is with Subdomain number %d.\n",Subdomain_Index+1);
        mexPrintf("ERROR: Cell Index Data should be column vectors of equal length!\n");
        mexErrMsgTxt("ERROR: make sure you provide the correct embedding data!");
        }

    // verify that the data is 32-bit int
    if ((mxGetClassID(mx_Embed.mxGlobal_Cell)!=mxINT32_CLASS) && (!Global_Cell_EMPTY))
        {
        mexPrintf("ERROR: Subdomain data has incorrect type!\n");
        mexPrintf("ERROR: The problem is with Subdomain number %d.\n",Subdomain_Index+1);
        mexErrMsgTxt("ERROR: Subdomain *Global Cell* data must be int32!");
        }
    if ((mxGetClassID(mx_Embed.mxSub_Cell)!=mxINT32_CLASS) && (!Sub_Cell_EMPTY))
        {
        mexPrintf("ERROR: Subdomain data has incorrect type!\n");
        mexPrintf("ERROR: The problem is with Subdomain number %d.\n",Subdomain_Index+1);
        mexErrMsgTxt("ERROR: *Subdomain Cell* data must be int32!");
        }
    if ((mxGetClassID(mx_Embed.mxSub_Entity)!=mxINT32_CLASS) && (!Sub_Entity_EMPTY))
        {
        mexPrintf("ERROR: Subdomain data has incorrect type!\n");
        mexPrintf("ERROR: The problem is with Subdomain number %d.\n",Subdomain_Index+1);
        mexErrMsgTxt("ERROR: *Subdomain Entity* data must be int32!");
        }
    if ((mxGetClassID(mx_Embed.mxDoI_Entity)!=mxINT32_CLASS) && (!DoI_Entity_EMPTY))
        {
        mexPrintf("ERROR: Subdomain data has incorrect type!\n");
        mexPrintf("ERROR: The problem is with Subdomain number %d.\n",Subdomain_Index+1);
        mexErrMsgTxt("ERROR: *Integration_Domain Entity* data must be int32!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* parse the subdomain data into useful struct */
void Abstract_DOMAIN_Class::Parse_Subdomain(const mxArray*        Global_Mesh_DoFmap,  // inputs
                                            const mxDOMAIN_EMBEDDING_DATA&  mx_Embed,  // inputs
                                                    DOMAIN_EMBEDDING_DATA&     Embed)  // outputs
{
    // get pointers to the actual data
    Embed.Global_Cell_Index = (const int*) mxGetPr(mx_Embed.mxGlobal_Cell);
    Embed.Sub_Cell_Index    = (const int*) mxGetPr(mx_Embed.mxSub_Cell);
    Embed.Sub_Entity_Index  = (const int*) mxGetPr(mx_Embed.mxSub_Entity);
    Embed.DoI_Entity_Index  = (const int*) mxGetPr(mx_Embed.mxDoI_Entity);

    if (Num_Elem==0)
        {
        // then there is no need to do anything else
        return;
        }

    /* check that the cell indices are valid for the given mesh */
    // get number of *global* mesh elements
    const int Num_Global_Mesh_Cells = (int) mxGetM(Global_Mesh_DoFmap);

    // get max and min *global* mesh element indices in subdomain data
    const int Max_Global_Cell_Index = *std::max_element(Embed.Global_Cell_Index, Embed.Global_Cell_Index + Num_Elem);
    const int Min_Global_Cell_Index = *std::min_element(Embed.Global_Cell_Index, Embed.Global_Cell_Index + Num_Elem);
    if ((Min_Global_Cell_Index < 1) || (Max_Global_Cell_Index > Num_Global_Mesh_Cells))
        {
        mexPrintf("ERROR: ---> There are problems with this Subdomain:\n");
        mexPrintf("ERROR:         Global Domain: %s\n",Global_Name);
        mexPrintf("ERROR:             Subdomain: %s\n",Sub_Name);
        mexPrintf("ERROR: Domain of Integration: %s\n",DoI_Name);
        mexPrintf("ERROR: The Domain of Integration references Global mesh element indices outside [1, %%d].\\n",Num_Global_Mesh_Cells);
        mexErrMsgTxt("ERROR: Fix your Global Cell indexing OR use the correct global mesh data!");
        }
    if (!mxIsEmpty(mx_Embed.mxSub_Cell)) // if subdomain cell data not empty
        {
        //const int Max_Sub_Cell_Index = *std::max_element(Embed.Sub_Cell_Index, Embed.Sub_Cell_Index + Num_Elem);
        const int Min_Sub_Cell_Index = *std::min_element(Embed.Sub_Cell_Index, Embed.Sub_Cell_Index + Num_Elem);
        if (Min_Sub_Cell_Index < 1)// || (Max_Sub_Cell_Index > Num_Global_Mesh_Cells))
            {
            mexPrintf("ERROR: ---> There are problems with this Subdomain:\n");
            mexPrintf("ERROR:         Global Domain: %s\n",Global_Name);
            mexPrintf("ERROR:             Subdomain: %s\n",Sub_Name);
            mexPrintf("ERROR: Domain of Integration: %s\n",DoI_Name);
            mexPrintf("ERROR: The Domain of Integration references Subdomain element indices < 1!\n");
            mexErrMsgTxt("ERROR: Fix your Subdomain Cell indexing OR use the correct global mesh data!");
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* performs some basic error checking on the entity indices */
void Abstract_DOMAIN_Class::Error_Check_Sub_Entity_Indices(DOMAIN_EMBEDDING_DATA&   Embed)   // inputs
{
    if (Num_Elem > 0)
        {
        // get max and min local entity index for the Subdomain topological entity indices
        const int Max_Entity = *std::max_element(Embed.Sub_Entity_Index, Embed.Sub_Entity_Index + Num_Elem);
        const int Min_Entity = *std::min_element(Embed.Sub_Entity_Index, Embed.Sub_Entity_Index + Num_Elem);

        if ((Min_Entity < -((int) Num_Sub_Entity)) || (Max_Entity > (int) Num_Sub_Entity))
            {
            mexPrintf("ERROR: ---> There are problems with this Subdomain:\n");
            mexPrintf("ERROR:         Global Domain: %s\n",Global_Name);
            mexPrintf("ERROR:             Subdomain: %s\n",Sub_Name);
            mexPrintf("ERROR: Domain of Integration: %s\n",DoI_Name);
            mexPrintf("ERROR: There are Subdomain local mesh entity indices that are outside [-%d, +%d].\n",Num_Sub_Entity,Num_Sub_Entity);
            mexErrMsgTxt("ERROR: Fix your Subdomain entity indexing!");
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* performs some basic error checking on the entity indices */
void Abstract_DOMAIN_Class::Error_Check_DoI_Entity_Indices(DOMAIN_EMBEDDING_DATA&   Embed)   // inputs
{
    if (Num_Elem > 0)
        {
        // get max and min local entity index for the DoI topological entity indices
        const int Max_Entity = *std::max_element(Embed.DoI_Entity_Index, Embed.DoI_Entity_Index + Num_Elem);
        const int Min_Entity = *std::min_element(Embed.DoI_Entity_Index, Embed.DoI_Entity_Index + Num_Elem);

        if ((Min_Entity < -((int) Num_DoI_Entity)) || (Max_Entity > (int) Num_DoI_Entity))
            {
            mexPrintf("ERROR: ---> There are problems with this Subdomain:\n");
            mexPrintf("ERROR:         Global Domain: %s\n",Global_Name);
            mexPrintf("ERROR:             Subdomain: %s\n",Sub_Name);
            mexPrintf("ERROR: Domain of Integration: %s\n",DoI_Name);
            mexPrintf("ERROR: There are Integration Domain local mesh entity indices that are outside [-%d, +%d].\n",Num_DoI_Entity,Num_DoI_Entity);
            mexErrMsgTxt("ERROR: Fix your Integration Domain entity indexing!");
            }
        }
}
/***************************************************************************************/

/***/
