/*
============================================================================================
   Class that implements the mesh-generation algorithm.

   Copyright (c) 12-20-2011,  Shawn W. Walker
============================================================================================
*/

#include "basic_math.h"

/***************************************************************************************/
typedef struct {
    double d; // distance value
    unsigned int short_cut_pt_index;
    unsigned int vtx_index;
    unsigned int opposite_vtx_index;
    unsigned int num_attached_short;
    unsigned int num_attached_long;
    unsigned int attached_short_cut_edges[4];
    unsigned int attached_long_cut_edges[4];
} D_MIN_STRUCT;
/***************************************************************************************/

/***************************************************************************************/
/* struct containing triangle connectivity data for the 2 triangles in an edge-pair */
typedef struct {
    double tri1_data[3];
    double tri2_data[3];
} TRI_PAIR_DATA_STRUCT;
/***************************************************************************************/

#define MGA MeshGen_Algorithm_Class
/***************************************************************************************/
class MGA
{
public:
    MGA (); // constructor
    ~MGA (); // DE-structor

    // initalize external data pointers
    void Setup_Data (BCC_Mesh_Class*, CUT_Info_Class*, const mxArray*);
    void Initial_Vertex_Labeling ();
    void Run_Back_Labeling ();
    void Find_Long_Edges_With_Manifold_End_Points ();
    void Perform_Edge_Flips ();
    void Find_Isolated_Ambiguous_Tri ();
    void Choose_Inside_Outside_Tri ();

    mxArray* mxOutVtx;   // for outputting to MATLAB
    mxArray* mxOutTri;   // for outputting to MATLAB
    mxArray* mxOutInMsk; // for outputting to MATLAB
    mxArray* mxOutAmbIndices; // for outputting to MATLAB

private:

    // basic info about background mesh
    unsigned int                Num_BCC_Vtx;               // number of vertices in the BCC mesh
    unsigned int                Num_BCC_Tri;               // number of Tris in the BCC mesh

    typedef struct
    {
        std::vector<bool>           short_cut_edge_active; // Nx1 array of T/F where N is the number of short cut edges
        std::vector<bool>            long_cut_edge_active; // Mx1 array of T/F where M is the number of long  cut edges
                                                           // N,M correspond to the number of short and long cut edges
                                                           //     in "CUT_Info_Class".
        std::vector<bool>           vtx_mask;              // logical array indicating which vertices are manifold
                                                           //     i.e. which vertices will lie on the surface
        double*                     dest_pt[2];            // pointer to new vertex positions of the BCC mesh
        std::vector<unsigned int>   moving_toward;         // array of vertex indices:
                                                           // ith entry corresponds to the (i+1) vertex of the BCC mesh
                                                           //     if the (i+1) vertex is manifold, then the ith entry
                                                           //     contains the vertex index that the (i+1) vertex
                                                           //     warps toward;
                                                           //     if the (i+1) vertex is NOT manifold, then the ith entry
                                                           //     contains 0.
        // be careful with C-style indexing here!
    } MANIFOLD_STATUS;

    MANIFOLD_STATUS   manifold;

    // level set values (at BCC vertices) data
    double*    level_set_values_at_vtx;

    // data for output triangles
    double*                     out_tri_data[3];       // pointer to new tri data for the background mesh
    mxLogical*                  tri_in_mask;           // pointer to the inside/outside labeling for the new triangles

    // keep track of decomposition of long edges
    std::vector<unsigned int>   long_edge_indices_both_manifold;
    std::vector<unsigned int>   long_edge_indices_one_manifold;

    // keep track of the ambiguity status of all the triangles
    std::vector<unsigned int>   ambiguous_tri_status; // status  0: not ambiguous
                                                      // status  1: ambiguous, but isolated
                                                      // status  2: ambiguous, but NOT isolated
    BCC_Mesh_Class*   bcc_mesh;
    CUT_Info_Class*   cut_info;

// ROUTINES
    void Check_For_Suppressed_Short_Cut_Edges ();
    void Apply_Labeling (unsigned int&, unsigned int&);
    void Label_Vertex (D_MIN_STRUCT&);
    D_MIN_STRUCT Unlabel_Manifold_Vertex (const unsigned int&);
    void Find_Adjoining_Cut_Edges_With_NonManifold_Opp_Vtx (D_MIN_STRUCT&);

    void Overwrite_Destination_Point (const unsigned int& VI, const double NP[2]);
    void Read_Destination_Point (const unsigned int& VI, double Dest[2]);
    void Overwrite_New_Tri_Data (const unsigned int& TI, const double NTD[3]);
    void Overwrite_New_Pair_Data (const unsigned int ti[3], const TRI_PAIR_DATA_STRUCT& O);
    D_MIN_STRUCT Get_d_min_Over_Edge (const unsigned int&, const unsigned int&);
    D_MIN_STRUCT Get_d_min_At_Vertex (const unsigned int&);
    void Compute_Min_Over_Short_Active_Cut_Edge (const unsigned int& local_edge_index,
                                                 const double Vtx_Coord[2], D_MIN_STRUCT& d_min);
    unsigned int Get_Opposite_Vertex_Index_On_Short_Edge (const unsigned int&, const unsigned int&);
    unsigned int Get_Opposite_Vertex_Index_On_Long_Edge  (const unsigned int&, const unsigned int&);

    bool BL_Single_Pass ();
    bool BL_Get_d_min_Over_Short_Edges (const D_MIN_STRUCT&, std::vector<D_MIN_STRUCT>&);

    void Get_Arranged_Quadrilateral_Vertex_Indices (const unsigned int& s, const ATTACH& tp, unsigned int qd[4]);
    void Flip_Active_Cut_Long_Edges ();

    void Flip_Long_Edges_With_One_Manifold_Point ();
    bool One_Manifold_Long_Edge_Flip_Valid (const unsigned int  qvi[4]);

    bool Do_22_Edge_Flip_One_Manifold_Long_Edge (const ATTACH&, const unsigned int  qdi_o[4]);

    void Compute_MinMax_Dihedral_Angle_of_Tri_Pair (const double t1[3], const double t2[3],
                                                    double& min, double& max);
    void Compute_MinMax_DotProd (const double td[3], double& min, double& max);
    void Compute_MinMax_Dihedral_Angle (const double td[3], double& min, double& max);

    void Get_Sign_Of_Tri (const unsigned int& ti, int tsd[3]);
    void Get_Manifold_Vtx_Indices (std::vector<unsigned int>&);

};

/***************************************************************************************/
/* constructor */
MGA::MGA ()
{
    // init
    mxOutVtx = NULL;
    mxOutTri = NULL;
    mxOutInMsk = NULL;
    mxOutAmbIndices = NULL;
    Num_BCC_Vtx = 0;
    Num_BCC_Tri = 0;
    level_set_values_at_vtx = NULL;
    bcc_mesh = NULL;
    cut_info = NULL;
    manifold.short_cut_edge_active.clear();
    manifold.long_cut_edge_active.clear();
    manifold.vtx_mask.clear();
    manifold.dest_pt[0] = NULL;
    manifold.dest_pt[1] = NULL;
    out_tri_data[0] = NULL;
    out_tri_data[1] = NULL;
    out_tri_data[2] = NULL;
    tri_in_mask = NULL;
    manifold.moving_toward.clear();
    long_edge_indices_both_manifold.clear();
    long_edge_indices_one_manifold.clear();
    ambiguous_tri_status.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
MGA::~MGA ()
{
    mxOutVtx = NULL;
    mxOutTri = NULL;
    mxOutInMsk = NULL;
    mxOutAmbIndices = NULL;
    Num_BCC_Vtx = 0;
    Num_BCC_Tri = 0;
    level_set_values_at_vtx = NULL;
    bcc_mesh = NULL;
    cut_info = NULL;
    manifold.short_cut_edge_active.clear();
    manifold.long_cut_edge_active.clear();
    manifold.vtx_mask.clear();
    manifold.dest_pt[0] = NULL;
    manifold.dest_pt[1] = NULL;
    out_tri_data[0] = NULL;
    out_tri_data[1] = NULL;
    out_tri_data[2] = NULL;
    tri_in_mask = NULL;
    manifold.moving_toward.clear();
    long_edge_indices_both_manifold.clear();
    long_edge_indices_one_manifold.clear();
    ambiguous_tri_status.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* initializer */
void MGA::Setup_Data (BCC_Mesh_Class* bcc_ptr, CUT_Info_Class* cut_ptr, const mxArray* mxLS_VAL)
{
    // pass the pointers
    bcc_mesh = bcc_ptr;
    cut_info = cut_ptr;

    mwSize dims[2]; // for convenience

    // access level set values
    level_set_values_at_vtx = mxGetPr(mxLS_VAL);

    // init manifold data

    // SHORT
    const unsigned int Num_Short_Cut_Edge = cut_info->short0.num_cut_edge;
    manifold.short_cut_edge_active.resize(Num_Short_Cut_Edge);
    manifold.short_cut_edge_active.assign(Num_Short_Cut_Edge,true); // fill to true (all start as active)

    // LONG
    const unsigned int Num_Long_Cut_Edge = cut_info->long0.num_cut_edge;
    manifold.long_cut_edge_active.resize(Num_Long_Cut_Edge);
    manifold.long_cut_edge_active.assign(Num_Long_Cut_Edge,true); // fill to true (all start as active)

    // vertex manifold mask
    Num_BCC_Vtx = bcc_mesh->Vtx.Get_Num_Rows();
    manifold.vtx_mask.resize(Num_BCC_Vtx);
    manifold.vtx_mask.assign(Num_BCC_Vtx,false); // fill to false (nothing is manifold yet)

    // duplicate vertex coordinate data
    mxOutVtx = mxDuplicateArray(bcc_mesh->mxVtx);
    // access vertex data
    manifold.dest_pt[0] = (double*) mxGetPr(mxOutVtx);
    for (unsigned int i = 1; (i < 2); i++)
        manifold.dest_pt[i] = manifold.dest_pt[i-1] + Num_BCC_Vtx;

    // duplicate tri data
    mxOutTri = mxDuplicateArray(bcc_mesh->mxTri);
    // access tri data
    Num_BCC_Tri = (unsigned int) mxGetM(mxOutTri);
    out_tri_data[0] = (double*) mxGetPr(mxOutTri);
    for (unsigned int i = 1; (i < 3); i++)
        out_tri_data[i] = out_tri_data[i-1] + Num_BCC_Tri;

    // init data for output mask that selects inside/outside triangles
    dims[0] = (mwSize) Num_BCC_Tri;
    dims[1] = (mwSize) 1;
    mxOutInMsk = mxCreateLogicalArray((mwSize) 2, dims);
    tri_in_mask = mxGetLogicals(mxOutInMsk);
    // this is automatically initialized to all false (all outside!)

    // init structure for indicating vertex indices that a manifold vertex moves toward
    manifold.moving_toward.resize(Num_BCC_Vtx);
    manifold.moving_toward.assign(Num_BCC_Vtx,0); // init to all zero (because no vertices are manifold)

    // init array for storing ambiguous tri indices
    ambiguous_tri_status.resize(Num_BCC_Tri);
    ambiguous_tri_status.assign(Num_BCC_Tri,0); // init to all 0 (default value)
}
/***************************************************************************************/


/* INITIAL VERTEX LABELING ROUTINES */


/***************************************************************************************/
/* Execute Initial Vertex Labeling Algorithm: perform initial (manifold) labeling */
void MGA::Initial_Vertex_Labeling ()
{
    // loop thru the short cut edges
    const unsigned int Num_Short_Cut_Edge = cut_info->short0.num_cut_edge;
    for (unsigned int i = 0; (i < Num_Short_Cut_Edge); i++)
        // if this short cut edge is active
        if (manifold.short_cut_edge_active[i])
            {
            // get global edge index for the cut edge
            unsigned int e_ind = (unsigned int) (cut_info->short0.edge_indices[i] - 1); // adjust for C-style indexing

            // get the (global) vertex indices of that cut edge
            unsigned int Vertex_Indices[2] = {0, 0};
            bcc_mesh->Get_Vertex_Indices_Of_Short_Edge(e_ind, Vertex_Indices[0], Vertex_Indices[1]);

            // apply labeling
            Apply_Labeling(Vertex_Indices[0], Vertex_Indices[1]);
            }
    mexPrintf("\n");
    mexPrintf("Finished Initial Vertex Labeling.  Number of short cut edges suppressed is %d.\n",
              Num_Short_Cut_Edge);
    mexPrintf("\n");
    // error check
    Check_For_Suppressed_Short_Cut_Edges();
}
/***************************************************************************************/


/***************************************************************************************/
/* this does some basic error checking */
void MGA::Check_For_Suppressed_Short_Cut_Edges ()
{
    // loop thru all short cut edges
    for (unsigned int i = 0; i < cut_info->short0.num_cut_edge; i++)
        {
        if (manifold.short_cut_edge_active[i])  mexErrMsgTxt("There are still some active cut short edges!");

        unsigned int short_edge_indices[2];
        unsigned int edge_index_C_style = (unsigned int) (cut_info->short0.edge_indices[i] - 1);
        bcc_mesh->Get_Vertex_Indices_Of_Short_Edge(edge_index_C_style, short_edge_indices[0], short_edge_indices[1]);
        if ((!manifold.vtx_mask[short_edge_indices[0]-1]) &&
            (!manifold.vtx_mask[short_edge_indices[1]-1]))
            mexErrMsgTxt("There is a suppressed short cut edge with both end points NOT labeled manifold!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* given edge end point indices, choose the one with the lowest d_min to be manifold */
void MGA::Apply_Labeling (unsigned int& V1, unsigned int& V2)
{
    D_MIN_STRUCT D_MIN = Get_d_min_Over_Edge(V1, V2); // use MATLAB indexing for these!
    Label_Vertex(D_MIN);
}
/***************************************************************************************/


/***************************************************************************************/
/* Given the D_MIN struct, label the specified vertex manifold while
      maintaining consistency of the data structures. */
void MGA::Label_Vertex (D_MIN_STRUCT& d_min)
{
    // if a valid minimum was found
    if (d_min.d <= 0.500000001) // give a little extra (should be 0.5)
        {
        // indicate that the vertex is manifold
        const unsigned int V_man = d_min.vtx_index - 1; // C-style indexing
        manifold.vtx_mask[V_man] = true;

        // get destination (cut) point
        double Destination_Point[2];
        cut_info->short0.points.Read(d_min.short_cut_pt_index, Destination_Point);
        // record destination point
        Overwrite_Destination_Point(V_man, Destination_Point);

        // record the vertex index that this new manifold vertex is warping toward
        manifold.moving_toward[V_man] = d_min.opposite_vtx_index; // MATLAB indexing

        // suppress active short cut edges
        for (unsigned int i = 0; i < d_min.num_attached_short; i++)
            manifold.short_cut_edge_active[d_min.attached_short_cut_edges[i]-1] = false; // don't forget C-style indexing

        // don't forget to suppress the long cut active edges!
        cut_info->Get_Long_Cut_Attachments(d_min.vtx_index, d_min.num_attached_long, d_min.attached_long_cut_edges);
        for (unsigned int i = 0; i < d_min.num_attached_long; i++)
            manifold.long_cut_edge_active[d_min.attached_long_cut_edges[i]-1] = false; // don't forget C-style indexing
        }
    // else do nothing!
        //mexErrMsgTxt("This should not happen!");
}
/***************************************************************************************/


/***************************************************************************************/
/* This unlabels a given manifold vertex.
   Note: v_ind is already in the C-style indexing.
*/
D_MIN_STRUCT MGA::Unlabel_Manifold_Vertex (const unsigned int& v_ind)
{
    // undo manifold status
    manifold.vtx_mask[v_ind] = false;

    // reset destination point
    double Vtx_Coord[2];
    bcc_mesh->Get_Vertex_Coordinates(v_ind+1, Vtx_Coord); // must use matlab indexing here!
    Overwrite_Destination_Point(v_ind, Vtx_Coord);

    // this vertex is no longer moving (warping) anywhere
    manifold.moving_toward[v_ind] = 0; // 0 means NULL for MATLAB indexing!

    // find adjoining (active) cut edges
    D_MIN_STRUCT   info;
    info.vtx_index = v_ind+1; // store it for convenience (MATLAB-style indexing)
    Find_Adjoining_Cut_Edges_With_NonManifold_Opp_Vtx(info);

    // ensure to reactivate those short cut edges
    for (unsigned int i = 0; i < info.num_attached_short; i++)
        manifold.short_cut_edge_active[info.attached_short_cut_edges[i]-1] = true; // don't forget C-style indexing

    // ensure to reactivate those long cut edges
    for (unsigned int i = 0; i < info.num_attached_long; i++)
        manifold.long_cut_edge_active[info.attached_long_cut_edges[i]-1] = true; // don't forget C-style indexing

    return info;
}
/***************************************************************************************/


/***************************************************************************************/
/* This takes a given vertex index and returns a list of cut edge indices such
      that the opposite vertex of each cut edge (opposite to the given vertex
      index) is NOT a manifold vertex.
*/
void MGA::Find_Adjoining_Cut_Edges_With_NonManifold_Opp_Vtx (D_MIN_STRUCT& info) // input (partially) and output
{
    // convenient variable
    D_MIN_STRUCT  TEMP_info;
    // adjoining short cut edges (indices)
    cut_info->Get_Short_Cut_Attachments(info.vtx_index, TEMP_info.num_attached_short, TEMP_info.attached_short_cut_edges);
    // adjoining long cut edges (indices)
    cut_info->Get_Long_Cut_Attachments(info.vtx_index, TEMP_info.num_attached_long, TEMP_info.attached_long_cut_edges);

    // init
    info.num_attached_short = 0;
    info.num_attached_long  = 0;

    // loop thru short cut edges and pick out the ones with a non-manifold opposite vertex
    for (unsigned int si = 0; si < TEMP_info.num_attached_short; si++)
        {
        // local edge index must be in C-style
        const int opp_vtx_index_C_style = Get_Opposite_Vertex_Index_On_Short_Edge
                                                  (TEMP_info.attached_short_cut_edges[si]-1, info.vtx_index) - 1;
        // if the opposite vertex is NOT manifold
        if (!manifold.vtx_mask[opp_vtx_index_C_style])
            {
            // then add this cut edge to the list
            info.attached_short_cut_edges[info.num_attached_short] = TEMP_info.attached_short_cut_edges[si];
            info.num_attached_short++;
            }
        }
    // loop thru long cut edges and pick out the ones with a non-manifold opposite vertex
    for (unsigned int li = 0; li < TEMP_info.num_attached_long; li++)
        {
        // local edge index must be in C-style
        const int opp_vtx_index_C_style = Get_Opposite_Vertex_Index_On_Long_Edge
                                                  (TEMP_info.attached_long_cut_edges[li]-1, info.vtx_index) - 1;
        // if the opposite vertex is NOT manifold
        if (!manifold.vtx_mask[opp_vtx_index_C_style])
            {
            // then add this cut edge to the list
            info.attached_long_cut_edges[info.num_attached_long] = TEMP_info.attached_long_cut_edges[li];
            info.num_attached_long++;
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* change destination point coordinates (at a single index).
   note: Vtx_Index is already in the C-style indexing.
*/
void MGA::Overwrite_Destination_Point (const unsigned int& Vtx_Index, const double New_Point[2])
{
    manifold.dest_pt[0][Vtx_Index] = New_Point[0];
    manifold.dest_pt[1][Vtx_Index] = New_Point[1];
}
/***************************************************************************************/


/***************************************************************************************/
/* read destination point coordinates (at a single index).
   note: Vtx_Index is already in the C-style indexing.
*/
void MGA::Read_Destination_Point (const unsigned int& Vtx_Index, double Dest_Point[2])
{
    Dest_Point[0] = manifold.dest_pt[0][Vtx_Index];
    Dest_Point[1] = manifold.dest_pt[1][Vtx_Index];
}
/***************************************************************************************/


/***************************************************************************************/
/* change (new) triangle data (at a single index).
   note: Tri_Index is already in the C-style indexing.
*/
void MGA::Overwrite_New_Tri_Data (const unsigned int& Tri_Index, const double New_Tri_Data[3])
{
    // note: Tri_Index is already in the C-style indexing
    out_tri_data[0][Tri_Index] = New_Tri_Data[0];
    out_tri_data[1][Tri_Index] = New_Tri_Data[1];
    out_tri_data[2][Tri_Index] = New_Tri_Data[2];
}
/***************************************************************************************/


/***************************************************************************************/
/* change (new) pair of triangles.
   note: tri_indices is in the MATLAB-style indexing.
*/
void MGA::Overwrite_New_Pair_Data (const unsigned int tri_indices[2],
                                   const TRI_PAIR_DATA_STRUCT& Pair)
{
    Overwrite_New_Tri_Data(tri_indices[0] - 1, Pair.tri1_data);
    Overwrite_New_Tri_Data(tri_indices[1] - 1, Pair.tri2_data);
}
/***************************************************************************************/


/***************************************************************************************/
/* given edge end point indices, compute lowest d_min between the two end points */
D_MIN_STRUCT MGA::Get_d_min_Over_Edge (const unsigned int& V1, const unsigned int& V2)
{
    D_MIN_STRUCT D_MIN_1 = Get_d_min_At_Vertex(V1);
    D_MIN_STRUCT D_MIN_2 = Get_d_min_At_Vertex(V2);

    // choose the best one
    if (D_MIN_1.d < D_MIN_2.d)
        return D_MIN_1;
    else
        return D_MIN_2;
}
/***************************************************************************************/


/***************************************************************************************/
/* given vertex index, compute d_min.
   Note: V_ind is in MATLAB style indexing.
*/
D_MIN_STRUCT MGA::Get_d_min_At_Vertex (const unsigned int& V_ind)
{
    // initialize
    D_MIN_STRUCT d_min;
    d_min.d = 1000; // init to a large value
    // record vertex index for convenience
    d_min.vtx_index = V_ind; // MATLAB indexing

    // get short cut edge (local) indices attached to the given vertex
    cut_info->Get_Short_Cut_Attachments(d_min.vtx_index, d_min.num_attached_short, d_min.attached_short_cut_edges);

    // get coordinates of given vertex
    double Vtx_Coord[3];
    bcc_mesh->Get_Vertex_Coordinates(V_ind, Vtx_Coord);

    // compute min over ALL attached (active) short, cut edges
    for (unsigned int i = 0; i < d_min.num_attached_short; i++)
        {
        // get attached short cut edge (local) index
        const unsigned int Attached_Short_Cut_Edge_Index_C_Style = d_min.attached_short_cut_edges[i] - 1; // C-style indexing

        // if the short cut edge is active
        if (manifold.short_cut_edge_active[Attached_Short_Cut_Edge_Index_C_Style])
            {
            // then (possibly) update the current minimum value
            // note: this may modify d_min
            Compute_Min_Over_Short_Active_Cut_Edge(Attached_Short_Cut_Edge_Index_C_Style,Vtx_Coord,d_min);
            }
        }

    return d_min;
}
/***************************************************************************************/


/***************************************************************************************/
/* This computes d_cut for the given active short cut edge that adjoins the given
      vertex, d_min.vtx_index.  This is then used to update the d_min calculation
      (if the value is smaller).
      Note: this may modify d_min. */
void MGA::Compute_Min_Over_Short_Active_Cut_Edge (const unsigned int& local_edge_index,
                                                  const double Vtx_Coord[2],  D_MIN_STRUCT& d_min)
{
    double& SHORT_LENGTH = bcc_mesh->short_length;

    // get the cut point coordinates on that edge
    double Cut_Point[2];
    cut_info->short0.points.Read(local_edge_index, Cut_Point);

    // compute d_cut for that single edge
    double d_cut = Euclidean_Distance(Vtx_Coord, Cut_Point) / SHORT_LENGTH;

    // if we have a new minimum value
    if (d_cut < d_min.d)
        {
        // then store the new minimum value
        d_min.d = d_cut;
        // store the cut point (local) index on that adjoining cut edge
        d_min.short_cut_pt_index = local_edge_index; // C-style indexing!
        // store the opposite vertex (global) index (MATLAB indexing)
        d_min.opposite_vtx_index = Get_Opposite_Vertex_Index_On_Short_Edge(local_edge_index, d_min.vtx_index);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* given a (local) short edge index and a (global) vertex index, this checks that
      the vertex index is one of the end points of the short edge, and then returns
      the vertex index (global) of the OTHER end point of the short edge.
   Note: ``e_ind'' is in the C-style, and ``V_ind'' is in MATLAB indexing.  */
unsigned int MGA::Get_Opposite_Vertex_Index_On_Short_Edge (const unsigned int& e_ind,
                                                           const unsigned int& V_ind)
{
    // get the vertex indices of the short edge
    unsigned int global_e_ind = (unsigned int) (cut_info->short0.edge_indices[e_ind] - 1); // C-style indexing
    double edge_end_point_indices[2];
    bcc_mesh->edge.short0.Read(global_e_ind, edge_end_point_indices); // global indices

    unsigned int opposite_V_ind = 0;
    if (edge_end_point_indices[0]==V_ind)
        opposite_V_ind = (unsigned int) edge_end_point_indices[1]; // MATLAB indexing
    else if (edge_end_point_indices[1]==V_ind)
        opposite_V_ind = (unsigned int) edge_end_point_indices[0]; // MATLAB indexing
    else
        mexErrMsgTxt("ERROR: the given vertex index does NOT belong to the given edge!  See 'Get_Opposite_Vertex_Index_On_Short_Edge'");

    return opposite_V_ind;
}
/***************************************************************************************/


/***************************************************************************************/
/* similar to "short" version except for the long edges */
unsigned int MGA::Get_Opposite_Vertex_Index_On_Long_Edge (const unsigned int& e_ind,
                                                          const unsigned int& V_ind)
{
    // get the vertex indices of the long edge
    unsigned int global_e_ind = (unsigned int) (cut_info->long0.edge_indices[e_ind] - 1); // C-style indexing
    double edge_end_point_indices[2];
    bcc_mesh->edge.long0.Read(global_e_ind, edge_end_point_indices);

    unsigned int opposite_V_ind = 0;
    if (edge_end_point_indices[0]==V_ind)
        opposite_V_ind = (unsigned int) edge_end_point_indices[1]; // MATLAB indexing
    else if (edge_end_point_indices[1]==V_ind)
        opposite_V_ind = (unsigned int) edge_end_point_indices[0]; // MATLAB indexing
    else
        mexErrMsgTxt("ERROR: the given vertex index does NOT belong to the given edge!  See 'Get_Opposite_Vertex_Index_On_Long_Edge'");

    return opposite_V_ind;
}
/***************************************************************************************/


/* BACK LABELING ROUTINES */


/***************************************************************************************/
/* Execute Back-Labeling Algorithm: this runs the sub-algorithm to adjust the
      manifold vertex labeling so that no manifold vertex warps toward another
      manifold vertex.
*/
void MGA::Run_Back_Labeling ()
{
    mexPrintf("Start Back-Labeling...\n");

    // indicator if anything changes during a back-labeling pass
    bool Manifold_Labeling_Changed = false;
    // do initial pass
    Manifold_Labeling_Changed = BL_Single_Pass();

    unsigned int COUNT = 0;
    while (Manifold_Labeling_Changed)
        {
        COUNT++;
        // do another pass
        Manifold_Labeling_Changed = BL_Single_Pass();
        }
    mexPrintf("Finished Back-Labeling.  Number of Passes: %d\n",COUNT);
    // error check
    Check_For_Suppressed_Short_Cut_Edges();
}
/***************************************************************************************/


/***************************************************************************************/
/* This computes a ``single pass'' of the back-labeling algorithm.  Given a
    list of vertices, it applies the inner section of the ``while'' loop of the
    back-labeling algorithm to each vertex in the list.  If the vertex is a
    manifold vertex AND it is warping toward a manifold vertex, then it applies
    the algorithm.  Otherwise, it skips that vertex and moves on to the next
    vertex in the list.

    Note: you need to check that the vertex is manifold and that it is moving
    toward a manifold vertex b/c that status may change WITHIN the loop!
*/
bool MGA::BL_Single_Pass ()
{
    bool Changed_Manifold_Labeling = false; // record if this routine actually changes anything

    // keep track of number of times short cut edges get re-activated
    unsigned int RE_ACT_COUNT = 0;

    // loop through all BCC vertices
    for (unsigned int i = 0; i < Num_BCC_Vtx; i++)
        {
        // if a vertex is manifold
        if (manifold.vtx_mask[i])
            {
            //mexPrintf("Vertex Index: %d, is manifold.\n",i+1);
            // then check its opposite vertex (i.e. the one it is warping toward)
            const int opp_vtx_index_C_style = manifold.moving_toward[i] - 1;
            // AND if the opposite vertex is also manifold
            if (manifold.vtx_mask[opp_vtx_index_C_style])
                {
                // then apply back-labeling
                Changed_Manifold_Labeling = true; // manifold labeling will change now...

                // unlabel the main vertex "i" from manifold status
                D_MIN_STRUCT  adjoining_active_info = Unlabel_Manifold_Vertex(i);

                // only need to label vertices as manifold if there are new active cut (short) edges!
                if (adjoining_active_info.num_attached_short > 0)
                    {
                    // must suppress the re-activated short cut edges
                    RE_ACT_COUNT++; // keep count

                    //  recompute d_min over the adjoining reactivated short cut edges
                    //  (if there are any)
                    std::vector<D_MIN_STRUCT> D_MINs;
                    const bool Labeled_New_Vertices =
                                 BL_Get_d_min_Over_Short_Edges(adjoining_active_info, D_MINs);
                    // note: adjoining_active_info.vtx_index is in MATLAB style indexing

                    // label manifold vertices
                    std::vector<D_MIN_STRUCT>::iterator it;
                    for (it=D_MINs.begin(); it < D_MINs.end(); it++)
                        Label_Vertex(*it);
                    }
                }
            }
        }

    // output some information
    if (Changed_Manifold_Labeling)
        mexPrintf("    Finished Pass.  Suppressed reactivated short cut edges %d times.\n",RE_ACT_COUNT);

    return Changed_Manifold_Labeling;
}
/***************************************************************************************/


/***************************************************************************************/
/* This computes d_min for each active cut short edge that adjoins the given
   vertex: vtx_ind.

   Note: if the given vertex is CHOSEN for *any* of the adjoining edges, then
   ONLY return the struct for that choice!
*/
bool MGA::BL_Get_d_min_Over_Short_Edges (const D_MIN_STRUCT& adjoining_active_info, // input
                                         std::vector<D_MIN_STRUCT>& D_MINs)         // output
{
    // init storage "list" size
    D_MINs.clear();
    D_MINs.reserve(4); // there are only 4 short edges attached to each vertex

    // compute d_min at the ``main'' vertex first
    D_MINs.push_back(Get_d_min_At_Vertex(adjoining_active_info.vtx_index));

    // compute d_min at each opposite vertex (opposite to the ``main'' vertex)
    //         over each active cut edge that adjoins the ``main'' vertex
    int RELABEL_index = -1; // init
    for (unsigned int i = 0; i < adjoining_active_info.num_attached_short; i++)
        {
        const unsigned int opp_vtx_index = Get_Opposite_Vertex_Index_On_Short_Edge
                                                  (adjoining_active_info.attached_short_cut_edges[i]-1,
                                                   adjoining_active_info.vtx_index);
        // compute d_min at opposite vertex
        D_MIN_STRUCT d_min_OV = Get_d_min_At_Vertex(opp_vtx_index);

        // now compute d_min over that adjoining edge, but only store it if it is valid
        bool IS_VALID = false;
        if (d_min_OV.d < D_MINs[0].d)
            {
            if (d_min_OV.d <= 0.500000001) // if valid
                {
                IS_VALID = true;
                D_MINs.push_back(d_min_OV);
                }
            }
        else
            {
            if (D_MINs[0].d <= 0.500000001) // if valid
                {
                IS_VALID = true;
                D_MINs.push_back(D_MINs[0]);
                }
            }

        // only consider valid cases (i.e. the short cut edges only) SWW: is it always valid?
        if (IS_VALID)
            {
            const unsigned int LAST_INDEX = (unsigned int) (D_MINs.size() - 1);
            // if the ``main'' vertex was chosen for any of the edges
            if (D_MINs[LAST_INDEX].vtx_index==adjoining_active_info.vtx_index)
                {
                // then we ONLY need to label the ``main'' vertex manifold

                // record the index
                if (RELABEL_index < 0)
                    RELABEL_index = LAST_INDEX;
                else if (D_MINs[LAST_INDEX].d < D_MINs[RELABEL_index].d)
                    // update choice to be the closer one!
                    RELABEL_index = LAST_INDEX;
                }
            }
        }

    bool Labeled_New_Vertices = true; // assume we labeled new vertices manifold
    // if the ``main'' vertex was re-chosen
    if (RELABEL_index >= 0)
        {
        // then only need to return that one!
        D_MIN_STRUCT  D_MINs_relabel = D_MINs[RELABEL_index];
        D_MINs.clear();
        D_MINs.push_back(D_MINs_relabel);

        Labeled_New_Vertices = false; // we did NOT label any new vertices
        }

    return Labeled_New_Vertices;
}
/***************************************************************************************/


/***************************************************************************************/
/* Execute Find Long Edges With One Manifold End Point: this finds the indices of
     the global long edges that have 1 end point labeled manifold.
     Note: at this point, the manifold vertex labeling has already completed!
     NOTE: the stored indices are in the MATLAB style!
*/
void MGA::Find_Long_Edges_With_Manifold_End_Points()
{
    const unsigned int Num_Long_Edges = bcc_mesh->edge.long0.Get_Num_Rows();

    // guess the size
    const unsigned int Estimate_Size = (unsigned int) (Num_Long_Edges / 2);
    long_edge_indices_both_manifold.clear();
    long_edge_indices_both_manifold.reserve(Estimate_Size);
    long_edge_indices_one_manifold.clear();
    long_edge_indices_one_manifold.reserve(Estimate_Size);

    // loop through all (global) long edges
    for (unsigned int i = 1; i <= Num_Long_Edges; i++)
        {
        // get vertex indices of the long edge
        unsigned int V1, V2;
        bcc_mesh->Get_Vertex_Indices_Of_Long_Edge(i-1, V1, V2);

        // are they manifold
        const bool V1_IS_MANIFOLD = manifold.vtx_mask[V1-1];
        const bool V2_IS_MANIFOLD = manifold.vtx_mask[V2-1];

        // record the global long edge index if it has BOTH manifold end points
        if ( (V1_IS_MANIFOLD) && (V2_IS_MANIFOLD) )
            long_edge_indices_both_manifold.push_back(i); // MATLAB indexing
        // record the global long edge index if it has ONLY ONE manifold end point
        else if ( (V1_IS_MANIFOLD) || (V2_IS_MANIFOLD) )
            long_edge_indices_one_manifold.push_back(i); // MATLAB indexing
        }
}
/***************************************************************************************/


/* AMBIGUOUS TRI ROUTINES */


/***************************************************************************************/
/* This identifies which triangles are ambiguous and what their isolation status is.
*/
void MGA::Find_Isolated_Ambiguous_Tri ()
{
    // loop thru all long edges with both end points manifold (only ones we care about here...)
    for (unsigned int i = 0; i < long_edge_indices_both_manifold.size(); i++)
        {
        // get the triangles attached to the current ``spine''
        const unsigned int edge_index_C_style = (unsigned int) (long_edge_indices_both_manifold[i] - 1);
        ATTACH tri_pair;
        bcc_mesh->Get_Long_Edge_Attachments(edge_index_C_style, tri_pair);

        unsigned int num_amb_tri = 0;
        unsigned int amb_tri_index[2] = {0,0};
        // loop through the attached tris
        for (unsigned int pi = 0; pi < tri_pair.num; pi++)
            {
            const unsigned int current_tri_index = tri_pair.indices[pi]; // MATLAB style indexing
            // read triangle vertex indices
            unsigned int tri_data[3];
            bcc_mesh->Get_Triangle_Indices(current_tri_index, tri_data);

            // identify the ones that are manifold
            const bool V1_IS_MANIFOLD = manifold.vtx_mask[tri_data[0] - 1];
            const bool V2_IS_MANIFOLD = manifold.vtx_mask[tri_data[1] - 1];
            const bool V3_IS_MANIFOLD = manifold.vtx_mask[tri_data[2] - 1];
            if ( (V1_IS_MANIFOLD) && (V2_IS_MANIFOLD) && (V3_IS_MANIFOLD) )
                {
                amb_tri_index[num_amb_tri] = current_tri_index;
                num_amb_tri++; // keep track of number of ambiguous triangles around the current ``spine''
                }
            }
        // if there are NO ambiguous tris, then nothing needs to be done

        // if there is only ONE ambiguous tri...
        if (num_amb_tri==1)
            {
            // and it was not previously recorded as being ambiguous and NOT isolated
            // i.e. it is not part of an ambiguous pair or group of tris
            if (ambiguous_tri_status[amb_tri_index[0] - 1] < 2)
                // then record (tentatively) that it is isolated ambiguous
                ambiguous_tri_status[amb_tri_index[0] - 1] = 1;
            }
        else if (num_amb_tri > 1)
            {
            // then mark all the ambiguous tris as being NOT isolated
            for (unsigned int ai = 0; ai < num_amb_tri; ai++)
                ambiguous_tri_status[amb_tri_index[ai] - 1] = 2;
            }
        }

    // compute number of ambiguous tris and the number of isolated ones.
    //unsigned int TOTAL_AMB = 0;
    unsigned int TOTAL_ISOLATED_AMB = 0;
    std::vector<unsigned int>  Amb_Indices;
    Amb_Indices.reserve(ambiguous_tri_status.size());
    for (unsigned int ti = 0; ti < ambiguous_tri_status.size(); ti++)
        {
        if (ambiguous_tri_status[ti] > 0) // tri is ambiguous
            Amb_Indices.push_back(ti+1);  // MATLAB indexing
        if (ambiguous_tri_status[ti]==1)  // moreover, it is isolated
            TOTAL_ISOLATED_AMB++;
        }
    // output
    mexPrintf("\n");
    mexPrintf("Finished Identifying Ambiguous Triangles...\n");
    mexPrintf("         Total Number is: %d.\n",Amb_Indices.size());
    mexPrintf("         Number of *isolated* ambiguous triangles is: %d.\n",TOTAL_ISOLATED_AMB);
    // allocate output array for the ambiguous tri indices
    mxOutAmbIndices = mxCreateDoubleMatrix((mwSize) Amb_Indices.size(), (mwSize) 1, mxREAL);
    double* Amb_Ind = mxGetPr(mxOutAmbIndices);
    // copy over
    for (unsigned int k = 0; k < Amb_Indices.size(); k++)
        Amb_Ind[k] = (double) Amb_Indices[k];
}
/***************************************************************************************/


/* EDGE FLIP ROUTINES */


/***************************************************************************************/
/* Execute Edge Flips: perform several long edge flips of spines within
     octahedral groups.
*/
void MGA::Perform_Edge_Flips()
{
    Flip_Active_Cut_Long_Edges();

    Flip_Long_Edges_With_One_Manifold_Point();
}
/***************************************************************************************/


/***************************************************************************************/
/* This defines the standard and alternate slices when making a quadrilateral edge flip */

// edge connecting V1-V2 (standard slice)
void Make_STD_Slice (const unsigned int  quad_vtx_indices[4],   // inputs
                     TRI_PAIR_DATA_STRUCT&    tri_pair_data)    // outputs
{
    // convenient refs...
    const unsigned int& V1 = quad_vtx_indices[0];
    const unsigned int& V2 = quad_vtx_indices[1];
    const unsigned int& V3 = quad_vtx_indices[2];
    const unsigned int& V4 = quad_vtx_indices[3];

    // T_1: {V1, V2, V3};
    tri_pair_data.tri1_data[0] = V1;
    tri_pair_data.tri1_data[1] = V2;
    tri_pair_data.tri1_data[2] = V3;

    // T_2: {V2, V1, V4};
    tri_pair_data.tri2_data[0] = V2;
    tri_pair_data.tri2_data[1] = V1;
    tri_pair_data.tri2_data[2] = V4;
}

// edge connecting V3-V4
void Make_Alternate_Slice (const unsigned int  quad_vtx_indices[4],  // inputs
                           TRI_PAIR_DATA_STRUCT&    tri_pair_data)   // outputs
{
    // convenient refs...
    const unsigned int& V1 = quad_vtx_indices[0];
    const unsigned int& V2 = quad_vtx_indices[1];
    const unsigned int& V3 = quad_vtx_indices[2];
    const unsigned int& V4 = quad_vtx_indices[3];

    // T_1: {V4, V3, V1};
    tri_pair_data.tri1_data[0] = V4;
    tri_pair_data.tri1_data[1] = V3;
    tri_pair_data.tri1_data[2] = V1;

    // T_2: {V3, V4, V2};
    tri_pair_data.tri2_data[0] = V3;
    tri_pair_data.tri2_data[1] = V4;
    tri_pair_data.tri2_data[2] = V2;
}
/***************************************************************************************/


/***************************************************************************************/
/* this flips the active cut long edges */
void MGA::Flip_Active_Cut_Long_Edges()
{
    // loop thru all cut long edges
    unsigned int COUNT = 0;
    for (unsigned int i = 0; i < cut_info->long0.num_cut_edge; i++)
        {
        // if a cut long edge (spine) IS active
        if (manifold.long_cut_edge_active[i])
            {
            COUNT++;
            // then we MUST do an edge-flip

            // get the triangles attached to the current ``spine''
            unsigned int edge_index_C_style = (unsigned int) (cut_info->long0.edge_indices[i] - 1);
            ATTACH tri_pair;
            bcc_mesh->Get_Long_Edge_Attachments(edge_index_C_style, tri_pair);

            // ignore edges (spines) on the boundary of the BCC mesh
            if (tri_pair.num==2)
                {
                // get the vertices of the quadrilateral in a well-defined order
                unsigned int quad_vtx_indices[4];
                Get_Arranged_Quadrilateral_Vertex_Indices(edge_index_C_style, tri_pair, quad_vtx_indices);

                // define alternate slice
                TRI_PAIR_DATA_STRUCT  Slice;
                Make_Alternate_Slice(quad_vtx_indices, Slice);

                // flip it!
                Overwrite_New_Pair_Data(tri_pair.indices, Slice);
                }
            }
        }
    mexPrintf("\n");
    mexPrintf("Finished flipping active cut long edges.  Number flipped is %d.\n",COUNT);
}
/***************************************************************************************/


/***************************************************************************************/
/* this applies the additional edge-flip policy to long edges that have one
   end-point labeled manifold.
*/
void MGA::Flip_Long_Edges_With_One_Manifold_Point()
{
    // loop thru the long edges (with one end point manifold)
    unsigned int COUNT = 0;
    for (unsigned int i = 0; i < long_edge_indices_one_manifold.size(); i++)
        {
        // get the triangles attached to the current ``spine''
        unsigned int edge_index_C_style = (unsigned int) (long_edge_indices_one_manifold[i] - 1);
        ATTACH tri_pair;
        bcc_mesh->Get_Long_Edge_Attachments(edge_index_C_style, tri_pair);

        // ignore edges (spines) on the boundary of the BCC mesh
        if (tri_pair.num==2) // we need a full quadrilateral
            {
            // get the vertices of the quadrilateral in a regular order
            unsigned int quad_vtx_indices[4];
            Get_Arranged_Quadrilateral_Vertex_Indices(edge_index_C_style, tri_pair, quad_vtx_indices);

            // can we try a flip?
            const bool Flip_Is_Valid = One_Manifold_Long_Edge_Flip_Valid(quad_vtx_indices);
            if (Flip_Is_Valid)
                {
                const bool QUAD_CHANGED = Do_22_Edge_Flip_One_Manifold_Long_Edge(tri_pair, quad_vtx_indices);
                if (QUAD_CHANGED) COUNT++; // flipped another long edge
                }
            }
        }
    mexPrintf("\n");
    mexPrintf("Finished additional edge-flips for long edges (w/ one manifold end point).\n");
    mexPrintf("         Number flipped is %d.\n",COUNT);
}
/***************************************************************************************/


/***************************************************************************************/
/* this determines if the given quadrilateral has one manifold end point on the
   long edge (spine) and whether it is possible to flip it.
   (v_1,v_2) is the spine.
*/
bool MGA::One_Manifold_Long_Edge_Flip_Valid (const unsigned int  quad_vtx_ind[4])
{
    bool VALID = false; // flip is not valid

    // convenient refs... (in MATLAB-style indexing!)
    const unsigned int& V1 = quad_vtx_ind[0];
    const unsigned int& V2 = quad_vtx_ind[1];
    const unsigned int& V3 = quad_vtx_ind[2];
    const unsigned int& V4 = quad_vtx_ind[3];

    // get manifold status at each of the (outer) ring vertices
    const bool man_V1 = manifold.vtx_mask[V1-1];
    const bool man_V2 = manifold.vtx_mask[V2-1];
    const bool man_V3 = manifold.vtx_mask[V3-1];
    const bool man_V4 = manifold.vtx_mask[V4-1];

    // determine the configuration
    const bool spine_has_one_manifold_point   = ( (man_V1) && (!man_V2) ) || ( (!man_V1) && (man_V2) );
    const bool only_one_outer_vtx_is_manifold = ( (man_V3) && (!man_V4) ) || ( (!man_V3) && (man_V4) );

    // if the spine has ONE manifold end point, and only one outer vertex is manifold
    if ( (spine_has_one_manifold_point) && (only_one_outer_vtx_is_manifold) )
        VALID = true; // then we can flip!

    return VALID;
}
/***************************************************************************************/


/***************************************************************************************/
/* This returns a special ordering of the triangle vertex indices.
   Note: this *changes* tri_data!
*/
void Order_Tri_Vtx (const unsigned int spine_indices[2], const unsigned int tri_data[3],
                          unsigned int tri_data_ordered[3])
{
    // make some convenient refs
    const unsigned int& S1 = spine_indices[0];
    const unsigned int& S2 = spine_indices[1];
    const unsigned int& V1 = tri_data[0];
    const unsigned int& V2 = tri_data[1];
    const unsigned int& V3 = tri_data[2];

    // proceed with massive if-then statement...
    if (S1==V1)
        {
        if (S2==V2) // e3
            {
            tri_data_ordered[0] = V1;
            tri_data_ordered[1] = V2;
            tri_data_ordered[2] = V3;
            }
        else if (S2==V3) // -e2
            {
            tri_data_ordered[0] = V3;
            tri_data_ordered[1] = V1;
            tri_data_ordered[2] = V2;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tri_Vtx'.");
        }
    else if (S1==V2)
        {
        if (S2==V1) // -e3
            {
            tri_data_ordered[0] = V1;
            tri_data_ordered[1] = V2;
            tri_data_ordered[2] = V3;
            }
        else if (S2==V3) // e1
            {
            tri_data_ordered[0] = V2;
            tri_data_ordered[1] = V3;
            tri_data_ordered[2] = V1;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tri_Vtx'.");
        }
    else if (S1==V3)
        {
        if (S2==V1) // e2
            {
            tri_data_ordered[0] = V3;
            tri_data_ordered[1] = V1;
            tri_data_ordered[2] = V2;
            }
        else if (S2==V2) // -e1
            {
            tri_data_ordered[0] = V2;
            tri_data_ordered[1] = V3;
            tri_data_ordered[2] = V1;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tri_Vtx'.");
        }
    else
        mexErrMsgTxt("ERROR: see 'Order_Tri_Vtx'.");
}
/***************************************************************************************/


/***************************************************************************************/
/* This gets the vertices of a given quadrilateral in a pre-defined arranged order.
   The quadrilateral consists of a given spine (edge) and the 2 attached
   triangle indices.
   Note: spine_edge_index is in C-style.
*/
void MGA::Get_Arranged_Quadrilateral_Vertex_Indices (const unsigned int& spine_edge_index,     // inputs
                                                     const ATTACH&       tri_pair,             // inputs
                                                     unsigned int        quad_vtx_indices[4])  // outputs
{
    // error check
    if (tri_pair.num!=2) mexErrMsgTxt("Quadrilateral does not consist of 2 triangles!  This should not happen!  See 'Get_Arranged_Quadrilateral_Vertex_Indices'.");

    // get spine vertex indices
    unsigned int spine_indices[2];
    bcc_mesh->Get_Vertex_Indices_Of_Long_Edge(spine_edge_index, spine_indices[0], spine_indices[1]);

    // get the vertex indices of both triangles
    // actually, MATLAB orders these attachments, so why not take advantage!
    unsigned int tri1_data[3];
    unsigned int tri2_data[3];
    bcc_mesh->Get_Triangle_Indices(tri_pair.indices[0], tri1_data);
    bcc_mesh->Get_Triangle_Indices(tri_pair.indices[1], tri2_data);

    // order the vertices of each individual tri
    unsigned int tri1_data_ordered[3];
    unsigned int tri2_data_ordered[3];
    Order_Tri_Vtx(spine_indices, tri1_data, tri1_data_ordered);
    Order_Tri_Vtx(spine_indices, tri2_data, tri2_data_ordered);

    // output ordered octahedral vertices
    quad_vtx_indices[0] = tri1_data_ordered[0];
    quad_vtx_indices[1] = tri1_data_ordered[1];
    quad_vtx_indices[2] = tri1_data_ordered[2];

    quad_vtx_indices[3] = tri2_data_ordered[2];
}
/***************************************************************************************/


/***************************************************************************************/
/* This is THE edge-flip policy (when there is a choice)
*/
int Edge_Flip_Policy (const double& Min_0, const double& Max_0,
                      const double& Min_1, const double& Max_1)
{
    int INDEX = -1; // init to a NULL value

    // define minimum angle!
    const double Min_Angle_Cutoff_radians = 13.0 * (PI/180); // minimum angle is ???? degrees

    if ( (Min_0 > Min_Angle_Cutoff_radians) && (Min_1 > Min_Angle_Cutoff_radians) )
        {
        // minimize the MAX dihedral angle
        if (Max_0 < Max_1) INDEX = 0;
        else               INDEX = 1;
        }
    else
        {
        // maximize the min dihedral angle
        if (Min_0 > Min_1) INDEX = 0;
        else               INDEX = 1;
        }
    return INDEX;
}
/***************************************************************************************/


/***************************************************************************************/
/* This changes the triangles node data inside a given quadrilateral by performing
     an edge-flip within the given quadrilateral.  This is for the
     additional edge-flip one manifold long edge case.
   Note: the flip is accepted only if the angles are better!  The boolean return
         value indicates this.
*/
bool MGA::Do_22_Edge_Flip_One_Manifold_Long_Edge
                             (const ATTACH&        tri_pair,    // inputs
                              const unsigned int   qdi_ordered[4])
{
    bool QUAD_CHANGED = false; // indicate that we have not changed the topology of the quadrilateral

    TRI_PAIR_DATA_STRUCT  Slice_STD, Slice_Alt;
    Make_STD_Slice(qdi_ordered, Slice_STD); // no-flip case
    Make_Alternate_Slice(qdi_ordered, Slice_Alt); // the flip case

    // compute qualities of Slice STD and Slice B
    double Min_STD, Max_STD, Min_Alt, Max_Alt;
    Compute_MinMax_Dihedral_Angle_of_Tri_Pair
                              (Slice_STD.tri1_data, Slice_STD.tri2_data,
                               Min_STD, Max_STD);
    Compute_MinMax_Dihedral_Angle_of_Tri_Pair
                              (Slice_Alt.tri1_data, Slice_Alt.tri2_data,
                               Min_Alt, Max_Alt);

    // apply long edge flip policy
    const int index_of_choice = Edge_Flip_Policy(Min_STD, Max_STD, Min_Alt, Max_Alt);
    // if the alternate is better...
    if (index_of_choice==1)
        {
        Overwrite_New_Pair_Data(tri_pair.indices, Slice_Alt); // overwrite with Slice Alternate
        QUAD_CHANGED = true; // we changed the topology
        }

    return QUAD_CHANGED;
}
/***************************************************************************************/


/***************************************************************************************/
/* this computes the min/max dihedral angle for the 2 given tri_data's.
*/
void MGA::Compute_MinMax_Dihedral_Angle_of_Tri_Pair (
                        const double  tri1_data[3], const double  tri2_data[3],
                              double& Min_Angle,          double& Max_Angle)
{
    double MinAngs[2], MaxAngs[2];
    Compute_MinMax_Dihedral_Angle(tri1_data, MinAngs[0], MaxAngs[0]);
    Compute_MinMax_Dihedral_Angle(tri2_data, MinAngs[1], MaxAngs[1]);

    // return the min/max
    Min_Angle = *std::min_element(MinAngs, MinAngs+2);
    Max_Angle = *std::max_element(MaxAngs, MaxAngs+2);
}
/***************************************************************************************/


/***************************************************************************************/
/* this computes the min and MAX dihedral angle of the given tri_data.
   Note: the angles calculated are in radians.
*/
void MGA::Compute_MinMax_DotProd (const double tri_data[3], double& Min_DP, double& Max_DP)
{
    // convenient refs...
    const unsigned int V1 = (unsigned int) (tri_data[0] - 1); //  C-style indexing
    const unsigned int V2 = (unsigned int) (tri_data[1] - 1);
    const unsigned int V3 = (unsigned int) (tri_data[2] - 1);

    // get coordinates (must read the destination point!)
    double V1_Coord[2], V2_Coord[2], V3_Coord[2];
    Read_Destination_Point(V1, V1_Coord); // must use C-style indexing here!
    Read_Destination_Point(V2, V2_Coord);
    Read_Destination_Point(V3, V3_Coord);

    // compute edge vectors
    double e1[2], e2[2], e3[2];
    Get_Vec_Difference(V3_Coord, V2_Coord, e1);
    Get_Vec_Difference(V1_Coord, V3_Coord, e2);
    Get_Vec_Difference(V2_Coord, V1_Coord, e3);

    // normalize!
    double e1_n[2], e2_n[2], e3_n[2];
    double e_LEN[3];
    e_LEN[0] = Normalize(e1, e1_n);
    e_LEN[1] = Normalize(e2, e2_n);
    e_LEN[2] = Normalize(e3, e3_n);

    // return the smallest edge length
    const double Min_Edge_Length = *std::min_element(e_LEN,e_LEN+3);

    // compute the 3 dot products
    double DP[3];
    DP[0] = -Dot_Product(e3_n,e2_n);
    DP[1] = -Dot_Product(e1_n,e3_n);
    DP[2] = -Dot_Product(e2_n,e1_n);

    // get min and max!
    Min_DP = *std::min_element(DP,DP+3);
    Max_DP = *std::max_element(DP,DP+3);

    // if the edge length is too small
    if (Min_Edge_Length < 1e-14)
        {
        // then obviously, the dot products must be BAD!
        Min_DP = -1.0; // set to   0 degrees
        Max_DP = +1.0; // set to 180 degrees
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* this computes the min dihedral angle of the given tri_data.
   Note: the angles calculated are in radians.
*/
void MGA::Compute_MinMax_Dihedral_Angle (const double tri_data[3], double& Min_Angle, double& Max_Angle)
{
    double Min_DP, Max_DP;
    Compute_MinMax_DotProd(tri_data, Min_DP, Max_DP);

    // convert dot product to angles
    Min_Angle = Get_Angle(Max_DP); // yes you must flip min and max!
    Max_Angle = Get_Angle(Min_DP);
}
/***************************************************************************************/


/***************************************************************************************/
/* This sets the output matrix mxOutMsk to be a logical indicator array that selects
   which triangles are inside the isosurface (which also indicates which are outside).
*/
void MGA::Choose_Inside_Outside_Tri ()
{
    // loop thru all background mesh triangles
    unsigned int COUNT = 0;
    for (unsigned int ti = 0; ti < Num_BCC_Tri; ti++)
        {
        if (ambiguous_tri_status[ti]==0) // if it is NOT an ambiguous tri
            {
            int tri_sign_data[3];
            Get_Sign_Of_Tri(ti, tri_sign_data);

            // if none of the vertices are negative
            if ( (tri_sign_data[0] >= 0) && (tri_sign_data[1] >= 0) && (tri_sign_data[2] >= 0) )
                {
                // then it must be an *inside* triangle
                tri_in_mask[ti] = true; // true means it is inside
                }
            }
        // else
        // its inside status must be determined back in MATLAB!
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* return signs of vertices of given tri index (tri_ind is in C-style)
   if the vertex is manifold, then the sign is 0.
   else, if the level set value is negative, then sign is -1.
   otherwise, the sign is +1.
*/
void MGA::Get_Sign_Of_Tri (const unsigned int& tri_ind, int tri_sign_data[3])
{
    // loop thru the 3 vertices
    for (unsigned int vi = 0; vi < 3; vi++)
        {
        // read the vertex indices of the given tri
        const unsigned int v_ind_c_style = (unsigned int) (out_tri_data[vi][tri_ind] - 1);
        if (manifold.vtx_mask[v_ind_c_style])
            tri_sign_data[vi] = 0;
        else
            tri_sign_data[vi] = LS_SIGN(level_set_values_at_vtx[v_ind_c_style]);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* return list of indices (C-style) of manifold vertices
   SWW: never been tested!
*/
void MGA::Get_Manifold_Vtx_Indices (std::vector<unsigned int>& Manifold_Indices)
{
    const unsigned int NUM_CUT = cut_info->long0.num_cut_edge + cut_info->short0.num_cut_edge;
    Manifold_Indices.clear();
    Manifold_Indices.reserve(2 * NUM_CUT);

    // loop thru the manifold vertex labeling
    for (unsigned int vi = 0; vi < manifold.vtx_mask.size(); vi++)
        {
        if (manifold.vtx_mask[vi]) // if the vertex is manifold, then add it to the list
            Manifold_Indices.push_back(vi);
        }
}
/***************************************************************************************/

#undef MGA

/***/
