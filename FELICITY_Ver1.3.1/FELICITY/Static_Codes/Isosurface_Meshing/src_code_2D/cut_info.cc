/*
============================================================================================
   This class accesses the *cut* mesh data.

   Copyright (c) 12-20-2011,  Shawn W. Walker
============================================================================================
*/

#include "../src_hdr/MATLAB_Sparse_Matrix_Data.cc"

/* C++ "Cut Info" class definition */
#define CUT  CUT_Info_Class
class CUT
{
public:
    CUT (); // constructor
    ~CUT ();   // DE-structor
    void Setup_Data(const mxArray*, BCC_Mesh_Class*);
    void Get_Short_Cut_Attachments(const unsigned int& vi, unsigned int& NA, unsigned int a[4]);
    void Get_Long_Cut_Attachments (const unsigned int& vi, unsigned int& NA, unsigned int a[4]);

    typedef struct
        {
        // data related to the edges of the mesh that are cut by the zero level set/surface
        unsigned int             num_cut_edge; // number of cut edges
        double*                  edge_indices; // indices into the global mesh edges
        Generic_Data<double,2>   points;       // cut points for each (local) cut edge
        Sparse_Data_Class        V2E;          // (local) cut edge indices attached to (global) vertex
        // NOTE: all of these fields correspond to each other!
        } CUT_EDGE;

    CUT_EDGE  short0;
    CUT_EDGE  long0;

private:

};

/***************************************************************************************/
/* constructor */
CUT::CUT()
{
    // init
    short0.num_cut_edge = 0;
     long0.num_cut_edge = 0;
    short0.edge_indices = NULL;
     long0.edge_indices = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
CUT::~CUT ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void CUT::Setup_Data(const mxArray* mxCUT, BCC_Mesh_Class* bcc_ptr)      // inputs
{
    // access mesh data
    const mxArray* mxshort = mxGetField(mxCUT, (mwIndex) 0, "short");
    const mxArray* mxlong  = mxGetField(mxCUT, (mwIndex) 0, "long");

    // setup CUT edge info
    const mxArray* mxshort_edge_indices = mxGetField(mxshort, (mwIndex) 0, "edge_indices");
    short0.num_cut_edge = (unsigned int) mxGetNumberOfElements(mxshort_edge_indices);
    short0.edge_indices = mxGetPr(mxshort_edge_indices);
    const mxArray* mxshort_points = mxGetField(mxshort, (mwIndex) 0, "points");
    short0.points.Setup_Data("Cut Points (short)", mxshort_points, 0);
    const mxArray* mxshort_V2E = mxGetField(mxshort, (mwIndex) 0, "V2E");
    short0.V2E.Setup_Data(mxshort_V2E);

    const mxArray* mxlong_edge_indices  = mxGetField(mxlong, (mwIndex) 0, "edge_indices");
    long0.num_cut_edge = (unsigned int) mxGetNumberOfElements(mxlong_edge_indices);
    long0.edge_indices = mxGetPr(mxlong_edge_indices);
    const mxArray* mxlong_points = mxGetField(mxlong, (mwIndex) 0, "points");
    long0.points.Setup_Data("Cut Points (long)", mxlong_points, 0);
    const mxArray* mxlong_V2E = mxGetField(mxlong, (mwIndex) 0, "V2E");
    long0.V2E.Setup_Data(mxlong_V2E);
}
/***************************************************************************************/


/***************************************************************************************/
/* get short cut edges attached to the given vertex
   Note: the edge indices are in MATLAB style.
*/
void CUT::Get_Short_Cut_Attachments(const unsigned int& vtx_index,
                                          unsigned int& Num_Attached,
                                          unsigned int  attached_short_cut_edges[4])      // inputs
{
    // init
    int Num_Attached_TEMP = 0;
    double TEMP_ARRAY[4];

    // get the attachements
    short0.V2E.Get_Nonzero_Entries(vtx_index, Num_Attached_TEMP, TEMP_ARRAY);

    // convert
    Num_Attached = (unsigned int) Num_Attached_TEMP;
    for (unsigned int i = 0; i < Num_Attached; i++)
        attached_short_cut_edges[i] = (unsigned int) TEMP_ARRAY[i]; // convert over
}
/***************************************************************************************/


/***************************************************************************************/
/* get long cut edges attached to the given vertex
   Note: the edge indices are in MATLAB style.
*/
void CUT::Get_Long_Cut_Attachments(const unsigned int& vtx_index,
                                         unsigned int& Num_Attached,
                                         unsigned int  attached_long_cut_edges[4])      // inputs
{
    // init
    int Num_Attached_TEMP = 0;
    double TEMP_ARRAY[4];

    // get the attachements
    long0.V2E.Get_Nonzero_Entries(vtx_index, Num_Attached_TEMP, TEMP_ARRAY);

    // convert
    Num_Attached = (unsigned int) Num_Attached_TEMP;
    for (unsigned int i = 0; i < Num_Attached; i++)
        attached_long_cut_edges[i] = (unsigned int) TEMP_ARRAY[i]; // convert over
}
/***************************************************************************************/

#undef CUT

/***/
