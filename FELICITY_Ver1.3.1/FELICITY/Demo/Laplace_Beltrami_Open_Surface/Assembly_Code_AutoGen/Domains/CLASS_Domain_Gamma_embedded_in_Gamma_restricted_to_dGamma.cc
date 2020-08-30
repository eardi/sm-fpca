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
#define MDC        CLASS_Domain_Gamma_embedded_in_Gamma_restricted_to_dGamma
// set the name of the Global mesh (TopDim = 2)
#define GLOBAL_MESH_Name  "Gamma"
// set the name of the subdomain (TopDim = 2)
#define SUBDOMAIN_Name  "Gamma"
// set the name of the domain of integration (TopDim = 1)
#define DOMAIN_INTEGRATION_Name  "dGamma"

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

/*------------ BEGIN: Auto Generate ------------*/
/***************************************************************************************/
/* setup access to incoming MATLAB data that represents subdomain embedding */
void MDC::Setup_Data(const mxArray* Subdomain_Array, const mxArray* Global_Mesh_DoFmap, const mxArray* Sublist_Elem_Indices)  // inputs
{
    // retrieve the particular subdomain we need
    const unsigned int DOM_INDEX = Find_Subdomain_Array_Index(Subdomain_Array,"Gamma","Gamma","dGamma");
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

    if ( (Num_Elem > 0) && ( !((!Global_Cell_EMPTY) && (Sub_Cell_EMPTY) && (Sub_Entity_EMPTY) && (!DoI_Entity_EMPTY)) ) )
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

    size_t Num_Lists = 0; // init
    if (Sublist_Elem_Indices!=NULL)
        {
        // then we have a valid input
        Num_Lists = mxGetNumberOfElements(Sublist_Elem_Indices);
        if (Num_Lists > 0)
            {
            // check the struct
            const int mxName_state = mxGetFieldNumber(Sublist_Elem_Indices,"DoI_Name");
            const int mxElem_Ind_state = mxGetFieldNumber(Sublist_Elem_Indices,"Elem_Indices");
            if ( (mxName_state==-1) || (mxElem_Ind_state==-1) )
                {
                mexPrintf("ERROR: The sublist element index data from MATLAB does not have the correct format.\n");
                mexPrintf("ERROR: The struct should look like this:\n");
                mexPrintf("ERROR:            .DoI_Name (Domain of Integration)\n");
                mexPrintf("ERROR:            .Elem_Indices\n");
                mexPrintf("ERROR: (Note that .Elem_Indices indexes into the embedding data for the DoI.)\n");
                mexErrMsgTxt("ERROR: make sure you provide the correct data structure!");
                }
            }
        }

    int LIST_INDEX = -1; // init
    if (Num_Lists > 0)
        {
        // find the right list
        for (unsigned int index = 0; index < Num_Lists; index++)
            {
            // get the name of the sub-domain
            const mxArray* mxDoI_Name_Input = mxGetField(Sublist_Elem_Indices, (mwIndex)index, "DoI_Name");
            if (!mxIsEmpty(mxDoI_Name_Input))
                {
                mwSize DoI_len = mxGetNumberOfElements(mxDoI_Name_Input) + 1;
                char* DoI_in   = (char*) mxCalloc(DoI_len, sizeof(char));
                /* Copy the string data over... */
                if (mxGetString(mxDoI_Name_Input, DoI_in, DoI_len) != 0)
                    {
                    mexPrintf("The sublist of elements has a bad .DoI_Name field, i.e. it is not a string!\n");
                    mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Sublist string data.");
                    }
                const bool DoI_equal = (strcmp(DoI_Name,DoI_in)==0);
                mxFree(DoI_in);
                if (DoI_equal)
                    {
                    LIST_INDEX = index;
                    break;
                    }
                }
            else // the name is empty!
                {
                mexPrintf("The sublist of elements has a bad .DoI_Name field, i.e. it is empty!\n");
                mexErrMsgIdAndTxt("MATLAB:explore:invalidStringArray","Could not convert Sublist string data.");
                }
            }

        // if it was not found, then assume we assemble all elements
        if (LIST_INDEX < 0)
            {
            // output a message saying this...
            mexPrintf("-------------------------------------\n");
            mexPrintf("Matrix assembler could not find a sublist of elements for %s\n",DoI_Name);
            mexPrintf("       Therefore, matrix assembler will assemble *all* elements.\n");
            mexPrintf("-------------------------------------\n");
            }
        }

    // loop over a subset of the DoI
    if (LIST_INDEX >= 0)
        {
        // get the sub-list
        const mxArray* mxDoI_Sublist_Input = mxGetField(Sublist_Elem_Indices, (mwIndex)LIST_INDEX, "Elem_Indices");
        const unsigned int Sublist_Len = (unsigned int) mxGetNumberOfElements(mxDoI_Sublist_Input);
        // verify that the data is 32-bit unsigned int
        if ((mxGetClassID(mxDoI_Sublist_Input)!=mxUINT32_CLASS) && (!mxIsEmpty(mxDoI_Sublist_Input)))
            {
            mexPrintf("ERROR: Sublist index data for %s has incorrect type!\n",DoI_Name);
            mexPrintf("ERROR:      .Elem_Indices should be uint32.\n");
            mexErrMsgTxt("ERROR: use the MATLAB uint32() command!");
            }

        const unsigned int* Sublist_Ind = (const unsigned int*) mxGetPr(mxDoI_Sublist_Input);
        // check that nothing is out of range
        if (Sublist_Len > 0)
            {
            const unsigned int Max_DoI_Index = *std::max_element(Sublist_Ind, Sublist_Ind + Sublist_Len);
            const unsigned int Min_DoI_Index = *std::min_element(Sublist_Ind, Sublist_Ind + Sublist_Len);
            if ((Min_DoI_Index < 1) || (Max_DoI_Index > Num_Elem))
                {
                mexPrintf("ERROR: ---> There are problems with the sublist of indices for this:\n");
                mexPrintf("ERROR:      Domain of Integration: %s\n",DoI_Name);
                mexPrintf("ERROR: The sublist of element indices is outside [1, %d].\n",Num_Elem);
                mexPrintf("ERROR: Note that .Elem_Indices indexes into the embedding data,\n");
                mexPrintf("       i.e. .Elem_Indices are *not* global element indices.\n");
                mexErrMsgTxt("ERROR: Fix your .Elem_Indices OR use the correct mesh embedding data!");
                }

            // setup sub-list of elements to loop over in assembly
            Sub_Assem_List.reserve(Sublist_Len);
            for (unsigned int ii=0; ii < Sublist_Len; ++ii)
                Sub_Assem_List.push_back(Sublist_Ind[ii] - 1); // C-style indexing
            }
        else // the list is empty so do not assemble
            Sub_Assem_List.clear(); // make it empty
        }
    else // loop over entire DoI
        {
        // initialize list of elements to loop over in assembly
        Sub_Assem_List.reserve(Num_Elem);
        for (unsigned int ii=0; ii < Num_Elem; ++ii)
            Sub_Assem_List.push_back(ii); // C-style indexing
        if (Num_Elem==0) Sub_Assem_List.clear(); // make it empty
        }
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

    // error check:  make sure doi_elem_index is >= 0 and
    //               does not exceed the number of elements in the sub-domain
    if ( (doi_elem_index < 0) || (doi_elem_index >= Num_Elem) )
        {
        mexPrintf("ERROR: The number of elements (cells) in the sub-domain is %d.\n",Num_Elem);
        mexPrintf("ERROR: But the sub-domain cell index == %d.\n",doi_elem_index+1); // put into MATLAB style
        mexPrintf("ERROR: It *should* satisfy: 1 <= cell index <= %d.\n",Num_Elem);
        mexPrintf("\n");
        mexPrintf("Either the subdomain embedding data is wrong,\n");
        mexPrintf("    or you have passed incorrect cell indices to this code.\n");
        mexErrMsgTxt("STOP!");
        }

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
