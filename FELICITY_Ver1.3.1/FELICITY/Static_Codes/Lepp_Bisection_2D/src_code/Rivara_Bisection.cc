/*
============================================================================================
   This class encapsulates the 2-D Rivara bisection class.  It accesses the triangle data
   and triangle neighbor data structures.

   Copyright (c) 09-12-2011,  Shawn W. Walker
============================================================================================
*/

#include <list>

// prototype (see the end)
inline int argmax_of_three(const double&, const double&, const double&);

/* C++ Triangle Mesh class definition */
class Rivara_Bisection_Class
{
public:
    Rivara_Bisection_Class (); // constructor
    ~Rivara_Bisection_Class ();   // DE-structor
    void Setup_Marked_Triangle_List(const mxArray*);
    void Setup_Data(const unsigned int, Generic_Data<double,3>*, Generic_Data<unsigned int,3>*,
                    Generic_Data<unsigned int,3>*, std::vector<Subdomain_Data>*);
    void Run_Bisection();

    // list of marked triangles to bisect
    std::list<unsigned int> Marked_Triangles;

private:
    unsigned int  GeoDim; // geometric dimension
    // mesh data
    Generic_Data<double,3>*        Vtx;
    Generic_Data<unsigned int,3>*  Tri;
    Generic_Data<unsigned int,3>*  Neighbor;
    // subdomains
    std::vector<Subdomain_Data>*   SUB;

    // for recording the LEPP sequence
    std::vector<int> LEPP; // this should stay (int) to allow for storing a null value `-1'

    // struct for recording terminal triangle data related to longest edge
    typedef struct
    {
        int     edge_index;      // local edge index of the longest edge
        int     LE_vtx_index[2]; // global vertex indices of the longest edge
    } TERMINAL_TRI;

    void Bisect_Last_Triangle_In_Marked_List();
    void Init_LEPP_Seq(const unsigned int&, TERMINAL_TRI&, TERMINAL_TRI&);
    void Get_LEPP_Seq_And_Terminal_Pair(TERMINAL_TRI&, TERMINAL_TRI&);
    bool Get_Next_Element_In_LEPP_Seq(TERMINAL_TRI&, TERMINAL_TRI&);
    void Bisect_Terminal_Pair_And_Remove_From_Marked_Triangles(const TERMINAL_TRI&, const TERMINAL_TRI&);
    unsigned int Insert_New_Vertex(const TERMINAL_TRI&);
    void Pop_Terminal_Pair(int&, int&);
    void Bisect_Single_Triangle(const unsigned int&, const TERMINAL_TRI&,
                                const unsigned int&, const unsigned int&,
                                const unsigned int&, const unsigned int&);
    void Get_Local_Arrangement(const unsigned int&, const unsigned int&, unsigned int*, unsigned int&, unsigned int&);
    void Create_Two_New_Triangles(const unsigned int&, const unsigned int&,
                                  const unsigned int&, const unsigned int&,
                                  const unsigned int&, const unsigned int*,
                                  const unsigned int&, unsigned const int&);
    void Adjust_B_Neighbor(const unsigned int&, const unsigned int&, const unsigned int&);
    void Adjust_Subdomains(const unsigned int&, const unsigned int&, const unsigned int&);
    void   Find_Longest_Edge(const unsigned int&, TERMINAL_TRI&);
    double Compute_Distance(const unsigned int&, const unsigned int&);
    void   Compute_Mid_Point(const unsigned int&, const unsigned int&, double*);
};

/***************************************************************************************/
/* constructor */
// Note: its usually a good idea to NOT allow ``mexErrMsgTxt'' in the constructor!
Rivara_Bisection_Class::Rivara_Bisection_Class()
{
    // init
    GeoDim   = 0;
    Vtx      = NULL;
    Tri      = NULL;
    Neighbor = NULL;
}
/***************************************************************************************/


/***************************************************************************************/
/* DE-structor */
Rivara_Bisection_Class::~Rivara_Bisection_Class ()
{
}
/***************************************************************************************/


/***************************************************************************************/
/* setup marked triangle list */
void Rivara_Bisection_Class::Setup_Marked_Triangle_List(const mxArray* mxMarked)
{
    // setup marked triangle list
    unsigned int Num_Marked_Row = (unsigned int) mxGetM(mxMarked);
    unsigned int Num_Marked_Col = (unsigned int) mxGetN(mxMarked);

    // BEGIN: error check
    if (Num_Marked_Col > 1) mexErrMsgTxt("ERROR: Marked triangle list must be a single column vector!");
    if (mxGetClassID(mxMarked)!=mxUINT32_CLASS) mexErrMsgTxt("ERROR: Marked triangle list must be of type uint32!");
    // END: error check

    Marked_Triangles.resize(Num_Marked_Row);
    // read in marked triangle list
    unsigned int* Marked_Ptr = (unsigned int*) mxGetPr(mxMarked);
    std::copy(Marked_Ptr, Marked_Ptr + Num_Marked_Row, Marked_Triangles.begin());
    // sort list and make sure it is unique
    Marked_Triangles.sort();
    Marked_Triangles.unique();
}
/***************************************************************************************/


/***************************************************************************************/
/* put incoming mesh data from MATLAB into a nice struct  */
void Rivara_Bisection_Class::Setup_Data(const unsigned int             GeoDim_input,
                                        Generic_Data<double,3>*        Vtx_input,
                                        Generic_Data<unsigned int,3>*  Tri_input,
                                        Generic_Data<unsigned int,3>*  Neighbor_input,
                                        std::vector<Subdomain_Data>*   SUB_input)
{
    // store for later access
    GeoDim   = GeoDim_input;
    Vtx      = Vtx_input;
    Tri      = Tri_input;
    Neighbor = Neighbor_input;
    SUB      = SUB_input;

    // error check
    // note: Marked_Triangles are sorted (in constructor)
    if (Marked_Triangles.back() > Tri->Get_Num_Rows())
        {
        mexPrintf("ERROR: largest index in marked triangle list is: %d.\n",Marked_Triangles.back());
        mexPrintf("       the number of triangles in the initial mesh is: %d\n",Tri->Get_Num_Rows());
        mexErrMsgTxt("ERROR: fix your marked list and/or the triangle data!");
        }
    if (Marked_Triangles.front() < 1)
        {
        mexPrintf("ERROR: smallest index in marked triangle list is: %d.\n",Marked_Triangles.front());
        mexPrintf("       You must pass only positive integers for the marking!\n");
        mexErrMsgTxt("ERROR: fix your marked list and/or the triangle data!");
        }

    // reserve more memory than one typically needs
    LEPP.reserve( 200 );
    LEPP.clear();
}
/***************************************************************************************/


/***************************************************************************************/
/* do LEPP bisection until all triangles in the marked list are bisected
   note: other triangles not in the list may also get bisected to maintain conformity */
void Rivara_Bisection_Class::Run_Bisection()
{
    const unsigned int total_num_initially_marked_triangles = (unsigned int) Marked_Triangles.size();

    // while there are still triangles in the marked list, continue bisecting
    while (Marked_Triangles.size() > 0)
        Bisect_Last_Triangle_In_Marked_List();

    // get number of newly added triangles
    const unsigned int Num_New_Triangles = Tri->Get_Num_Rows() - Tri->Get_Orig_Num_Rows();
    if (Num_New_Triangles < total_num_initially_marked_triangles)
        {
        // then there is a problem!
        // there should be at least as many new triangles as you have marked
        mexPrintf("ERROR: this is the number of triangles you marked: %d\n",total_num_initially_marked_triangles);
        mexPrintf("       this is the number of NEW triangles that were added: %d\n",Num_New_Triangles);
        mexPrintf("       there should be at least as many new triangles as you marked for bisection.\n");
        mexErrMsgTxt("ERROR: check the consistency of your data!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* take the last triangle in the marked list and run the algorithm until you
   finally refine that triangle */
void Rivara_Bisection_Class::Bisect_Last_Triangle_In_Marked_List()
{
    // more efficient to work from the back
    const unsigned int t_m = Marked_Triangles.back(); // get the last marked triangle index

    TERMINAL_TRI  t0, t1; // useful structs
    Init_LEPP_Seq(t_m, t0, t1);

    while (!LEPP.empty())
        {
        Get_LEPP_Seq_And_Terminal_Pair(t0, t1); // t0,t1  are *outputs* here
        Bisect_Terminal_Pair_And_Remove_From_Marked_Triangles(t0, t1); // t0,t1  are inputs here
        }

    // make sure that t_m was actually removed from the list
    if ( !Marked_Triangles.empty() && (t_m==Marked_Triangles.back()) )
        {
        mexPrintf("ERROR: the LEPP sequence is empty,\n");
        mexPrintf("       but the triangle you wanted to bisect is still in the Marked_List!\n");
        mexPrintf("\n");
        mexPrintf("       You should check the positive orientation of your triangulation,\n");
        mexPrintf("       and make sure that the neighbor struct is correct!\n");
        mexErrMsgTxt("ERROR: if this error persists, please report it!");
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* init the LEPP sequence */
void Rivara_Bisection_Class::Init_LEPP_Seq(const unsigned int& starter_triangle_index, // inputs
                                           TERMINAL_TRI& t0, TERMINAL_TRI& t1)         // inputs
{
    // init the LEPP sequence
    LEPP.clear();
    LEPP.push_back((int) starter_triangle_index);

    // init terminal pair data
    t0.edge_index      = -1;
    t0.LE_vtx_index[0] = -1;
    t0.LE_vtx_index[1] = -1;
    t1.edge_index      = -1;
    t1.LE_vtx_index[0] = -1;
    t1.LE_vtx_index[1] = -1;
}
/***************************************************************************************/


/***************************************************************************************/
/* get a sequence of triangle indices leading to a terminal (longest) edge
   starting from the initial index in LEPP (LEPP is already initialized)
   Note: inputs do get modified.
*/
void Rivara_Bisection_Class::Get_LEPP_Seq_And_Terminal_Pair(TERMINAL_TRI& t0, TERMINAL_TRI& t1)  // inputs
{
    // find which local edge is the longest
	const int LEPP_back = LEPP.back();
	if (LEPP_back > 0) Find_Longest_Edge( (unsigned int) LEPP_back, t0);
	else mexErrMsgTxt("The last triangle in the LEPP sequence is not valid!  This should not happen!\n");

    bool DONE = false;
    unsigned int COUNT_TEST = 0;
    while (!DONE)
        {
        DONE = Get_Next_Element_In_LEPP_Seq(t0, t1); // t0,t1  are inputs and outputs

        COUNT_TEST++;
        // if the LEPP sequence is extremely long
        if (COUNT_TEST > 100000)
            {
            mexPrintf("ERROR: The Longest-Edge-Propagation-Path (LEPP) in the bisection routine\n");
            mexPrintf("       has exceeded 100,000 triangles!\n");
            mexPrintf("       This should only happen for an **EXTREMELY BAD** initial mesh.\n");
            mexPrintf("       Make sure your triangle data structure AND neighbor structure\n");
            mexPrintf("       are consistent!\n");
            mexErrMsgTxt("ERROR: Check your mesh!  If the error persists, please report it.");
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get the next triangle in the LEPP sequence
   note: the inputs will get modified. */
bool Rivara_Bisection_Class::Get_Next_Element_In_LEPP_Seq(TERMINAL_TRI& t0, TERMINAL_TRI& t1)
{
    bool DONE = false;

    // get the neighbor of the longest edge of t0
    unsigned int Neighbor_Ind = 0;
    Neighbor->Read(LEPP.back() - 1, t0.edge_index, Neighbor_Ind); // use C-style indexing

    if (Neighbor_Ind==0) // no neighbor exists; longest edge is on the boundary
        {
        DONE = true; // in this case, the terminal "pair" is just one triangle on the boundary
        LEPP.push_back(-1); // indicates that t1 = NULL
        }
    else // there is a neighbor
        {
        // find the longest edge of the neighbor
        Find_Longest_Edge(Neighbor_Ind,t1);
        if ( (t1.LE_vtx_index[1]==t0.LE_vtx_index[0]) &&
             (t1.LE_vtx_index[0]==t0.LE_vtx_index[1]) ) // recall that orientation is flipped between neighboring triangles
             {
             // longest edge of first triangle and longest edge of neighbor (second) triangle
             // is identical
             DONE = true; // we have our terminal pair
             LEPP.push_back((int) Neighbor_Ind); // record t1
             }
        else // need to keep traversing the LEPP
            {
            DONE = false;
            // update t0 to the neighbor triangle
            LEPP.push_back((int) Neighbor_Ind);
            // shift t1 to t0
            t0.edge_index      = t1.edge_index;
            t0.LE_vtx_index[0] = t1.LE_vtx_index[0];
            t0.LE_vtx_index[1] = t1.LE_vtx_index[1];
            }
        }
    return DONE;
}
/***************************************************************************************/


/***************************************************************************************/
/* bisect the terminal triangle pair and remove bisected triangles from marked list */
void Rivara_Bisection_Class::Bisect_Terminal_Pair_And_Remove_From_Marked_Triangles(
                             const TERMINAL_TRI& t0_struct, const TERMINAL_TRI& t1_struct)  // inputs
{
    // create a new vertex at the midpoint of the (shared) longest edge
    const unsigned int New_Vtx_Index = Insert_New_Vertex(t0_struct);

    // remove the last pair of triangles from the LEPP sequence, because we are about to bisect them!
    int t0_index, t1_index; // must stay (int)
    Pop_Terminal_Pair(t0_index, t1_index);

    // bisect the terminal pair
    if (t1_index==-1) // in this case, the "pair" is just one triangle (t0) with longest edge on the boundary
        {
        // get new triangle index for s0 (it has not been created yet)
        const unsigned int s0_Index = Tri->Get_Num_Rows()+1;
        // BISECT!
        Bisect_Single_Triangle(New_Vtx_Index, t0_struct,  (unsigned int) t0_index,s0_Index,  0,0);
        // remove  t0  from the marked triangle list
        Marked_Triangles.remove((unsigned int) t0_index);
        }
    else
        {
        // get new triangle indices for s0 and s1 (they have not been created yet)
        const unsigned int s0_Index = Tri->Get_Num_Rows()+1;
        const unsigned int s1_Index = Tri->Get_Num_Rows()+2;
        // BISECT!
        Bisect_Single_Triangle(New_Vtx_Index, t0_struct,  (unsigned int) t0_index,s0_Index,  (unsigned int) t1_index,s1_Index);
        Bisect_Single_Triangle(New_Vtx_Index, t1_struct,  (unsigned int) t1_index,s1_Index,  (unsigned int) t0_index,s0_Index);
        // remove  t0,t1  from the marked triangle list
        Marked_Triangles.remove((unsigned int) t0_index);
        Marked_Triangles.remove((unsigned int) t1_index);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* insert new vertex (at mid-point) */
unsigned int Rivara_Bisection_Class::Insert_New_Vertex(const TERMINAL_TRI& t0_struct)  // inputs
{
	unsigned int LE_V0, LE_V1;
	if (t0_struct.LE_vtx_index[0] > 0)
		LE_V0 = (unsigned int) t0_struct.LE_vtx_index[0]; // global vertex index
	else
		mexErrMsgTxt("Global vertex index is not valid!  This should not happen!\n");

	if (t0_struct.LE_vtx_index[1] > 0)
		LE_V1 = (unsigned int) t0_struct.LE_vtx_index[1]; // global vertex index
	else
		mexErrMsgTxt("Global vertex index is not valid!  This should not happen!\n");

    // add new vertex at midpoint of longest edge
    double MidPt_Coord[3] = {0,0,0};
    Compute_Mid_Point(LE_V0, LE_V1, MidPt_Coord);
    Vtx->Append_Data_To_End(MidPt_Coord);
    return Vtx->Get_Num_Rows();
}
/***************************************************************************************/


/***************************************************************************************/
/* remove the terminal triangle pair from the LEPP sequence */
void Rivara_Bisection_Class::Pop_Terminal_Pair(int& t0_index, int& t1_index)  // inputs
{
    // remove the last pair of triangles from the LEPP sequence, because we are about to bisect them!
    t1_index = LEPP.back(); // global triangle index
    LEPP.pop_back(); // no longer needed
    t0_index = LEPP.back(); // global triangle index
    LEPP.pop_back(); // no longer needed
}
/***************************************************************************************/


/***************************************************************************************/
/* bisect a single triangle and update everything, i.e. replace t0 by a ``new t0'' and s0.
   INPUTS: V_hat ~ new inserted vertex INDEX.
              t0 ~ existing triangle STRUCT to change.
              s0 ~ new triangle INDEX to create.
               C ~ existing neighbor triangle INDEX (that is also bisected).
               D ~ new neighbor triangle INDEX of t0 (comes from bisecting other triangle).
   NOTES:  the above indices are GLOBAL. this routine is meant to be used twice on a
           triangle PAIR that share a common edge.  This also assumes that the original
           triangulation is positively oriented.
           See the ``Bisection_Diagram.pdf'' in ./src_code/Figures/   sub-dir.
*/
void Rivara_Bisection_Class::Bisect_Single_Triangle(const unsigned int& V_hat, const TERMINAL_TRI& t0_struct,
                                                    const unsigned int& t0,    const unsigned int& s0,
                                                    const unsigned int& C,     const unsigned int& D)
{
    // read local edge index to bisect
	unsigned int e0;
	if (t0_struct.edge_index >= 0) e0 = (unsigned int) t0_struct.edge_index; // local edge index of longest edge
	else mexErrMsgTxt("Local edge index is not valid!  This should not happen!\n");

    // global vertices of t0 (init)
    unsigned int V[3] = {0, 0, 0};
    // A and B neighbor triangle indices of t0 (init)
    unsigned int A_Neighbor_of_t0 = 0;
    unsigned int B_Neighbor_of_t0 = 0;

    // find the arrangement of vertices and neighbors relative to the longest edge
    Get_Local_Arrangement(t0,e0,  V,  A_Neighbor_of_t0,B_Neighbor_of_t0);

    // overwrite and append new triangle data
    Create_Two_New_Triangles(t0,s0,C,D,  V_hat,V,  A_Neighbor_of_t0,B_Neighbor_of_t0);

    // correct the neighbor data of one of the neighbors of t0
    Adjust_B_Neighbor(t0,s0,  B_Neighbor_of_t0);

    // adjust sub-domains, if necessary
    Adjust_Subdomains(t0,s0,e0);
}
/***************************************************************************************/


/***************************************************************************************/
/* get the arrangement of various global indices on the given triangle that
   is to be bisected.
*/
void Rivara_Bisection_Class::Get_Local_Arrangement(const unsigned int& t0,                        // inputs
                                                   const unsigned int& longest_edge_local_index,  // inputs
                                                   unsigned int* V,                      // outputs
                                                   unsigned int& A_Neighbor_of_t0,       // outputs
                                                   unsigned int& B_Neighbor_of_t0)       // outputs
{
    // read the vertices and neighbors of the triangle to bisect
    unsigned int T_of_t0[3] = {0, 0, 0};
    unsigned int N_of_t0[3] = {0, 0, 0};
    // use C-style indexing
    Tri->Read((int)(t0 - 1), T_of_t0);
    Neighbor->Read((int)(t0 - 1), N_of_t0);

    // find which case we are in and get global vertices and neighbors
    if (longest_edge_local_index==0) // longest edge has local index = 0
        {
        V[0] = T_of_t0[1];
        V[1] = T_of_t0[2];
        V[2] = T_of_t0[0];
        A_Neighbor_of_t0 = N_of_t0[1];
        B_Neighbor_of_t0 = N_of_t0[2];
        }
    else if (longest_edge_local_index==1) // longest edge has local index = 1
        {
        V[0] = T_of_t0[2];
        V[1] = T_of_t0[0];
        V[2] = T_of_t0[1];
        A_Neighbor_of_t0 = N_of_t0[2];
        B_Neighbor_of_t0 = N_of_t0[0];
        }
    else // longest edge has local index = 2
        {
        V[0] = T_of_t0[0];
        V[1] = T_of_t0[1];
        V[2] = T_of_t0[2];
        A_Neighbor_of_t0 = N_of_t0[0];
        B_Neighbor_of_t0 = N_of_t0[1];
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* this overwrites triangle connectivity (and neighbor) data for the triangle to
   be bisected with the data for one of the new triangles.  It then appends the
   data for the other new triangle.
*/
void Rivara_Bisection_Class::Create_Two_New_Triangles(
                                    const unsigned int& t0,      const unsigned int& s0, // inputs
                                    const unsigned int& C,       const unsigned int& D,  // inputs
                                    const unsigned int& V_hat,   const unsigned int* V,  // inputs
                                    const unsigned int& A_Neighbor_of_t0, // inputs
                                    const unsigned int& B_Neighbor_of_t0) // inputs
{
    // rewrite the triangle t0
    const unsigned int New_T_of_t0[3] = {V_hat, V[1], V[2]};
    const unsigned int New_N_of_t0[3] = {A_Neighbor_of_t0, s0, D};
    // create a new triangle
    const unsigned int New_T_of_s0[3] = {V_hat, V[2], V[0]};
    const unsigned int New_N_of_s0[3] = {B_Neighbor_of_t0, C, t0};
    // update the data!
    Tri->Overwrite((int)(t0 - 1), New_T_of_t0);      // use C-style indexing
    Neighbor->Overwrite((int)(t0 - 1), New_N_of_t0); // use C-style indexing
    Tri->Append_Data_To_End(New_T_of_s0);
    Neighbor->Append_Data_To_End(New_N_of_s0);
}
/***************************************************************************************/


/***************************************************************************************/
/* the B neighbor of t0 needs to have *its* neighbor data adjusted to reference
   the new triangle that was added.
*/
void Rivara_Bisection_Class::Adjust_B_Neighbor(const unsigned int& t0, const unsigned int& s0,
                                               const unsigned int& B_Neighbor_of_t0) // inputs
{
    // adjust the B neighbor (if it exists)
    if (B_Neighbor_of_t0 > 0)
        {
        unsigned int N_of_B[3] = {0, 0, 0};
        Neighbor->Read((int)(B_Neighbor_of_t0 - 1), N_of_B); // use C-style indexing
        // find which neighbor corresponds to ``t0''
        int index_to_change = -1;
        for (int i = 0; i < 3; i++)
            {
            if (N_of_B[i]==t0)
                {
                // then that is the index we change
                index_to_change = i;
                break;
                }
            }
        // error check
        if (index_to_change < 0)
            {
            mexPrintf("ERROR: Let T be the triangle to bisect.\n");
            mexPrintf("       One of the neighbors of T does NOT have T as a neighbor!\n");
            mexPrintf("       Neighbors must be recipricol!\n");
            mexErrMsgTxt("ERROR: check your neighbor data structure for consistency!");
            }
        // N(B)_k = s0
        N_of_B[index_to_change] = s0;
        Neighbor->Overwrite((int)(B_Neighbor_of_t0 - 1), N_of_B); // use C-style indexing
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* adjust subdomains: t0 is the old triangle index (which has already been changed)
                      s0 is the other newly created triangle index
                      e0 is the longest edge local index with respect to the ORIGINAL t0
                      V  is the (specially ordered) global vertex indices of the ORIGINAL t0
*/
void Rivara_Bisection_Class::Adjust_Subdomains(const unsigned int& t0, const unsigned int& s0, // inputs
                                               const unsigned int& e0)                         // inputs
{
    // if there are subdomains
    if (SUB!=NULL)
        {
        // then adjust the local indexing structures to reflect the altered mesh (b/c of bisection)
        unsigned int num_sub_domains = (unsigned int) SUB->size();
        for (unsigned int i = 0; i < num_sub_domains; i++)
            (*SUB)[i].Adjust_Subdomain(t0,s0,e0);
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* get the longest edge (local index) in a given triangle
   and the two global vertex indices that correspond to that edge
*/
void Rivara_Bisection_Class::Find_Longest_Edge(const unsigned int& tri_index,   // inputs
                                                     TERMINAL_TRI& term_tri)    // outputs
{
    // read in the vertices of the triangle
    unsigned int Tri_DoF[3] = {0, 0, 0};
    Tri->Read((int) tri_index-1, Tri_DoF); // use C-style indexing
    //mexPrintf("Tri_DoF = %d %d %d\n",Tri_DoF[0], Tri_DoF[1], Tri_DoF[2]);
    const double d0 = Compute_Distance(Tri_DoF[1], Tri_DoF[2]);
    const double d1 = Compute_Distance(Tri_DoF[2], Tri_DoF[0]);
    const double d2 = Compute_Distance(Tri_DoF[0], Tri_DoF[1]);

    term_tri.edge_index = argmax_of_three(d0, d1, d2);
    if (term_tri.edge_index==0)
        {
        term_tri.LE_vtx_index[0] = (int) Tri_DoF[1];
        term_tri.LE_vtx_index[1] = (int) Tri_DoF[2];
        }
    else if (term_tri.edge_index==1)
        {
        term_tri.LE_vtx_index[0] = (int) Tri_DoF[2];
        term_tri.LE_vtx_index[1] = (int) Tri_DoF[0];
        }
    else
        {
        term_tri.LE_vtx_index[0] = (int) Tri_DoF[0];
        term_tri.LE_vtx_index[1] = (int) Tri_DoF[1];
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* compute distance between two vertices */
double Rivara_Bisection_Class::Compute_Distance(const unsigned int& V1, const unsigned int& V2)  // inputs
{
    // read in the vertex coordinates
    double V1_Coord[3]; // max dimension is 3
    double V2_Coord[3]; // max dimension is 3
    Vtx->Read((int) (V1-1), V1_Coord); // use C-style indexing
    Vtx->Read((int) (V2-1), V2_Coord); // use C-style indexing

    double dist_sq = 0.0;
    for (unsigned int gd_i = 0; (gd_i < GeoDim); gd_i++)
        {
        double temp1 = V1_Coord[gd_i] - V2_Coord[gd_i];
        dist_sq += temp1*temp1;
        }
    return sqrt(dist_sq);
}
/***************************************************************************************/


/***************************************************************************************/
/* compute mid-point between two vertices */
void Rivara_Bisection_Class::Compute_Mid_Point(const unsigned int& V1, const unsigned int& V2,  // inputs
                                               double*             MidPt)                       // output
{
    // read in the vertex coordinates
    double V1_Coord[3] = {0,0,0}; // max dimension is 3
    double V2_Coord[3] = {0,0,0}; // max dimension is 3
    Vtx->Read((int) (V1-1), V1_Coord); // use C-style indexing
    Vtx->Read((int) (V2-1), V2_Coord); // use C-style indexing

    for (unsigned int gd_i = 0; (gd_i < GeoDim); gd_i++)
        MidPt[gd_i] = 0.5*(V1_Coord[gd_i] + V2_Coord[gd_i]);
}
/***************************************************************************************/

// simple argmax function
inline int argmax_of_three(const double& d0, const double& d1, const double& d2)  // inputs
{
    int arg = -1;
    if (d1 > d0)
        {
        if (d2 > d1)
            arg = 2;
        else
            arg = 1;
        }
    else
        {
        if (d2 > d0)
            arg = 2;
        else
            arg = 0;
        }
    return arg;
}

/***/
