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
    unsigned int attached_short_cut_edges[8];
    unsigned int attached_long_cut_edges[6];
} D_MIN_STRUCT;
/***************************************************************************************/

/***************************************************************************************/
/* struct containing tet connectivity data for the 4 tetrahedra in an octahedron */
typedef struct {
    double tet1_data[4];
    double tet2_data[4];
    double tet3_data[4];
    double tet4_data[4];
} OCT_DATA_STRUCT;
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
    void Find_Isolated_Ambiguous_Tets ();
    void Perform_Edge_Flips ();
    void Choose_Inside_Outside_Tets ();

    mxArray* mxOutVtx;   // for outputting to MATLAB
    mxArray* mxOutTet;   // for outputting to MATLAB
    mxArray* mxOutInMsk; // for outputting to MATLAB
    mxArray* mxOutAmbIndices; // for outputting to MATLAB

private:

    // basic info about background mesh
    unsigned int                Num_BCC_Vtx;               // number of vertices in the BCC mesh
    unsigned int                Num_BCC_Tet;               // number of tets in the BCC mesh

    typedef struct
    {
        std::vector<bool>           short_cut_edge_active; // Nx1 array of T/F where N is the number of short cut edges
        std::vector<bool>            long_cut_edge_active; // Mx1 array of T/F where M is the number of long  cut edges
                                                           // N,M correspond to the number of short and long cut edges
                                                           //     in "CUT_Info_Class".
        std::vector<bool>           vtx_mask;              // logical array indicating which vertices are manifold
                                                           //     i.e. which vertices will lie on the surface
        double*                     dest_pt[3];            // pointer to new vertex positions of the BCC mesh
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

    // data for output tetrahedra
    double*                     out_tet_data[4];       // pointer to new tet data for the background mesh
    mxLogical*                  tet_in_mask;           // pointer to the inside/outside labeling for the new tetrahedra

    // keep track of decomposition of long edges
    std::vector<unsigned int>   long_edge_indices_both_manifold;
    std::vector<unsigned int>   long_edge_indices_one_manifold;

    // keep track of the ambiguity status of all the tetrahedra
    std::vector<unsigned int>   ambiguous_tet_status; // status  0: not ambiguous
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

    void Overwrite_Destination_Point (const unsigned int& VI, const double NP[3]);
    void Read_Destination_Point (const unsigned int& VI, double Dest[3]);
    void Overwrite_New_Tet_Data (const unsigned int& TI, const double NTD[4]);
    void Overwrite_New_Oct_Data (const unsigned int ti[4], const OCT_DATA_STRUCT& O);
    D_MIN_STRUCT Get_d_min_Over_Edge (const unsigned int&, const unsigned int&);
    D_MIN_STRUCT Get_d_min_At_Vertex (const unsigned int&);
    void Compute_Min_Over_Short_Active_Cut_Edge (const unsigned int& local_edge_index,
                                                 const double Vtx_Coord[3], D_MIN_STRUCT& d_min);
    unsigned int Get_Opposite_Vertex_Index_On_Short_Edge (const unsigned int&, const unsigned int&);
    unsigned int Get_Opposite_Vertex_Index_On_Long_Edge  (const unsigned int&, const unsigned int&);

    bool BL_Single_Pass ();
    bool BL_Get_d_min_Over_Short_Edges (const D_MIN_STRUCT&, std::vector<D_MIN_STRUCT>&);

    void Get_Arranged_Octahedra_Vertex_Indices (const unsigned int& s, const ATTACH& ot, unsigned int ov[6]);
    void Flip_Active_Cut_Long_Edges ();

    void Flip_Long_Edges_With_One_Manifold_Point ();
    void Order_Octahedron_Vertices_For_Additional_Edge_Flip (const unsigned int  OLD[6],
                                                                   unsigned int  NEW[6],
                                                                            int& info);
    bool Compute_Octahedron_Warping_Configuration(const unsigned int ovi[6]);

//     bool Is_NonCut_Long_Edge_With_One_Manifold_Point_Available (const unsigned int ov[6], bool& A, bool& B);

    void Do_44_Edge_Flip_Active_Cut_Long_Edge (const ATTACH&, OCT_DATA_STRUCT&, OCT_DATA_STRUCT&);
    bool Do_44_Edge_Flip_One_Manifold_Long_Edge (const ATTACH&, const unsigned int  ovi_o[6], const int&);

    void Compute_MinMax_Dihedral_Angle_of_Four_Tets (const double t1[4], const double t2[4],
                                                     const double t3[4], const double t4[4],
                                                     double& min, double& max);
    void Compute_MinMax_DotProd (const double td[4], double& min, double& max);
    void Compute_MinMax_Dihedral_Angle (const double td[4], double& min, double& max);

    void Get_Sign_Of_Tet (const unsigned int& ti, int tsd[4]);
    void Get_Manifold_Vtx_Indices (std::vector<unsigned int>&);

};

/***************************************************************************************/
/* constructor */
MGA::MGA ()
{
    // init
    mxOutVtx = NULL;
    mxOutTet = NULL;
    mxOutInMsk = NULL;
    mxOutAmbIndices = NULL;
    Num_BCC_Vtx = 0;
    Num_BCC_Tet = 0;
    level_set_values_at_vtx = NULL;
    bcc_mesh = NULL;
    cut_info = NULL;
    manifold.short_cut_edge_active.clear();
    manifold.long_cut_edge_active.clear();
    manifold.vtx_mask.clear();
    manifold.dest_pt[0] = NULL;
    manifold.dest_pt[1] = NULL;
    manifold.dest_pt[2] = NULL;
    out_tet_data[0] = NULL;
    out_tet_data[1] = NULL;
    out_tet_data[2] = NULL;
    out_tet_data[3] = NULL;
    tet_in_mask = NULL;
    manifold.moving_toward.clear();
    long_edge_indices_both_manifold.clear();
    long_edge_indices_one_manifold.clear();
    ambiguous_tet_status.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* destructor */
MGA::~MGA ()
{
    mxOutVtx = NULL;
    mxOutTet = NULL;
    mxOutInMsk = NULL;
    mxOutAmbIndices = NULL;
    Num_BCC_Vtx = 0;
    Num_BCC_Tet = 0;
    level_set_values_at_vtx = NULL;
    bcc_mesh = NULL;
    cut_info = NULL;
    manifold.short_cut_edge_active.clear();
    manifold.long_cut_edge_active.clear();
    manifold.vtx_mask.clear();
    manifold.dest_pt[0] = NULL;
    manifold.dest_pt[1] = NULL;
    manifold.dest_pt[2] = NULL;
    out_tet_data[0] = NULL;
    out_tet_data[1] = NULL;
    out_tet_data[2] = NULL;
    out_tet_data[3] = NULL;
    tet_in_mask = NULL;
    manifold.moving_toward.clear();
    long_edge_indices_both_manifold.clear();
    long_edge_indices_one_manifold.clear();
    ambiguous_tet_status.clear();
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
    for (unsigned int i = 1; (i < 3); i++)
        manifold.dest_pt[i] = manifold.dest_pt[i-1] + Num_BCC_Vtx;

    // duplicate tet data
    mxOutTet = mxDuplicateArray(bcc_mesh->mxTet);
    // access tet data
    Num_BCC_Tet = (unsigned int) mxGetM(mxOutTet);
    out_tet_data[0] = (double*) mxGetPr(mxOutTet);
    for (unsigned int i = 1; (i < 4); i++)
        out_tet_data[i] = out_tet_data[i-1] + Num_BCC_Tet;

    // init data for output mask that selects inside/outside tetrahedra
    dims[0] = (mwSize) Num_BCC_Tet;
    dims[1] = (mwSize) 1;
    mxOutInMsk = mxCreateLogicalArray((mwSize) 2, dims);
    tet_in_mask = mxGetLogicals(mxOutInMsk);
    // this is automatically initialized to all false (all outside!)

    // init structure for indicating vertex indices that a manifold vertex moves toward
    manifold.moving_toward.resize(Num_BCC_Vtx);
    manifold.moving_toward.assign(Num_BCC_Vtx,0); // init to all zero (because no vertices are manifold)

    // init array for storing ambiguous tet indices
    ambiguous_tet_status.resize(Num_BCC_Tet);
    ambiguous_tet_status.assign(Num_BCC_Tet,0); // init to all 0 (default value)
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
        double Destination_Point[3];
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
    double Vtx_Coord[3];
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
void MGA::Overwrite_Destination_Point (const unsigned int& Vtx_Index, const double New_Point[3])
{
    manifold.dest_pt[0][Vtx_Index] = New_Point[0];
    manifold.dest_pt[1][Vtx_Index] = New_Point[1];
    manifold.dest_pt[2][Vtx_Index] = New_Point[2];
}
/***************************************************************************************/


/***************************************************************************************/
/* read destination point coordinates (at a single index).
   note: Vtx_Index is already in the C-style indexing.
*/
void MGA::Read_Destination_Point (const unsigned int& Vtx_Index, double Dest_Point[3])
{
    Dest_Point[0] = manifold.dest_pt[0][Vtx_Index];
    Dest_Point[1] = manifold.dest_pt[1][Vtx_Index];
    Dest_Point[2] = manifold.dest_pt[2][Vtx_Index];
}
/***************************************************************************************/


/***************************************************************************************/
/* change (new) tetrahedral data (at a single index).
   note: Tet_Index is already in the C-style indexing.
*/
void MGA::Overwrite_New_Tet_Data (const unsigned int& Tet_Index, const double New_Tet_Data[4])
{
    // note: Tet_Index is already in the C-style indexing
    out_tet_data[0][Tet_Index] = New_Tet_Data[0];
    out_tet_data[1][Tet_Index] = New_Tet_Data[1];
    out_tet_data[2][Tet_Index] = New_Tet_Data[2];
    out_tet_data[3][Tet_Index] = New_Tet_Data[3];
}
/***************************************************************************************/


/***************************************************************************************/
/* change (new) set of 4 tetrahedra.
   note: tet_indices is in the MATLAB-style indexing.
*/
void MGA::Overwrite_New_Oct_Data (const unsigned int tet_indices[4],
                                  const OCT_DATA_STRUCT& Oct)
{
    Overwrite_New_Tet_Data(tet_indices[0] - 1, Oct.tet1_data);
    Overwrite_New_Tet_Data(tet_indices[1] - 1, Oct.tet2_data);
    Overwrite_New_Tet_Data(tet_indices[2] - 1, Oct.tet3_data);
    Overwrite_New_Tet_Data(tet_indices[3] - 1, Oct.tet4_data);
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
                                                  const double Vtx_Coord[3],  D_MIN_STRUCT& d_min)
{
    double& SHORT_LENGTH = bcc_mesh->short_length;

    // get the cut point coordinates on that edge
    double Cut_Point[3];
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
    D_MINs.reserve(8); // there are only 8 short edges attached to each vertex

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


/* AMBIGUOUS TET ROUTINES */


/***************************************************************************************/
/* This identifies which tetrahedra are ambiguous and what their isolation status is.
*/
void MGA::Find_Isolated_Ambiguous_Tets ()
{
    // loop thru all long edges with both end points manifold (only ones we care about here...)
    for (unsigned int i = 0; i < long_edge_indices_both_manifold.size(); i++)
        {
        // get the tetrahedra attached to the current ``spine''
        const unsigned int edge_index_C_style = (unsigned int) (long_edge_indices_both_manifold[i] - 1);
        ATTACH oct_tets;
        bcc_mesh->Get_Long_Edge_Attachments(edge_index_C_style, oct_tets);

        unsigned int num_amb_tet = 0;
        unsigned int amb_tet_index[4] = {0,0,0,0};
        // loop through the attached tets
        for (unsigned int oi = 0; oi < oct_tets.num; oi++)
            {
            const unsigned int current_tet_index = oct_tets.indices[oi]; // MATLAB style indexing
            // read tetrahedral vertex indices
            unsigned int tet_data[4];
            bcc_mesh->Get_Tetrahedra_Indices(current_tet_index, tet_data);

            // identify the ones that are manifold
            const bool V1_IS_MANIFOLD = manifold.vtx_mask[tet_data[0] - 1];
            const bool V2_IS_MANIFOLD = manifold.vtx_mask[tet_data[1] - 1];
            const bool V3_IS_MANIFOLD = manifold.vtx_mask[tet_data[2] - 1];
            const bool V4_IS_MANIFOLD = manifold.vtx_mask[tet_data[3] - 1];
            if ( (V1_IS_MANIFOLD) && (V2_IS_MANIFOLD) && (V3_IS_MANIFOLD) && (V4_IS_MANIFOLD) )
                {
                amb_tet_index[num_amb_tet] = current_tet_index;
                num_amb_tet++; // keep track of number of ambiguous tetrahedra around the current ``spine''
                }
            }
        // if there are NO ambiguous tets, then nothing needs to be done

        // if there is only ONE ambiguous tet...
        if (num_amb_tet==1)
            {
            // and it was not previously recorded as being ambiguous and NOT isolated
            // i.e. it is not part of an ambiguous pair or group of tets
            if (ambiguous_tet_status[amb_tet_index[0] - 1] < 2)
                // then record (tentatively) that it is isolated ambiguous
                ambiguous_tet_status[amb_tet_index[0] - 1] = 1;
            }
        else if (num_amb_tet > 1)
            {
            // then mark all the ambiguous tets as being NOT isolated
            for (unsigned int ai = 0; ai < num_amb_tet; ai++)
                ambiguous_tet_status[amb_tet_index[ai] - 1] = 2;
            }
        }

    // compute number of ambiguous tets and the number of isolated ones.
    //unsigned int TOTAL_AMB = 0;
    unsigned int TOTAL_ISOLATED_AMB = 0;
    std::vector<unsigned int>  Amb_Indices;
    Amb_Indices.reserve(ambiguous_tet_status.size());
    for (unsigned int ti = 0; ti < ambiguous_tet_status.size(); ti++)
        {
        if (ambiguous_tet_status[ti] > 0) // tet is ambiguous
            Amb_Indices.push_back(ti+1);  // MATLAB indexing
        if (ambiguous_tet_status[ti]==1)  // moreover, it is isolated
            TOTAL_ISOLATED_AMB++;
        }
    // output
    mexPrintf("\n");
    mexPrintf("Finished Identifying Ambiguous Tetrahedra...\n");
    mexPrintf("         Total Number is: %d.\n",Amb_Indices.size());
    mexPrintf("         Number of *isolated* ambiguous tetrahedra is: %d.\n",TOTAL_ISOLATED_AMB);
    // allocate output array for the ambiguous tet indices
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
/* This defines the standard, "A", and "B" slices when making an octahedral edge flip */

// edge connecting V1-V2 (standard slice)
void Make_STD_Slice (const unsigned int  oct_vtx_indices[6],   // inputs
                     OCT_DATA_STRUCT&    oct_tet_data)         // outputs
{
    // convenient refs...
    const unsigned int& V1 = oct_vtx_indices[0];
    const unsigned int& V2 = oct_vtx_indices[1];
    const unsigned int& V3 = oct_vtx_indices[2];
    const unsigned int& V4 = oct_vtx_indices[3];
    const unsigned int& V5 = oct_vtx_indices[4];
    const unsigned int& V6 = oct_vtx_indices[5];

    // T_1: {V1, V2, V3, V4};
    oct_tet_data.tet1_data[0] = V1;
    oct_tet_data.tet1_data[1] = V2;
    oct_tet_data.tet1_data[2] = V3;
    oct_tet_data.tet1_data[3] = V4;

    // T_2: {V1, V2, V4, V5};
    oct_tet_data.tet2_data[0] = V1;
    oct_tet_data.tet2_data[1] = V2;
    oct_tet_data.tet2_data[2] = V4;
    oct_tet_data.tet2_data[3] = V5;

    // T_3: {V1, V2, V5, V6};
    oct_tet_data.tet3_data[0] = V1;
    oct_tet_data.tet3_data[1] = V2;
    oct_tet_data.tet3_data[2] = V5;
    oct_tet_data.tet3_data[3] = V6;

    // T_4: {V1, V2, V6, V3};
    oct_tet_data.tet4_data[0] = V1;
    oct_tet_data.tet4_data[1] = V2;
    oct_tet_data.tet4_data[2] = V6;
    oct_tet_data.tet4_data[3] = V3;
}

// edge connecting V3-V5 (slice "A")
void Make_A_Slice (const unsigned int  oct_vtx_indices[6],   // inputs
                   OCT_DATA_STRUCT&    oct_tet_data)         // outputs
{
    // convenient refs...
    const unsigned int& V1 = oct_vtx_indices[0];
    const unsigned int& V2 = oct_vtx_indices[1];
    const unsigned int& V3 = oct_vtx_indices[2];
    const unsigned int& V4 = oct_vtx_indices[3];
    const unsigned int& V5 = oct_vtx_indices[4];
    const unsigned int& V6 = oct_vtx_indices[5];

    // T_1: {V3, V4, V5, V2};
    oct_tet_data.tet1_data[0] = V3;
    oct_tet_data.tet1_data[1] = V4;
    oct_tet_data.tet1_data[2] = V5;
    oct_tet_data.tet1_data[3] = V2;

    // T_2: {V3, V5, V6, V2};
    oct_tet_data.tet2_data[0] = V3;
    oct_tet_data.tet2_data[1] = V5;
    oct_tet_data.tet2_data[2] = V6;
    oct_tet_data.tet2_data[3] = V2;

    // T_3: {V3, V5, V4, V1};
    oct_tet_data.tet3_data[0] = V3;
    oct_tet_data.tet3_data[1] = V5;
    oct_tet_data.tet3_data[2] = V4;
    oct_tet_data.tet3_data[3] = V1;

    // T_4: {V3, V6, V5, V1};
    oct_tet_data.tet4_data[0] = V3;
    oct_tet_data.tet4_data[1] = V6;
    oct_tet_data.tet4_data[2] = V5;
    oct_tet_data.tet4_data[3] = V1;
}

// edge connecting V4-V6 (slice "B")
void Make_B_Slice (const unsigned int  oct_vtx_indices[6],   // inputs
                   OCT_DATA_STRUCT&    oct_tet_data)         // outputs
{
    // convenient refs...
    const unsigned int& V1 = oct_vtx_indices[0];
    const unsigned int& V2 = oct_vtx_indices[1];
    const unsigned int& V3 = oct_vtx_indices[2];
    const unsigned int& V4 = oct_vtx_indices[3];
    const unsigned int& V5 = oct_vtx_indices[4];
    const unsigned int& V6 = oct_vtx_indices[5];

    // T_1: {V6, V3, V4, V2};
    oct_tet_data.tet1_data[0] = V6;
    oct_tet_data.tet1_data[1] = V3;
    oct_tet_data.tet1_data[2] = V4;
    oct_tet_data.tet1_data[3] = V2;

    // T_2: {V6, V4, V5, V2};
    oct_tet_data.tet2_data[0] = V6;
    oct_tet_data.tet2_data[1] = V4;
    oct_tet_data.tet2_data[2] = V5;
    oct_tet_data.tet2_data[3] = V2;

    // T_3: {V6, V4, V3, V1};
    oct_tet_data.tet3_data[0] = V6;
    oct_tet_data.tet3_data[1] = V4;
    oct_tet_data.tet3_data[2] = V3;
    oct_tet_data.tet3_data[3] = V1;

    // T_4: {V6, V5, V4, V1};
    oct_tet_data.tet4_data[0] = V6;
    oct_tet_data.tet4_data[1] = V5;
    oct_tet_data.tet4_data[2] = V4;
    oct_tet_data.tet4_data[3] = V1;
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

            // get the tetrahedra attached to the current ``spine''
            unsigned int edge_index_C_style = (unsigned int) (cut_info->long0.edge_indices[i] - 1);
            ATTACH oct_tets;
            bcc_mesh->Get_Long_Edge_Attachments(edge_index_C_style, oct_tets);

            // ignore edges (spines) on the boundary of the BCC mesh
            if (oct_tets.num==4)
                {
                // get the vertices of the octahedron in a well-defined order
                unsigned int oct_vtx_indices[6];
                Get_Arranged_Octahedra_Vertex_Indices(edge_index_C_style, oct_tets, oct_vtx_indices);

                // define two possible slices
                const unsigned int Num_Slice = 2;
                OCT_DATA_STRUCT  Slice[Num_Slice];
                Make_A_Slice(oct_vtx_indices, Slice[0]);
                Make_B_Slice(oct_vtx_indices, Slice[1]);

                // flip it!   flip it good...
                Do_44_Edge_Flip_Active_Cut_Long_Edge(oct_tets, Slice[0], Slice[1]);
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
        // get the tetrahedra attached to the current ``spine''
        unsigned int edge_index_C_style = (unsigned int) (long_edge_indices_one_manifold[i] - 1);
        ATTACH oct_tets;
        bcc_mesh->Get_Long_Edge_Attachments(edge_index_C_style, oct_tets);

        // ignore edges (spines) on the boundary of the BCC mesh
        if (oct_tets.num==4) // we need a full octahedron
            {
            // get the vertices of the octahedron in a regular order
            unsigned int oct_vtx_indices[6];
            Get_Arranged_Octahedra_Vertex_Indices(edge_index_C_style, oct_tets, oct_vtx_indices);

            // make the ordering match Figure 7 in the paper!
            unsigned int ovi_ordered[6];
            int info;
            Order_Octahedron_Vertices_For_Additional_Edge_Flip(oct_vtx_indices, ovi_ordered, info);

            // if the manifold labeling indicates a POSSIBLE edge-flip
            if (info > -1)
                {
                const bool OCT_CHANGED = Do_44_Edge_Flip_One_Manifold_Long_Edge(oct_tets, ovi_ordered, info);
                if (OCT_CHANGED) COUNT++; // flipped another long edge
                }
            }
        }
    mexPrintf("\n");
    mexPrintf("Finished additional edge-flips for long edges (w/ one manifold end point).\n");
    mexPrintf("         Number flipped is %d.\n",COUNT);
}
/***************************************************************************************/


/***************************************************************************************/
/* this orders the octahedron so that:
   v_1 = not manifold
   v_2 = IS manifold
   v_3 = IS manifold
   v_4 = IS manifold
   v_5 = *maybe* manifold
   v_6 = not manifold
   This if for matching Figure 7 in the paper.
   It also returns an integer that provides the following information:
   oct_info:
   -1 = no need to flip (manifold labeling does not match pattern above)
    0 = can flip with either Slice (only 3 manifold vertices in octahedron)
    1 = can only flip with Slice B (there are 4 manifold vertices in octahedron)
*/
void MGA::Order_Octahedron_Vertices_For_Additional_Edge_Flip
                             (const unsigned int  oct_vtx_ind_OLD[6],
                                    unsigned int  oct_vtx_ind_NEW[6],
                                             int& oct_info)
{
    // convenient refs... (in MATLAB-style indexing!)
    const unsigned int& V1 = oct_vtx_ind_OLD[0];
    const unsigned int& V2 = oct_vtx_ind_OLD[1];
    const unsigned int& V3 = oct_vtx_ind_OLD[2];
    const unsigned int& V4 = oct_vtx_ind_OLD[3];
    const unsigned int& V5 = oct_vtx_ind_OLD[4];
    const unsigned int& V6 = oct_vtx_ind_OLD[5];

    // get manifold status at each of the (outer) ring vertices
    const bool man_V1 = manifold.vtx_mask[V1-1];
    const bool man_V2 = manifold.vtx_mask[V2-1];
    const bool man_V3 = manifold.vtx_mask[V3-1];
    const bool man_V4 = manifold.vtx_mask[V4-1];
    const bool man_V5 = manifold.vtx_mask[V5-1];
    const bool man_V6 = manifold.vtx_mask[V6-1];

    // compute the number of outer ring manifold vertices
    unsigned int num_outer_ring_manifold = 0;
    if (man_V3) num_outer_ring_manifold++;
    if (man_V4) num_outer_ring_manifold++;
    if (man_V5) num_outer_ring_manifold++;
    if (man_V6) num_outer_ring_manifold++;

    unsigned int ovi_temp[6]; // in between storage!

    if ( (num_outer_ring_manifold < 2) || (num_outer_ring_manifold==4) ) // there are too few or too many manifold vtx!
        oct_info = -1; // cannot flip!
    else if (num_outer_ring_manifold==2) // just 2 manifold vertices
        {
        // if there is a consecutive pair of manifold vertices, then we can flip
        if ( (man_V3) && (man_V4) )
            {
            oct_info = 0; // can flip with either slice
            // nothing to do... just copy over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            ovi_temp[2] = oct_vtx_ind_OLD[2]; // V3
            ovi_temp[3] = oct_vtx_ind_OLD[3]; // V4
            ovi_temp[4] = oct_vtx_ind_OLD[4]; // V5
            ovi_temp[5] = oct_vtx_ind_OLD[5]; // V6
            }
        else if ( (man_V4) && (man_V5) )
            {
            oct_info = 0; // can flip with either slice
            // copy spine over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            // shift!
            ovi_temp[2] = oct_vtx_ind_OLD[3]; // V4
            ovi_temp[3] = oct_vtx_ind_OLD[4]; // V5
            ovi_temp[4] = oct_vtx_ind_OLD[5]; // V6
            ovi_temp[5] = oct_vtx_ind_OLD[2]; // V3
            }
        else if ( (man_V5) && (man_V6) )
            {
            oct_info = 0; // can flip with either slice
            // copy spine over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            // shift!
            ovi_temp[2] = oct_vtx_ind_OLD[4]; // V5
            ovi_temp[3] = oct_vtx_ind_OLD[5]; // V6
            ovi_temp[4] = oct_vtx_ind_OLD[2]; // V3
            ovi_temp[5] = oct_vtx_ind_OLD[3]; // V4
            }
        else if ( (man_V6) && (man_V3) )
            {
            oct_info = 0; // can flip with either slice
            // copy spine over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            // shift!
            ovi_temp[2] = oct_vtx_ind_OLD[5]; // V6
            ovi_temp[3] = oct_vtx_ind_OLD[2]; // V3
            ovi_temp[4] = oct_vtx_ind_OLD[3]; // V4
            ovi_temp[5] = oct_vtx_ind_OLD[4]; // V5
            }
        else // there is no consecutive pair of manifold vertices, so no need to flip!
            {
            oct_info = -1; // don't need to flip!
            }

        // output final ordering
        if (oct_info==0) // only need to do this if we are even going to flip!
            {
            if (man_V1) // must make sure that the top of the spine is manifold
                {
                // Note: at this stage, we know that V3,V4 are manifold, V5,V6 are not!
                // we must re order the vertices so that V2 is manifold!
                oct_vtx_ind_NEW[0] = ovi_temp[1]; // V2
                oct_vtx_ind_NEW[1] = ovi_temp[0]; // V1
                oct_vtx_ind_NEW[2] = ovi_temp[3]; // V4
                oct_vtx_ind_NEW[3] = ovi_temp[2]; // V3
                oct_vtx_ind_NEW[4] = ovi_temp[5]; // V6
                oct_vtx_ind_NEW[5] = ovi_temp[4]; // V5
                }
            else // the top IS manifold
                {
                // can just copy directly over
                oct_vtx_ind_NEW[0] = ovi_temp[0];
                oct_vtx_ind_NEW[1] = ovi_temp[1];
                oct_vtx_ind_NEW[2] = ovi_temp[2];
                oct_vtx_ind_NEW[3] = ovi_temp[3];
                oct_vtx_ind_NEW[4] = ovi_temp[4];
                oct_vtx_ind_NEW[5] = ovi_temp[5];
                }
            }
        }
    else // there are 3 manifold vertices
        {
        // can only use one slice!
        oct_info = 1; // only use slice B
        // Note: we are going to order the vertices so that V3,V4,V5 are manifold and V6 is NOT

        // Find the one outer ring vertex that is NOT manifold!
        if (!man_V3)
            {
            // copy spine over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            // shift!
            ovi_temp[2] = oct_vtx_ind_OLD[3]; // V4
            ovi_temp[3] = oct_vtx_ind_OLD[4]; // V5
            ovi_temp[4] = oct_vtx_ind_OLD[5]; // V6
            ovi_temp[5] = oct_vtx_ind_OLD[2]; // V3
            }
        else if (!man_V4)
            {
            // copy spine over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            // shift!
            ovi_temp[2] = oct_vtx_ind_OLD[4]; // V5
            ovi_temp[3] = oct_vtx_ind_OLD[5]; // V6
            ovi_temp[4] = oct_vtx_ind_OLD[2]; // V3
            ovi_temp[5] = oct_vtx_ind_OLD[3]; // V4
            }
        else if (!man_V5)
            {
            // copy spine over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            // shift!
            ovi_temp[2] = oct_vtx_ind_OLD[5]; // V6
            ovi_temp[3] = oct_vtx_ind_OLD[2]; // V3
            ovi_temp[4] = oct_vtx_ind_OLD[3]; // V4
            ovi_temp[5] = oct_vtx_ind_OLD[4]; // V5
            }
        else if (!man_V6)
            {
            // nothing to do... just copy over
            ovi_temp[0] = oct_vtx_ind_OLD[0];
            ovi_temp[1] = oct_vtx_ind_OLD[1];
            ovi_temp[2] = oct_vtx_ind_OLD[2]; // V3
            ovi_temp[3] = oct_vtx_ind_OLD[3]; // V4
            ovi_temp[4] = oct_vtx_ind_OLD[4]; // V5
            ovi_temp[5] = oct_vtx_ind_OLD[5]; // V6
            }

        if (man_V1) // must make sure that the top of the spine is manifold
            {
            // Note: at this stage, we know that V3,V4,V5 are manifold, but V6 is NOT!
            // we must re order the vertices so that V2 is manifold!
            oct_vtx_ind_NEW[0] = ovi_temp[1]; // V2
            oct_vtx_ind_NEW[1] = ovi_temp[0]; // V1
            oct_vtx_ind_NEW[2] = ovi_temp[4]; // V5
            oct_vtx_ind_NEW[3] = ovi_temp[3]; // V4
            oct_vtx_ind_NEW[4] = ovi_temp[2]; // V3
            oct_vtx_ind_NEW[5] = ovi_temp[5]; // V6
            }
        else // the top IS manifold
            {
            // can just copy directly over
            oct_vtx_ind_NEW[0] = ovi_temp[0];
            oct_vtx_ind_NEW[1] = ovi_temp[1];
            oct_vtx_ind_NEW[2] = ovi_temp[2];
            oct_vtx_ind_NEW[3] = ovi_temp[3];
            oct_vtx_ind_NEW[4] = ovi_temp[4];
            oct_vtx_ind_NEW[5] = ovi_temp[5];
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* determine the warping configuration for the given (ORDERED) octahedron, and return
   whether or not you can do the flip!
   Note: this assumes that V2, V3, V4, and (maybe) V5 are manifold, but no others!
*/
bool MGA::Compute_Octahedron_Warping_Configuration(const unsigned int oct_vtx_indices[6])
{
    bool FLIP_IT = false; // init to NOT flip

    // get BCC coordinates of the octahedron's vertices
    double V2_Coord[3], V3_Coord[3], V4_Coord[3], V5_Coord[3], V6_Coord[3];
    //bcc_mesh->Get_Vertex_Coordinates(oct_vtx_indices[0], V1_Coord); // must use matlab indexing here!
    bcc_mesh->Get_Vertex_Coordinates(oct_vtx_indices[1], V2_Coord); // must use matlab indexing here!
    bcc_mesh->Get_Vertex_Coordinates(oct_vtx_indices[2], V3_Coord);
    bcc_mesh->Get_Vertex_Coordinates(oct_vtx_indices[3], V4_Coord);
    bcc_mesh->Get_Vertex_Coordinates(oct_vtx_indices[4], V5_Coord);
    bcc_mesh->Get_Vertex_Coordinates(oct_vtx_indices[5], V6_Coord);

    // read destination points
    double V2_dest[3], V3_dest[3], V4_dest[3], V5_dest[3];
    Read_Destination_Point(oct_vtx_indices[1]-1, V2_dest); // must use C-style indexing here!
    Read_Destination_Point(oct_vtx_indices[2]-1, V3_dest);
    Read_Destination_Point(oct_vtx_indices[3]-1, V4_dest);
    Read_Destination_Point(oct_vtx_indices[4]-1, V5_dest);

    const double short_edge_length = bcc_mesh->short_length;
    const double V5_switch = (0.3 - 1E-8); // extra little bit is for numerical safety
    // compute (true) warping distances normalized by the short edge length
    const double V5_warp_dist = Euclidean_Distance(V5_dest, V5_Coord) / short_edge_length;
    if  (V5_warp_dist < V5_switch) // V5 cannot warp too much
        {
        // compute the warping directions we are interested in
        double d2_A[3], d2_B[3], d3[3], d4[3]; // not unit vectors!!!
        Get_Vec_Difference(V2_Coord, V5_Coord, d2_A);
        Get_Vec_Difference(V2_Coord, V6_Coord, d2_B);
        Get_Vec_Difference(V2_Coord, V4_Coord, d3);
        Get_Vec_Difference(V2_Coord, V3_Coord, d4);

        // compute the *actual* warping vectors
        double V2_warp[3], V3_warp[3], V4_warp[3];
        Get_Vec_Difference(V2_dest, V2_Coord, V2_warp);
        Get_Vec_Difference(V3_dest, V3_Coord, V3_warp);
        Get_Vec_Difference(V4_dest, V4_Coord, V4_warp);

        // compute warping (signed) distances normalized by the short edge length
        // note that we divide by short edge length^2
        //      because the d_i's must be unit vectors and the warping distance must be normalized
        const double L_st_squared = short_edge_length*short_edge_length;
        const double V2_warp_dist_A = Dot_Product(V2_warp, d2_A);
        const double V2_warp_dist_B = Dot_Product(V2_warp, d2_B);
        const double V2_warp_dist = Get_Max(V2_warp_dist_A, V2_warp_dist_B) / L_st_squared;

        const double V3_warp_dist = Dot_Product(V3_warp, d3) / L_st_squared;
        const double V4_warp_dist = Dot_Product(V4_warp, d4) / L_st_squared;
        /* NOTE: these are NOT necessarily the true (normalized) distances.
                 They are just the projection of the warping vector onto unit vectors
                 representing the "problem" directions.  Of course, if the warping
                 vector is aligned with one of these "problem" directions, then
                 the projection does give the true (signed) distance.
                 If it is not aligned, then you will get a much smaller number in magnitude
                 (not necessarily zero, b/c the short edge directions are not mutually
                 orthogonal).

                 But this is ok!  B/c if the normalized warping distance is 0.5 (largest possible),
                 but the warping *vector* is NOT aligned with a "problem" direction, then the
                 resulting dot product (DP) must be in the range  -0.5 <= DP <= +0.16667.
                 Since the cutoff value is +0.3 (see below), this cannot falsely
                 trigger an edge-flip.
        */
//         mexPrintf("V2,V3,V4 warp_dist = %1.3G, %1.3G, %1.3G.\n",V2_warp_dist,V3_warp_dist,V4_warp_dist);
//         const double V2_warp_dist_correct = Euclidean_Distance(V2_dest, V2_Coord) / short_edge_length;
//         const double V3_warp_dist_correct = Euclidean_Distance(V3_dest, V3_Coord) / short_edge_length;
//         const double V4_warp_dist_correct = Euclidean_Distance(V4_dest, V4_Coord) / short_edge_length;
//         mexPrintf("V2,V3,V4 (actual dist) = %1.3G, %1.3G, %1.3G.\n",
//                    V2_warp_dist_correct,V3_warp_dist_correct,V4_warp_dist_correct);

        // if V2, V3, V4 are indeed warping along the "problem" directions positively enough
        if ( (V2_warp_dist >= 0.3) && (V3_warp_dist >= 0.3) && (V4_warp_dist >= 0.3) )
            FLIP_IT = true; // we need to flip!
        }

    return FLIP_IT;
}
/***************************************************************************************/


// /***************************************************************************************/
// /* this checks if the spine in the given octahedron is available for a flip.
//    Note: this assumes that the spine is a non-cut long edge with one end point
//    manifold.  If there is another non-cut long edge with one end point manifold
//    contained in the ring around the spine, then it is NOT available.
//    Otherwise, it is available.
// */
// bool MGA::Is_NonCut_Long_Edge_With_One_Manifold_Point_Available
//                              (const unsigned int oct_vtx_indices[6],
//                               bool& Slice_A_Available,
//                               bool& Slice_B_Available)
// {
//     // convenient refs... (in C-style indexing!)
// //     const unsigned int& V1 = oct_vtx_indices[0] - 1;
// //     const unsigned int& V2 = oct_vtx_indices[1] - 1;
//     const unsigned int& V3 = oct_vtx_indices[2] - 1;
//     const unsigned int& V4 = oct_vtx_indices[3] - 1;
//     const unsigned int& V5 = oct_vtx_indices[4] - 1;
//     const unsigned int& V6 = oct_vtx_indices[5] - 1;
//
//     // get the sign of the level set values at each of the (outer) ring vertices
//     const int sgn_V3 = LS_SIGN(level_set_values_at_vtx[V3]);
//     const int sgn_V4 = LS_SIGN(level_set_values_at_vtx[V4]);
//     const int sgn_V5 = LS_SIGN(level_set_values_at_vtx[V5]);
//     const int sgn_V6 = LS_SIGN(level_set_values_at_vtx[V6]);
//
//     // get manifold status at each of the (outer) ring vertices
//     const bool man_V3 = manifold.vtx_mask[V3];
//     const bool man_V4 = manifold.vtx_mask[V4];
//     const bool man_V5 = manifold.vtx_mask[V5];
//     const bool man_V6 = manifold.vtx_mask[V6];
//
//     // first check if at least ONE slice is available, i.e. does not introduce an active cut edge!
//     // check slice "A" (edge connecting V3-V5)
//     if ((sgn_V3!=sgn_V5) && (!man_V3) && (!man_V5)) // if V3-V5 is cut and neither point is manifold
//         Slice_A_Available = false; // cannot use slice "A"
//     // check slice "B" (edge connecting V4-V6)
//     if ((sgn_V4!=sgn_V6) && (!man_V4) && (!man_V6)) // if V4-V6 is cut and neither point is manifold
//         Slice_B_Available = false; // cannot use slice "B"
//
//     // flipping is available only if at least one slice is available
//     bool IS_AVAILABLE = Slice_A_Available || Slice_B_Available;
//
//     if (IS_AVAILABLE) // if slicing is still an option
//         {
//         // if a long edge is *not* cut  AND  only ONE end point is manifold
//         if ((sgn_V3==sgn_V4) && (man_V3!=man_V4))
//             IS_AVAILABLE = false;
//         else if ((sgn_V4==sgn_V5) && (man_V4!=man_V5))
//             IS_AVAILABLE = false;
//         else if ((sgn_V5==sgn_V6) && (man_V5!=man_V6))
//             IS_AVAILABLE = false;
//         else if ((sgn_V6==sgn_V3) && (man_V6!=man_V3))
//             IS_AVAILABLE = false;
//         // then we CANNOT flip the spine!
//         }
//     return IS_AVAILABLE;
// }
// /***************************************************************************************/


/***************************************************************************************/
/* This returns a special ordering of the tetrahedral vertex indices.
   Note: this *changes* tet_data!
*/
void Order_Tet_Vtx (const unsigned int spine_indices[2], const unsigned int tet_data[4],
                          unsigned int tet_data_ordered[4])
{
    // make some convenient refs
    const unsigned int& S1 = spine_indices[0];
    const unsigned int& S2 = spine_indices[1];
    const unsigned int& V1 = tet_data[0];
    const unsigned int& V2 = tet_data[1];
    const unsigned int& V3 = tet_data[2];
    const unsigned int& V4 = tet_data[3];

    // proceed with massive if-then statement...
    if (S1==V1)
        {
        if (S2==V2) // e1
            {
            tet_data_ordered[0] = V1;
            tet_data_ordered[1] = V2;
            tet_data_ordered[2] = V3;
            tet_data_ordered[3] = V4;
            }
        else if (S2==V3) // e2
            {
            tet_data_ordered[0] = V1;
            tet_data_ordered[1] = V3;
            tet_data_ordered[2] = V4;
            tet_data_ordered[3] = V2;
            }
        else if (S2==V4) // e3
            {
            tet_data_ordered[0] = V1;
            tet_data_ordered[1] = V4;
            tet_data_ordered[2] = V2;
            tet_data_ordered[3] = V3;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tet_Vtx'.");
        }
    else if (S1==V2)
        {
        if (S2==V1) // -e1
            {
            tet_data_ordered[0] = V2;
            tet_data_ordered[1] = V1;
            tet_data_ordered[2] = V4;
            tet_data_ordered[3] = V3;
            }
        else if (S2==V3) // e4
            {
            tet_data_ordered[0] = V2;
            tet_data_ordered[1] = V3;
            tet_data_ordered[2] = V1;
            tet_data_ordered[3] = V4;
            }
        else if (S2==V4) // -e6
            {
            tet_data_ordered[0] = V2;
            tet_data_ordered[1] = V4;
            tet_data_ordered[2] = V3;
            tet_data_ordered[3] = V1;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tet_Vtx'.");
        }
    else if (S1==V3)
        {
        if (S2==V1) // -e2
            {
            tet_data_ordered[0] = V3;
            tet_data_ordered[1] = V1;
            tet_data_ordered[2] = V2;
            tet_data_ordered[3] = V4;
            }
        else if (S2==V2) // -e4
            {
            tet_data_ordered[0] = V3;
            tet_data_ordered[1] = V2;
            tet_data_ordered[2] = V4;
            tet_data_ordered[3] = V1;
            }
        else if (S2==V4) // e5
            {
            tet_data_ordered[0] = V3;
            tet_data_ordered[1] = V4;
            tet_data_ordered[2] = V1;
            tet_data_ordered[3] = V2;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tet_Vtx'.");
        }
    else if (S1==V4)
        {
        if (S2==V1) // -e3
            {
            tet_data_ordered[0] = V4;
            tet_data_ordered[1] = V1;
            tet_data_ordered[2] = V3;
            tet_data_ordered[3] = V2;
            }
        else if (S2==V2) // e6
            {
            tet_data_ordered[0] = V4;
            tet_data_ordered[1] = V2;
            tet_data_ordered[2] = V1;
            tet_data_ordered[3] = V3;
            }
        else if (S2==V3) // -e5
            {
            tet_data_ordered[0] = V4;
            tet_data_ordered[1] = V3;
            tet_data_ordered[2] = V2;
            tet_data_ordered[3] = V1;
            }
        else
            mexErrMsgTxt("ERROR: see 'Order_Tet_Vtx'.");
        }
    else
        mexErrMsgTxt("ERROR: see 'Order_Tet_Vtx'.");
}
/***************************************************************************************/


/***************************************************************************************/
/* This gets the vertices of a given octahedron in a pre-defined arranged order.
   The octahedron consists of a given spine (edge) and the 4 attached
   tetrahedra indices.
   Note: spine_edge_index is in C-style.
*/
void MGA::Get_Arranged_Octahedra_Vertex_Indices (const unsigned int& spine_edge_index,    // inputs
                                                 const ATTACH&       oct_tets,            // inputs
                                                 unsigned int        oct_vtx_indices[6])  // outputs
{
    // error check
    if (oct_tets.num!=4) mexErrMsgTxt("Octahedra does not consist of 4 tetrahedra!  This should not happen!  See 'Get_Arranged_Octahedra_Vertex_Indices'.");

    // get spine vertex indices
    unsigned int spine_indices[2];
    bcc_mesh->Get_Vertex_Indices_Of_Long_Edge(spine_edge_index, spine_indices[0], spine_indices[1]);

    // get the vertex indices of all 4 tetrahedra
    // actually, MATLAB orders these attachments, so why not take advantage!
    unsigned int tet1_data[4];
    //unsigned int tet2_data[4];
    unsigned int tet3_data[4];
    //unsigned int tet4_data[4];
    bcc_mesh->Get_Tetrahedra_Indices(oct_tets.indices[0], tet1_data);
    //bcc_mesh->Get_Tetrahedra_Indices(oct_tets.indices[1], tet2_data);
    bcc_mesh->Get_Tetrahedra_Indices(oct_tets.indices[2], tet3_data);
    //bcc_mesh->Get_Tetrahedra_Indices(oct_tets.indices[3], tet4_data);

    // order the vertices of each individual tet
    unsigned int tet1_data_ordered[4];
    unsigned int tet3_data_ordered[4];
    Order_Tet_Vtx(spine_indices, tet1_data, tet1_data_ordered);
    Order_Tet_Vtx(spine_indices, tet3_data, tet3_data_ordered);

    // output ordered octahedral vertices
    oct_vtx_indices[0] = tet1_data_ordered[0];
    oct_vtx_indices[1] = tet1_data_ordered[1];
    oct_vtx_indices[2] = tet1_data_ordered[2];
    oct_vtx_indices[3] = tet1_data_ordered[3];

    oct_vtx_indices[4] = tet3_data_ordered[2];
    oct_vtx_indices[5] = tet3_data_ordered[3];
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
    const double Min_Angle_Cutoff_radians = 11.47 * (PI/180); // minimum angle is 11.47 degrees

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
/* This changes the tetrahedra node data inside a given octahedron by performing
     an edge-flip within the given octahedron.  This is only for the
     active cut long edge case!
     Note: this assumes the "A" and "B" slices have a particular ordering of
     vertex indices!
*/
void MGA::Do_44_Edge_Flip_Active_Cut_Long_Edge (
                                   const ATTACH&       oct_tets,    // inputs
                                   OCT_DATA_STRUCT&    Slice_A,     // inputs
                                   OCT_DATA_STRUCT&    Slice_B)     // inputs
{
    // get level set sign of Vtop and Vbot
    const unsigned int vtop_ind_c_style = (unsigned int) (Slice_A.tet1_data[3] - 1);
    const unsigned int vbot_ind_c_style = (unsigned int) (Slice_A.tet4_data[3] - 1);
    const int sgn_Vtop = LS_SIGN(level_set_values_at_vtx[vtop_ind_c_style]);
    const int sgn_Vbot = LS_SIGN(level_set_values_at_vtx[vbot_ind_c_style]);

    // only need to pay attention to the interior tetrahedra
    double Min_Angles_A[2], Min_Angles_B[2];
    double Max_Angles_A[2], Max_Angles_B[2];
    if (sgn_Vtop > 0) // we will keep the top vertex
        {
        // so only look at the top tetrahedra
        Compute_MinMax_Dihedral_Angle(Slice_A.tet1_data, Min_Angles_A[0], Max_Angles_A[0]);
        Compute_MinMax_Dihedral_Angle(Slice_A.tet2_data, Min_Angles_A[1], Max_Angles_A[1]);
        Compute_MinMax_Dihedral_Angle(Slice_B.tet1_data, Min_Angles_B[0], Max_Angles_B[0]);
        Compute_MinMax_Dihedral_Angle(Slice_B.tet2_data, Min_Angles_B[1], Max_Angles_B[1]);
        }
    else // we will keep the bottom vertex
        {
        // so only look at the bottom tetrahedra
        Compute_MinMax_Dihedral_Angle(Slice_A.tet3_data, Min_Angles_A[0], Max_Angles_A[0]);
        Compute_MinMax_Dihedral_Angle(Slice_A.tet4_data, Min_Angles_A[1], Max_Angles_A[1]);
        Compute_MinMax_Dihedral_Angle(Slice_B.tet3_data, Min_Angles_B[0], Max_Angles_B[0]);
        Compute_MinMax_Dihedral_Angle(Slice_B.tet4_data, Min_Angles_B[1], Max_Angles_B[1]);
        }

    // get the worst case min angle
    const double Min_A = Get_Min(Min_Angles_A[0], Min_Angles_A[1]);
    const double Min_B = Get_Min(Min_Angles_B[0], Min_Angles_B[1]);
    // get the worst case max angle
    const double Max_A = Get_Max(Max_Angles_A[0], Max_Angles_A[1]);
    const double Max_B = Get_Max(Max_Angles_B[0], Max_Angles_B[1]);

    // apply long edge flip policy
    const int CHOICE = Edge_Flip_Policy(Min_A, Max_A, Min_B, Max_B);
    if (CHOICE==0)      Overwrite_New_Oct_Data(oct_tets.indices, Slice_A);
    else if (CHOICE==1) Overwrite_New_Oct_Data(oct_tets.indices, Slice_B);
    else mexErrMsgTxt("ERROR: this should not happen!\n");
}
/***************************************************************************************/


/***************************************************************************************/
/* This changes the tetrahedra node data inside a given octahedron by performing
     an edge-flip within the given octahedron.  This is only for the
     additional edge-flip one manifold long edge case!
*/
bool MGA::Do_44_Edge_Flip_One_Manifold_Long_Edge
                             (const ATTACH&        oct_tets,    // inputs
                              const unsigned int   ovi_ordered[6],
                              const          int&  info)
{
    bool OCT_CHANGED = false; // indicate that we have not changed the topology of the octahedron

    // compute warping configuration
    const bool WARP_CONFIG = Compute_Octahedron_Warping_Configuration(ovi_ordered);

    // if the warping configuration matches Fig. 7 in paper
    if (WARP_CONFIG)
        {
        if (info==0) // we must flip, and we can use either slice
            {
            // so use Slice A
            OCT_DATA_STRUCT  Slice_A;
            Make_A_Slice(ovi_ordered, Slice_A);
            Overwrite_New_Oct_Data(oct_tets.indices, Slice_A);
            OCT_CHANGED = true; // we changed the topology
            }
        else // info==1, i.e. we can *try* to flip, but only with Slice B
            {
            OCT_DATA_STRUCT  Slice_STD, Slice_B;
            Make_STD_Slice(ovi_ordered, Slice_STD); // no-flip case
            Make_B_Slice(ovi_ordered, Slice_B);

            // compute qualities of Slice STD and Slice B
            double Min_STD, Max_STD, Min_B, Max_B;
            Compute_MinMax_Dihedral_Angle_of_Four_Tets
                                      (Slice_STD.tet1_data, Slice_STD.tet2_data,
                                       Slice_STD.tet3_data, Slice_STD.tet4_data,
                                       Min_STD, Max_STD);
            Compute_MinMax_Dihedral_Angle_of_Four_Tets
                                      (Slice_B.tet1_data, Slice_B.tet2_data,
                                       Slice_B.tet3_data, Slice_B.tet4_data,
                                       Min_B, Max_B);

            // apply long edge flip policy
            const int index_of_choice = Edge_Flip_Policy(Min_STD, Max_STD, Min_B, Max_B);
            // if B was better...
            if (index_of_choice==1)
                {
                Overwrite_New_Oct_Data(oct_tets.indices, Slice_B); // overwrite with Slice B
                OCT_CHANGED = true; // we changed the topology
                }
            // ELSE, keep the standard slice.
            }
        }

    return OCT_CHANGED;
}
/***************************************************************************************/


/***************************************************************************************/
/* this computes the min dihedral angle for the 4 given tet_data's.
*/
void MGA::Compute_MinMax_Dihedral_Angle_of_Four_Tets (
                        const double  tet1_data[4], const double  tet2_data[4],
                        const double  tet3_data[4], const double  tet4_data[4],
                              double& Min_Angle,          double& Max_Angle)
{
    double MinAngs[4], MaxAngs[4];
    Compute_MinMax_Dihedral_Angle(tet1_data, MinAngs[0], MaxAngs[0]);
    Compute_MinMax_Dihedral_Angle(tet2_data, MinAngs[1], MaxAngs[1]);
    Compute_MinMax_Dihedral_Angle(tet3_data, MinAngs[2], MaxAngs[2]);
    Compute_MinMax_Dihedral_Angle(tet4_data, MinAngs[3], MaxAngs[3]);

    // return the minimum
    Min_Angle = *std::min_element(MinAngs, MinAngs+4);
    Max_Angle = *std::max_element(MaxAngs, MaxAngs+4);
}
/***************************************************************************************/


/***************************************************************************************/
/* this computes the min and MAX dihedral angle of the given tet_data.
   Note: the angles calculated are in radians.
*/
void MGA::Compute_MinMax_DotProd (const double tet_data[4], double& Min_DP, double& Max_DP)
{
    // convenient refs...
    const unsigned int V1 = (unsigned int) (tet_data[0] - 1); //  C-style indexing
    const unsigned int V2 = (unsigned int) (tet_data[1] - 1);
    const unsigned int V3 = (unsigned int) (tet_data[2] - 1);
    const unsigned int V4 = (unsigned int) (tet_data[3] - 1);

    // get coordinates (must read the destination point!)
    double V1_Coord[3], V2_Coord[3], V3_Coord[3], V4_Coord[3];
    Read_Destination_Point(V1, V1_Coord); // must use C-style indexing here!
    Read_Destination_Point(V2, V2_Coord);
    Read_Destination_Point(V3, V3_Coord);
    Read_Destination_Point(V4, V4_Coord);

    // compute edge vectors
    double e1[3], e2[3], e3[3], e4[3], e6[3]; // yes, e5 is not needed...
    Get_Vec_Difference(V2_Coord, V1_Coord, e1);
    Get_Vec_Difference(V3_Coord, V1_Coord, e2);
    Get_Vec_Difference(V4_Coord, V1_Coord, e3);
    Get_Vec_Difference(V3_Coord, V2_Coord, e4);
    Get_Vec_Difference(V2_Coord, V4_Coord, e6);

    // compute unit normals
    double N1[3], N2[3], N3[3], N4[3];
    double N_LEN[4];
    N_LEN[0] = Normalized_Cross_Product(e4,e6,N1);
    N_LEN[1] = Normalized_Cross_Product(e2,e3,N2);
    N_LEN[2] = Normalized_Cross_Product(e3,e1,N3);
    N_LEN[3] = Normalized_Cross_Product(e1,e2,N4);
    // return the smallest face area
    const double Min_N_LEN = *std::min_element(N_LEN,N_LEN+4);
    const double Min_Face_Area = Min_N_LEN / 2.0; // don't forget 1/2 factor for triangle area

    // compute the 6 dot products
    double DP[6];
    DP[0] = Dot_Product(N3,N4);
    DP[1] = Dot_Product(N2,N4);
    DP[2] = Dot_Product(N2,N3);
    DP[3] = Dot_Product(N1,N4);
    DP[4] = Dot_Product(N1,N2);
    DP[5] = Dot_Product(N1,N3);

    // get min and max!
    Min_DP = *std::min_element(DP,DP+6);
    Max_DP = *std::max_element(DP,DP+6);

    // if the triangle face area is too small
    if (Min_Face_Area < 1e-14)
        {
        // then obviously, the dot products must be BAD!
        Min_DP = -1.0; // set to   0 degrees
        Max_DP = +1.0; // set to 180 degrees
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* this computes the min dihedral angle of the given tet_data.
   Note: the angles calculated are in radians.
*/
void MGA::Compute_MinMax_Dihedral_Angle (const double tet_data[4], double& Min_Angle, double& Max_Angle)
{
    double Min_DP, Max_DP;
    Compute_MinMax_DotProd(tet_data, Min_DP, Max_DP);

    // convert dot product to angles
    Min_Angle = Get_Angle(-Min_DP); // yes, you need the minus sign
    Max_Angle = Get_Angle(-Max_DP); // yes, you need the minus sign
}
/***************************************************************************************/


/***************************************************************************************/
/* This sets the output matrix mxOutMsk to be a logical indicator array that selects
   which tetrahedra are inside the isosurface (which also indicates which are outside).
*/
void MGA::Choose_Inside_Outside_Tets ()
{
    // loop thru all background mesh tetrahedra
    unsigned int COUNT = 0;
    for (unsigned int ti = 0; ti < Num_BCC_Tet; ti++)
        {
        if (ambiguous_tet_status[ti]==0) // if it is NOT an ambiguous tet
            {
            int tet_sign_data[4];
            Get_Sign_Of_Tet(ti, tet_sign_data);

            // if none of the vertice are negative
            if ( (tet_sign_data[0] >= 0) && (tet_sign_data[1] >= 0) &&
                 (tet_sign_data[2] >= 0) && (tet_sign_data[3] >= 0) )
                {
                // then it must be an *inside* tetrahedron
                tet_in_mask[ti] = true; // true means it is inside
                }
            }
        // else
        // its inside status must be determined back in MATLAB!
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* return signs of vertices of given tet index (tet_ind is in C-style)
   if the vertex is manifold, then the sign is 0.
   else, if the level set value is negative, then sign is -1.
   otherwise, the sign is +1.
*/
void MGA::Get_Sign_Of_Tet (const unsigned int& tet_ind, int tet_sign_data[4])
{
    // loop thru the 4 vertices
    for (unsigned int vi = 0; vi < 4; vi++)
        {
        // read the vertex indices of the given tet
        const unsigned int v_ind_c_style = (unsigned int) (out_tet_data[vi][tet_ind] - 1);
        if (manifold.vtx_mask[v_ind_c_style])
            tet_sign_data[vi] = 0;
        else
            tet_sign_data[vi] = LS_SIGN(level_set_values_at_vtx[v_ind_c_style]);
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
