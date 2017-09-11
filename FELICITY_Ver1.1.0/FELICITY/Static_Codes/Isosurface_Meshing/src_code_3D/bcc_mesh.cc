/*
============================================================================================
   This class accesses the BCC mesh data.

   Copyright (c) 12-20-2011,  Shawn W. Walker
============================================================================================
*/

/***************************************************************************************/
/* this struct is for extracting the simplex indices attached to edges or vertices */
typedef struct {
    unsigned int num;
    unsigned int indices[50];
} ATTACH;
/***************************************************************************************/

/* C++ BCC Mesh class definition */
#define BCC  BCC_Mesh_Class
class BCC
{
public:
    BCC (); // constructor
    ~BCC ();   // DE-structor
    void Setup_Data(const mxArray*);
    void Get_Short_Edge_Attachments(const unsigned int&, ATTACH&);
    void Get_Long_Edge_Attachments (const unsigned int&, ATTACH&);
    void Get_Vertex_Attachments(const unsigned int&, ATTACH&);
    void Get_Vertex_Indices_Of_Short_Edge(const unsigned int&, unsigned int&, unsigned int&);
    void Get_Vertex_Indices_Of_Long_Edge (const unsigned int&, unsigned int&, unsigned int&);
    void Get_Vertex_Coordinates(const unsigned int& VI, double VC[3]);
    void Get_Tetrahedra_Indices(const unsigned int& TI, unsigned int TD[4]);

    double  short_length;
    double  long_length;

    // mesh data
    const mxArray*              mxVtx;
    const mxArray*              mxTet;
    Generic_Data<double,3>        Vtx;
    Generic_Data<double,4>        Tet;

    typedef struct
        {
        // this is data for the set of edges contained in the mesh
        //   and for the simplices attached to these edges.
        Generic_Data<double,2>         short0;
        Generic_Data<double,2>         long0;
        mxArray*                       short_attach; // this is a cell array
        mxArray*                       long_attach;  // this is a cell array
        mxLogical*                     short_bdy_indicator;
        mxLogical*                     long_bdy_indicator;
        } BCC_EDGE;
    BCC_EDGE edge;

    typedef struct
        {
        // this is data for the set of vertices contained in the mesh
        //   and for the simplices attached to these vertices.
        mxArray*                       attach; // this is a cell array
        mxLogical*                     bdy_indicator;
        } BCC_VERTEX;
    BCC_VERTEX vertex;

private:
    void Get_Attachments(const mxArray*, const unsigned int&, ATTACH&);

};

/***************************************************************************************/
/* constructor */
BCC::BCC()
{
    // init
    short_length = 0.0;
    long_length  = 0.0;
    edge.short_attach = NULL;
    edge.long_attach  = NULL;
    edge.short_bdy_indicator = NULL;
    edge.long_bdy_indicator  = NULL;
    vertex.attach            = NULL;
    vertex.bdy_indicator     = NULL;

}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
BCC::~BCC ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void BCC::Setup_Data(const mxArray* mxBCC)      // inputs
{
    // access mesh data
    mxVtx = mxGetField(mxBCC, (mwIndex) 0, "V");
    mxTet = mxGetField(mxBCC, (mwIndex) 0, "T");
    const mxArray* mxedge_struct   = mxGetField(mxBCC, (mwIndex) 0, "edge");
    const mxArray* mxvertex_struct = mxGetField(mxBCC, (mwIndex) 0, "vertex");

    // setup tetrahedral mesh part
    Vtx.Setup_Data("Vertex Coordinates", mxVtx, 0);
    Tet.Setup_Data("Tet Data", mxTet, 0);

    // setup edge info
    const mxArray* mxedge_short = mxGetField(mxedge_struct, (mwIndex) 0, "short");
    edge.short0.Setup_Data("short edges of BCC mesh", mxedge_short, 0);
    const mxArray* mxedge_long  = mxGetField(mxedge_struct, (mwIndex) 0, "long");
    edge.long0.Setup_Data("long edges of BCC mesh", mxedge_long, 0);
    edge.short_attach = mxGetField(mxedge_struct, (mwIndex) 0, "short_attach");
    edge.long_attach  = mxGetField(mxedge_struct, (mwIndex) 0, "long_attach");
    const mxArray* mxshort_bdy_indicator = mxGetField(mxedge_struct, (mwIndex) 0, "short_bdy_indicator");
    edge.short_bdy_indicator = mxGetLogicals(mxshort_bdy_indicator);
    const mxArray* mxlong_bdy_indicator = mxGetField(mxedge_struct, (mwIndex) 0, "long_bdy_indicator");
    edge.long_bdy_indicator = mxGetLogicals(mxlong_bdy_indicator);

    // get edge lengths
    const mxArray* mxlen = mxGetField(mxedge_struct, (mwIndex) 0, "len");
    const mxArray* mxlen_short = mxGetField(mxlen, (mwIndex) 0, "short");
    const mxArray* mxlen_long  = mxGetField(mxlen, (mwIndex) 0, "long");
    short_length = *mxGetPr(mxlen_short);
    long_length  = *mxGetPr(mxlen_long);

    // setup vertex info
    vertex.attach = mxGetField(mxvertex_struct, (mwIndex) 0, "attach");
    const mxArray* mxvtx_bdy_indicator = mxGetField(mxvertex_struct, (mwIndex) 0, "bdy_indicator");
    vertex.bdy_indicator = mxGetLogicals(mxvtx_bdy_indicator);
}
/***************************************************************************************/


/***************************************************************************************/
/* get short edge attachments */
void BCC::Get_Short_Edge_Attachments(const unsigned int& index, ATTACH& att_ptr)      // inputs
{
    Get_Attachments(edge.short_attach, index, att_ptr);
}
/***************************************************************************************/


/***************************************************************************************/
/* get long edge attachments */
void BCC::Get_Long_Edge_Attachments(const unsigned int& index, ATTACH& att_ptr)      // inputs
{
    Get_Attachments(edge.long_attach, index, att_ptr);
}
/***************************************************************************************/


/***************************************************************************************/
/* get vertex attachments */
void BCC::Get_Vertex_Attachments(const unsigned int& index, ATTACH& att_ptr)      // inputs
{
    //Get_Attachments(vertex.attach, index, att_ptr);
    mexErrMsgTxt("Vertex attachments has been disabled!!!\n");
}
/***************************************************************************************/


/***************************************************************************************/
/* get simplex attachments
   NOTE: index is in the C-style.
*/
void BCC::Get_Attachments(const mxArray* mxAttach, const unsigned int& index, ATTACH& att_ptr)      // inputs
{
    // access attachment data
    const mxArray* mxATT = mxGetCell(mxAttach, (mwIndex) index);

    if (mxATT==NULL)
        {
        // then there are NO attachments
        att_ptr.num = 0;
        }
    else
        {
        // copy them over
        att_ptr.num = (unsigned int) mxGetNumberOfElements(mxATT);
        double* ind_ptr = mxGetPr(mxATT); // don't change the type here!
        for (unsigned int i = 0; (i < att_ptr.num); i++)
            att_ptr.indices[i] = (unsigned int) ind_ptr[i];
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get global vertex indices of the end points of a given global short edge index
   NOTE: e_ind is in the C-style.  V1, V2 are in the MATLAB style.
*/
void BCC::Get_Vertex_Indices_Of_Short_Edge(const unsigned int& e_ind,
                                                 unsigned int& V1,
                                                 unsigned int& V2)      // inputs
{
    // get the (global) vertex indices of given short edge
    double TEMP_End_Point_Indices[2];
    edge.short0.Read(e_ind, TEMP_End_Point_Indices);

    // convert
    V1 = (unsigned int) TEMP_End_Point_Indices[0];
    V2 = (unsigned int) TEMP_End_Point_Indices[1];
}
/***************************************************************************************/


/***************************************************************************************/
/* similar to ``short'' version except for the long edges */
void BCC::Get_Vertex_Indices_Of_Long_Edge(const unsigned int& e_ind,
                                                unsigned int& V1,
                                                unsigned int& V2)      // inputs
{
    // get the (global) vertex indices of given long edge
    double TEMP_End_Point_Indices[2];
    edge.long0.Read(e_ind, TEMP_End_Point_Indices);

    // convert
    V1 = (unsigned int) TEMP_End_Point_Indices[0];
    V2 = (unsigned int) TEMP_End_Point_Indices[1];
}
/***************************************************************************************/


/***************************************************************************************/
/* get vertex coordinates (for a single given index)
   NOTE: V_ind is in MATLAB indexing!
*/
void BCC::Get_Vertex_Coordinates(const unsigned int& V_ind,
                                 double Vtx_Coord[3])         // inputs
{
    unsigned int V_ind_C_style = V_ind-1;
    Vtx.Read(V_ind_C_style, Vtx_Coord);
}
/***************************************************************************************/


/***************************************************************************************/
/* get tetrahedra indices (for a single given index)
   Note: T_ind is in the MATLAB style.
*/
void BCC::Get_Tetrahedra_Indices(const unsigned int& T_ind,
                                 unsigned int tet_data[4])         // inputs
{
    unsigned int T_ind_C_style = T_ind-1;
    double TD[4];
    Tet.Read(T_ind_C_style, TD);
    // convert
    for (unsigned int k = 0; k < 4; k++)
        tet_data[k] = (unsigned int) TD[k];
}
/***************************************************************************************/

#undef BCC

/***/
