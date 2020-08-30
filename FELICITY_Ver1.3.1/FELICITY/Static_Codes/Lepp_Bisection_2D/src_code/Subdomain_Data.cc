/*
============================================================================================
   This class accesses mesh sub-domain data.  It is used as a sub-object in Triangle_Mesh.cc
   It also adjusts the sub-domain mesh embedding data whenever a cell (triangle) is
   bisected.

   Copyright (c) 09-12-2011,  Shawn W. Walker
============================================================================================
*/

#include <map>
#include <stack>

/* C++ Subdomain Data class definition */
#define SBD   Subdomain_Data
class SBD
{
public:
    SBD (); // constructor
    ~SBD ();   // DE-structor
    const char*  Get_Name ()          { return Name; }
    unsigned int Get_TopDim ()        { return TopDim; }
    unsigned int Get_Num_Cols ()      { return Num_Cols; }

    void Setup_Data(const char*, const unsigned int&, const mxArray*, const unsigned int&);
    void Adjust_Subdomain(const unsigned int&, const unsigned int&, const unsigned int&);
    mxArray* Copy_Final_Data();

    // sub-domain data (topological entity info)
    // the MATLAB data can have either 1 or 2 columns, so we might not use the full pair.
    std::multimap<unsigned int,int> Entity_map;

private:
    const char*   Name;              // identifier for the data
    unsigned int  TopDim;            // topological dimension
    unsigned int  Num_Cols;          // actual number of columns
    // routines for adjusting how a sub-domain references the mesh after a triangle is bisected
    void Adjust_Subdomain_0D(std::multimap<unsigned int,int>::iterator, const unsigned int&, const unsigned int&,
                             const unsigned int&, std::stack<std::pair<unsigned int,int> >&);
    void Adjust_Subdomain_1D(std::multimap<unsigned int,int>::iterator, const unsigned int&, const unsigned int&,
                             const unsigned int&, std::stack<std::pair<unsigned int,int> >&);
    void Adjust_Subdomain_2D(const unsigned int&);
};

/***************************************************************************************/
/* constructor */
SBD::SBD ()
{
    // init data information to NULL
    Name     = NULL;
    TopDim   = 0;
    Num_Cols = 0;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
SBD::~SBD ()
{
    Entity_map.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming data from MATLAB into a nice struct */
void SBD::Setup_Data(const char* Name_input, const unsigned int& Data_Top_Dim,   // inputs
                     const mxArray* mxData,  const unsigned int& Max_Cell_Index) // inputs
{
    // store the name and topological dimension
    Name   = Name_input;
    TopDim = Data_Top_Dim;

    // get the number of rows and cols
    unsigned int Num_Rows = (unsigned int) mxGetM(mxData);
    Num_Cols = (unsigned int) mxGetN(mxData);


    /* BEGIN: Simple Error Checking */
    if (mxGetClassID(mxData)!=mxINT32_CLASS) mexErrMsgTxt("ERROR: Data must be of type int32!");
    if (Num_Cols > 2)
        {
        mexPrintf("ERROR: Subdomain data has %d columns; cannot have more than %d columns.\n", Num_Cols, 2);
        mexErrMsgTxt("ERROR: fix your Data!");
        }
    /* END: Simple Error Checking */


    // access the columns of the subdomain data
    const int* Data[2];
    Data[0] = (const int*) mxGetPr(mxData);
    for (unsigned int i = 1; (i < Num_Cols); i++)
        Data[i] = Data[i-1] + Num_Rows;

    // fill the map (efficiently)
    std::multimap<unsigned int,int>::iterator it;
    if (Num_Cols==2)
        {
        it = Entity_map.insert ( std::pair<unsigned int,int>(Data[0][0],Data[1][0]) );
        for (unsigned int i = 1; (i < Num_Rows); i++)
            {
            it++;
            Entity_map.insert (it, std::pair<unsigned int,int>(Data[0][i],Data[1][i]));
            }
        }
    else // it is just 1 column
        {
        it = Entity_map.insert ( std::pair<unsigned int,int>(Data[0][0],0) );
        for (unsigned int i = 1; (i < Num_Rows); i++)
            {
            it++;
            Entity_map.insert (it, std::pair<unsigned int,int>(Data[0][i],0));
            }
        }

    /* more error checking */
    // make sure subdomain cell indices are allowable
    it=Entity_map.begin();
    if ((*it).first < 1)
        {
        mexPrintf("ERROR: The subdomain data must reference a cell with positive index!\n");
        mexPrintf("       Instead, it referenced this %d.\n",(*it).first);
        mexPrintf("       There is a problem with this subdomain data: %s\n",Name);
        mexErrMsgTxt("ERROR: Fix your Subdomain.Data array!");
        }
    it=Entity_map.end();
    it--;
    if ((*it).first > (int) Max_Cell_Index)
        {
        mexPrintf("ERROR: The subdomain data must reference a cell with valid index!\n");
        mexPrintf("       Instead, it referenced this %d.\n",(*it).first);
        mexPrintf("       This is not allowed because there are only %d cells in the initial mesh.\n",Max_Cell_Index);
        mexPrintf("       There is a problem with this subdomain data: %s\n",Name);
        mexErrMsgTxt("ERROR: Fix your Subdomain.Data array!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* adjust the subdomain data (if the enclosing cell was bisected) */
void SBD::Adjust_Subdomain(const unsigned int& t0, const unsigned int& s0, // inputs
                           const unsigned int& e0)  // inputs
{
    // get range of sub-domain entities that are embedded in t0
    std::multimap<unsigned int,int>::iterator it;
    std::pair<std::multimap<unsigned int,int>::iterator,std::multimap<unsigned int,int>::iterator> ret;

    ret = Entity_map.equal_range(t0); // get range of subdomain entities that reference t0

    if (ret.first!=ret.second) // if there are some, then they need to be adjusted...
        {
        if (TopDim==2) // a single triangle can only appear once in a sub-domain
            Adjust_Subdomain_2D(s0);
        else
            {
            // NOTE: you cannot erase or add elements to the multimap while you are traversing it!
            //       otherwise you will mess things up!
            std::stack< std::pair<unsigned int,int> > replace;

            // so read things into the convenient data structure ``replace''
            if (TopDim==0)
                for (it = ret.first; it!=ret.second; it++)
                    Adjust_Subdomain_0D(it, t0, s0, e0, replace);
            else if (TopDim==1)
                for (it = ret.first; it!=ret.second; it++)
                    Adjust_Subdomain_1D(it, t0, s0, e0, replace);
            else
                mexErrMsgTxt("ERROR: Fix your Subdomain.Data array!  You should not be here!");

            // erase the old subdomain embeddings
            Entity_map.erase(ret.first, ret.second);

            // replace with *new* subdomain embeddings...

            // if the map is empty, then we can just insert the first replacement
            if (Entity_map.empty())
                {
                Entity_map.insert(replace.top());
                replace.pop();
                }
            // now we know the map is NOT empty

            // access elements at the end
            std::multimap<unsigned int,int>::iterator THE_END = (Entity_map.end())--;
            while (!replace.empty())
                {
                // insert at the end
                THE_END = Entity_map.insert(THE_END, replace.top());
                replace.pop();
                }
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* adjust for the 0-D case;
   See the ``Bisection_Diagram.pdf'' in ./src_code/Figures/   sub-dir. */
void SBD::Adjust_Subdomain_0D(std::multimap<unsigned int,int>::iterator it,       // inputs
                              const unsigned int& t0, const unsigned int& s0,     // inputs
                              const unsigned int& e0,                             // inputs
                              std::stack< std::pair<unsigned int,int> >& replace) // inputs
{
    const int V_sub = (*it).second; // local  index (1,2,3) of sub-domain vertex
                                    // (relative to enclosing cell)

    // store how the local vertex indices get shifted in my bisection procedure
    const int Old_to_New_Local_Vtx_Index_edge0[3] = {3, 1, 2};
    const int Old_to_New_Local_Vtx_Index_edge1[3] = {2, 3, 1};
    const int Old_to_New_Local_Vtx_Index_edge2[3] = {1, 2, 3};

    int New_Local_Vtx = 0;
    if (e0==0) // longest edge has local index = 0
        New_Local_Vtx = Old_to_New_Local_Vtx_Index_edge0[V_sub-1];
    else if (e0==1)
        New_Local_Vtx = Old_to_New_Local_Vtx_Index_edge1[V_sub-1];
    else
        New_Local_Vtx = Old_to_New_Local_Vtx_Index_edge2[V_sub-1];

    // change sub-domain embedding appropriately
    if (New_Local_Vtx==1) // the vertex is stored as local vertex 3, with respect to newly created triangle index
        replace.push(std::pair<unsigned int,int>(s0,3));
    else // the vertex is stored as local vertex 2 or 3, with respect to original triangle index
        replace.push(std::pair<unsigned int,int>(t0,New_Local_Vtx));
}
/***************************************************************************************/


/***************************************************************************************/
/* adjust for the 1-D case;
   See the ``Bisection_Diagram.pdf'' in ./src_code/Figures/   sub-dir. */
int mySIGN(const int& VALUE)
{
    if (VALUE < 0)
        return -1;
    else
        return 1;
}
void SBD::Adjust_Subdomain_1D(std::multimap<unsigned int,int>::iterator it,       // inputs
                              const unsigned int& t0, const unsigned int& s0,     // inputs
                              const unsigned int& e0,                             // inputs
                              std::stack< std::pair<unsigned int,int> >& replace) // inputs
{
    const int E_sub = abs((*it).second); // local  index +/-(1,2,3) of sub-domain edge
                                         // (relative to enclosing cell)
    const int E_orientation = mySIGN((*it).second);

    // store how the local edge indices get shifted in my bisection procedure
    const int Old_to_New_Local_Edge_Index_edge0[3] = {3, 1, 2};
    const int Old_to_New_Local_Edge_Index_edge1[3] = {2, 3, 1};
    const int Old_to_New_Local_Edge_Index_edge2[3] = {1, 2, 3};

    int New_Local_Edge = 0;
    if (e0==0) // longest edge has local index = 0
        New_Local_Edge = Old_to_New_Local_Edge_Index_edge0[E_sub-1];
    else if (e0==1)
        New_Local_Edge = Old_to_New_Local_Edge_Index_edge1[E_sub-1];
    else
        New_Local_Edge = Old_to_New_Local_Edge_Index_edge2[E_sub-1];

    // change sub-domain embedding appropriately
    if (New_Local_Edge==1) // the edge is stored as local edge +/-1, with respect to original triangle index
        replace.push(std::pair<unsigned int,int>(t0,E_orientation*1));
    else if (New_Local_Edge==2) // the edge is stored as local edge +/-1, with respect to newly created triangle index
        replace.push(std::pair<unsigned int,int>(s0,E_orientation*1));
    else // here the local subdomain edge got bisected!
        {
        // first edge is stored as local edge +/-3, with respect to original triangle index
        replace.push(std::pair<unsigned int,int>(t0,E_orientation*3));
        // second edge is stored as local edge +/-2, with respect to newly created triangle index
        replace.push(std::pair<unsigned int,int>(s0,E_orientation*2));
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* adjust for the 2-D case: this is the easy case! */
void SBD::Adjust_Subdomain_2D(const unsigned int& s0) // inputs
{
    std::multimap<unsigned int,int>::iterator THE_END = (Entity_map.end())--;
    Entity_map.insert(THE_END, std::pair<unsigned int,int>(s0,0)); // insert at the end
}
/***************************************************************************************/


/***************************************************************************************/
/* copy data over to a self-contained MATLAB matrix */
mxArray* SBD::Copy_Final_Data()
{
    mxArray* mxOutput_Data = NULL;
    const unsigned int Num_Rows = (unsigned int) Entity_map.size();
    mxOutput_Data = mxCreateNumericMatrix((mwSize) Num_Rows, (mwSize) Num_Cols,
                                           mxINT32_CLASS, mxREAL);
    int* Output_Data[2];
    Output_Data[0] = (int*) mxGetPr(mxOutput_Data);
    for (unsigned int j = 1; (j < Num_Cols); j++)
        Output_Data[j] = Output_Data[j-1] + Num_Rows;

    // copy the data over
    std::multimap<unsigned int,int>::iterator it;
    unsigned int ROW_INDEX = 0; // init
    if (Num_Cols==2)
        {
        for (it = Entity_map.begin(); it != Entity_map.end(); it++)
            {
            Output_Data[0][ROW_INDEX] = (int) (*it).first;
            Output_Data[1][ROW_INDEX] = (*it).second;
            ROW_INDEX++;
            }
        }
    else // it is just 1 column
        {
        for (it = Entity_map.begin(); it != Entity_map.end(); it++)
            {
            Output_Data[0][ROW_INDEX] = (int) (*it).first;
            ROW_INDEX++;
            }
        }

    return mxOutput_Data;
}
/***************************************************************************************/

#undef SBD

/***/
