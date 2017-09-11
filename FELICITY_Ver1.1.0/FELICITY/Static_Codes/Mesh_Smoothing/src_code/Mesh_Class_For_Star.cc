/*
============================================================================================
   This class accesses the mesh geometry data.  In particular, it is useful for
   accessing the ``star'' of elements around a vertex.

   Copyright (c) 04-23-2013,  Shawn W. Walker
============================================================================================
*/

#define  MCFS   Mesh_Class_For_Star

/* C++ (Specific) Mesh class definition */
class MCFS: public Base_Mesh_Class // derive from base class
{
public:
    /***************************************************************************************/
    MCFS (); // constructor
    ~MCFS ();   // DE-structor
    void Setup_Mesh(const mxArray*, const mxArray*);
    void Read_Star_For_1D(const int&, STAR&);
    void Read_Star(const int&, STAR&);
    const mxArray* Return_MATLAB_Vtx_Coord() { return Mesh_Vtx_Coord; }

private:
    double*          Node_Value[3];    // mesh node values
    int*             Elem_DoF[4];      // element DoF list
    const mxArray*   Vtx_Attachment;   // MATLAB cell array of element indices
                                       // attached to each vertex
    const mxArray*   Mesh_Vtx_Coord;   // pointer to MATLAB Data for Vertex Coordinates

    void Get_Local_to_Global_DoFmap(const int&, int*);
    void Fill_Star(double*, STAR&);
};

/***************************************************************************************/
/* constructor */
MCFS::MCFS () : Base_Mesh_Class ()
{
    Vtx_Attachment = NULL;
    Mesh_Vtx_Coord = NULL;

    // init mesh information to NULL
    for (int ii = 0; (ii < 3); ii++)
        Node_Value[ii] = NULL;
    for (int ii = 0; (ii < 4); ii++)
        Elem_DoF[ii] = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
MCFS::~MCFS ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void MCFS::Setup_Mesh(const mxArray* mxMesh,        // inputs
                      const mxArray* mxVtx_Attach)  // inputs
{
    // access mesh data
    if (!mxIsCell(mxMesh))
        mexErrMsgTxt("Mesh data {Vtx Coord, Element Connectivity Data} must be stored in a cell array!");
    // parse cell array
    Mesh_Vtx_Coord         = mxGetCell(mxMesh, (mwIndex) 0);
    const mxArray* mxElem  = mxGetCell(mxMesh, (mwIndex) 1);
    // get vertex attachment data
    Vtx_Attachment = mxVtx_Attach; // store it internally

    // get the ambient geometric dimension
    GeoDim    = (int) mxGetN(Mesh_Vtx_Coord);
    // get the number of vertices
    Num_Nodes = (int) mxGetM(Mesh_Vtx_Coord);
    // get the number of elements
    Num_Elem  = (int) mxGetM(mxElem);
    // get the number of vertices for each element
    Num_Basis = (int) mxGetN(mxElem);
    // compute the topological dimension
    TopDim    = Num_Basis - 1;

    /* BEGIN: Simple Error Checking */
    if ((GeoDim!=1) && (!mxIsCell(Vtx_Attachment)))
        mexErrMsgTxt("ERROR: Vertex Attachment Data must be a cell array for 2-D and 3-D meshes!");
    if ((GeoDim==1) && (!mxIsNumeric(Vtx_Attachment)))
        mexErrMsgTxt("ERROR: Vertex Attachment Data must be a numeric matrix for 1-D meshes!");
    if (Num_Nodes!=(int) mxGetM(Vtx_Attachment))
        mexErrMsgTxt("ERROR: Number of entries in Vertex Attachment Data must equal number of vertices in the mesh!");
    if (mxGetClassID(mxElem)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Connectivity Data must be uint32!");
    if (GeoDim != TopDim)
        {
        mexPrintf("ERROR: Vertex Coordinate List has %d columns; expected %d columns.\n", GeoDim, TopDim);
        mexErrMsgTxt("ERROR: the geometric dimension must equal the topological dimension of the mesh!");
        }
    if ((GeoDim < 1) || (GeoDim > 3))
        {
        mexPrintf("ERROR: The geometric dimension == topological dimension is %d.\n", GeoDim);
        mexErrMsgTxt("ERROR: valid values for the geometric dimension are 1, 2, and 3 only!");
        }
    /* END: Simple Error Checking */


    // split up the columns of the node data
    Node_Value[0] = mxGetPr(Mesh_Vtx_Coord);
    for (int gd_i = 1; (gd_i < GeoDim); gd_i++)
        Node_Value[gd_i] = Node_Value[gd_i-1] + Num_Nodes;

    // split up the columns of the element data
    Elem_DoF[0] = (int*) mxGetPr(mxElem);
    for (int basis_i = 1; (basis_i < Num_Basis); basis_i++)
        Elem_DoF[basis_i] = Elem_DoF[basis_i-1] + Num_Elem;

    // get maximum DoF present in Elem
    int Elem_Num_Nodes  = *std::max_element(Elem_DoF[0],Elem_DoF[0] + (Num_Elem*Num_Basis));
    int Min_DoF         = *std::min_element(Elem_DoF[0],Elem_DoF[0] + (Num_Elem*Num_Basis));
    if ((Min_DoF < 1) || (Elem_Num_Nodes < 1))
        {
        mexPrintf("ERROR: There are Mesh Element Vertex indices < 1!\n");
        mexPrintf("ERROR: There are problems with the Mesh!\n");
        mexErrMsgTxt("ERROR: Fix your Mesh Element Connectivity!");
        }
    if (Elem_Num_Nodes > Num_Nodes)
        {
        mexPrintf("ERROR: There are Mesh Element Vertex indices > number of Mesh Vertices!\n");
        mexPrintf("ERROR: There are problems with the Mesh!\n");
        mexErrMsgTxt("ERROR: Fix your Mesh Element Connectivity!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get local vertex indices on the given element */
void MCFS::Get_Local_to_Global_DoFmap(const int& elem_index, int* Indices)  // inputs
{
    // get local to global indexing for the element
    for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)
        {
        int DoF_index = Elem_DoF[basis_i][elem_index] - 1; // shifted for C - style indexing
        Indices[basis_i] = DoF_index;
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* read in the star of element data for the given vertex (for 1-D meshes)
   Note: all vertex indices are in the C-style.  */
void MCFS::Read_Star_For_1D(const int& vtx_index,  // input
                            STAR& vtx_star)        // output
{
    // store the center vtx index of the star of elements
    vtx_star.center_vtx_index = vtx_index;
    vtx_star.elem.clear(); // init

    // error check:
    const int Num_Col = (const int) mxGetN(Vtx_Attachment);
    if (Num_Col!=2)
        {
        mexPrintf("ERROR: The vertex attachment data does not have the proper form.\n");
        mexPrintf("ERROR:     It should be an M x 2 matrix for 1-D meshes (M = number of mesh vertices)!\n");
        mexErrMsgTxt("ERROR: Fix your vertex attachment data!");
        }

    // get list of element indices in the star
    const double* EI1 = (double*) mxGetPr(Vtx_Attachment);
    const double* EI2 = EI1 + Num_Nodes;

    // get the valid elements in the star (only 1 or 2)
    double Elem_Indices[2];
    if ((EI1[vtx_index]==0) && (EI2[vtx_index]==0))
        vtx_star.elem.resize(0);
    else if (EI1[vtx_index]==0)
        {
        vtx_star.elem.resize(1);
        Elem_Indices[0] = EI2[vtx_index];
        }
    else if (EI2[vtx_index]==0)
        {
        vtx_star.elem.resize(1);
        Elem_Indices[0] = EI1[vtx_index];
        }
    else
        {
        vtx_star.elem.resize(2);
        Elem_Indices[0] = EI1[vtx_index];
        Elem_Indices[1] = EI2[vtx_index];
        }

    // fill in the star vertex index data
    Fill_Star(Elem_Indices, vtx_star);
}
/***************************************************************************************/


/***************************************************************************************/
/* read in the star of element data for the given vertex
   Note: all vertex indices are in the C-style.  */
void MCFS::Read_Star(const int& vtx_index,  // input
                     STAR& vtx_star)        // output
{
    // store the center vtx index of the star of elements
    vtx_star.center_vtx_index = vtx_index;
    vtx_star.elem.clear(); // init

    // get list of element indices in the star
    const mxArray* mxStar = mxGetCell(Vtx_Attachment, (mwIndex) vtx_index);
    const int Num_Row     = (const int) mxGetM(mxStar);
    if (Num_Row!=1)
        {
        mexPrintf("ERROR: The vertex attachment data does not have the proper form.\n");
        mexPrintf("ERROR:     Each piece of data should only have *one* row!\n");
        mexErrMsgTxt("ERROR: It should be a cell array of row vectors!");
        }
    // set the size
    const int Num_Elem_In_Star = (const int) mxGetN(mxStar);
    vtx_star.elem.resize(Num_Elem_In_Star);

    // get the element indices
    double* Elem_Indices = (double*) mxGetPr(mxStar);

    // fill in the star vertex index data
    Fill_Star(Elem_Indices, vtx_star);
}
/***************************************************************************************/


/***************************************************************************************/
/* store the element vertex indices so that the given center vertex
   is listed as vertex #2 for all elements in the star */
void MCFS::Fill_Star(double*    Elem_Indices,         // inputs
                     STAR&      vtx_star)             // inputs/outputs
{
    const int center_vi = vtx_star.center_vtx_index;
    if (Num_Basis==2)
        {
        // loop through the two edges of the star
        for (int ii = 0; (ii < vtx_star.elem.size()); ii++)
            {
            const int Elem_Index = ((const int) Elem_Indices[ii]) - 1; // C-style indexing
            // do not reorder the vertices for 1-D meshes!
            Get_Local_to_Global_DoFmap(Elem_Index, vtx_star.elem[ii].vtx_indices);
            }
        }
    else if (Num_Basis==3)
        {
        // loop through triangles of the star
        for (int ii = 0; (ii < vtx_star.elem.size()); ii++)
            {
            const int Elem_Index = ((const int) Elem_Indices[ii]) - 1; // C-style indexing
            int vi_temp[3];

            Get_Local_to_Global_DoFmap(Elem_Index, vi_temp);
			// maintain positive orientation
            if (vi_temp[0]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[2];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[0];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[1];
                }
            else if (vi_temp[1]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[0];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[1];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[2];
                }
            else if (vi_temp[2]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[1];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[2];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[0];
                }
            else
                {
                mexPrintf("ERROR: Center vertex #%d of the star was not found in element #%d!\n",center_vi+1,Elem_Index+1);
                mexErrMsgTxt("ERROR: Make sure the vertex attachment data is correct!");
                }
            }
        }
    else if (Num_Basis==4)
        {
        // loop through tetrahedra of the star
        for (int ii = 0; (ii < vtx_star.elem.size()); ii++)
            {
            const int Elem_Index = ((const int) Elem_Indices[ii]) - 1; // C-style indexing
            int vi_temp[4];

            Get_Local_to_Global_DoFmap(Elem_Index, vi_temp);
			// maintain positive orientation
            if (vi_temp[0]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[2];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[0];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[1];
                vtx_star.elem[ii].vtx_indices[3] = vi_temp[3];
                }
            else if (vi_temp[1]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[0];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[1];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[2];
                vtx_star.elem[ii].vtx_indices[3] = vi_temp[3];
                }
            else if (vi_temp[2]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[1];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[2];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[0];
                vtx_star.elem[ii].vtx_indices[3] = vi_temp[3];
                }
            else if (vi_temp[3]==center_vi)
                {
                vtx_star.elem[ii].vtx_indices[0] = vi_temp[0];
                vtx_star.elem[ii].vtx_indices[1] = vi_temp[3];
                vtx_star.elem[ii].vtx_indices[2] = vi_temp[1];
                vtx_star.elem[ii].vtx_indices[3] = vi_temp[2];
                }
            else
                {
                mexPrintf("ERROR: Center vertex #%d of the star was not found in element #%d!\n",center_vi+1,Elem_Index+1);
                mexErrMsgTxt("ERROR: Make sure the vertex attachment data is correct!");
                }
            }
        }
    else
        mexErrMsgTxt("ERROR: Num_Basis should be 2, 3, or 4!");
}
/***************************************************************************************/

#undef MCFS

/***/
