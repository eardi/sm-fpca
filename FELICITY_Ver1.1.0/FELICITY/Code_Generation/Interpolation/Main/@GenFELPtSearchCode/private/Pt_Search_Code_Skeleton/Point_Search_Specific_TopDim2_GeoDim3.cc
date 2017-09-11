/***************************************************************************************/
/* this searches for the given points in the sub-domain
   note: topological dimension is 2
           geometric dimension is 3  */
void SpecificSEARCH::Find_Points()
{
    const unsigned int Num_Pts_To_Find = Found_Points->Num_Pts;

    // loop through each point
    for (unsigned int Pt_Ind = 0; Pt_Ind < Num_Pts_To_Find; Pt_Ind++)
        {
        PT_DATA_Top2_Geo3  Pt_Data;
        // init
		Init_Barycenter(Pt_Data.local_pt);

        // get the initial guess for the enclosing cell index
        Pt_Data.cell_index = Found_Points->Cell_Index[Pt_Ind] - 1; // need to offset for C-style indexing

        // get the (fixed) global point (for which we are trying to find the closest point to)
        Search_Data->Read_Global_X(Pt_Ind,Pt_Data.global_pt.v);

        // find the *nearest* (cell, local reference domain coordinates)
        const bool FOUND = Find_Single_Point(Pt_Data);

        if (FOUND)
            {
            // store it!
            Found_Points->Cell_Index[Pt_Ind] = Pt_Data.cell_index + 1; // put it back to MATLAB-style indexing
            Found_Points->Write_Local_X(Pt_Ind,Pt_Data.local_pt.v);
            }
        else // not found, so store NULL data
            {
            Found_Points->Cell_Index[Pt_Ind] = 0; // indicates invalid cell
            static const double ZZ[3] = {0.0, 0.0, 0.0};
            Found_Points->Write_Local_X(Pt_Ind,ZZ);
            }
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Note: the standard reference triangle looks like this:

      q

      ^
      |
      |
    v2
      #
      |\
      | \
      |  \
    S1|   \ S0
      |    \
      |     \
      |      \
      #-------#    ---> p
    v0    S2   v1

    vertex 0:  v0 = (0,0)
    vertex 1:  v1 = (1,0)
    vertex 2:  v2 = (0,1)

    side 0:    S0 = (v1,v2)
    side 1:    S1 = (v2,v0)
    side 2:    S2 = (v0,v1)
*/

/* If the minimum was on the side of a previous cell, then when we move to the adjoining cell,
   we already know the location of the minimum on the *adjoining side*.
   so, just translate the local coordinates (p,q) accordingly. */
inline void Translate_Line_Search_Data_Side0(const int& Old_Side_Index,
                                             Min_On_Cell_Top2& Old_Min,
                                             Min_On_Cell_Top2& New_Min)
{
    // new side index is 0

    if (Old_Side_Index==0) // if old side index was 0, then
        {
        // flip coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = Old_Min.x.v[1]; // p = q
        New_Min.x.v[1] = Old_Min.x.v[0]; // q = p
        }
    else if (Old_Side_Index==1) // if old side index was 1, then
        {
        // shift coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[1] = Old_Min.x.v[1];       // q = q
        New_Min.x.v[0] = 1.0 - New_Min.x.v[1]; // p = 1 - q
        }
    else if (Old_Side_Index==2) // if old side index was 2, then
        {
        // shift coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = Old_Min.x.v[0];       // p = p
        New_Min.x.v[1] = 1.0 - New_Min.x.v[0]; // q = 1 - p
        }
}
inline void Translate_Line_Search_Data_Side1(const int& Old_Side_Index,
                                             Min_On_Cell_Top2& Old_Min,
                                             Min_On_Cell_Top2& New_Min)
{
    // new side index is 1

    if (Old_Side_Index==0) // if old side index was 0, then
        {
        // shift coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = 0.0;            // p = 0
        New_Min.x.v[1] = Old_Min.x.v[1]; // q = q
        }
    else if (Old_Side_Index==1) // if old side index was 1, then
        {
        // flip coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = 0.0;                  // p = 0
        New_Min.x.v[1] = 1.0 - Old_Min.x.v[1]; // q = 1 - q
        }
    else if (Old_Side_Index==2) // if old side index was 2, then
        {
        // shift coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = 0.0;            // p = 0
        New_Min.x.v[1] = Old_Min.x.v[0]; // q = p (old)
        }
}
inline void Translate_Line_Search_Data_Side2(const int& Old_Side_Index,
                                             Min_On_Cell_Top2& Old_Min,
                                             Min_On_Cell_Top2& New_Min)
{
    // new side index is 2

    if (Old_Side_Index==0) // if old side index was 0, then
        {
        // shift coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = Old_Min.x.v[0]; // p = p
        New_Min.x.v[1] = 0.0;            // q = 0
        }
    else if (Old_Side_Index==1) // if old side index was 1, then
        {
        New_Min.x.v[0] = Old_Min.x.v[1]; // p = q
        New_Min.x.v[1] = 0.0;            // q = 0
        }
    else if (Old_Side_Index==2) // if old side index was 2, then
        {
        // flip coordinates (assuming that all adjoining triangles have consistent orientation)
        New_Min.x.v[0] = 1.0 - Old_Min.x.v[0]; // p = 1 - p
        New_Min.x.v[1] = 0.0;                  // q = 0
        }
}
/***************************************************************************************/


/***************************************************************************************/
/* Starting from the minimum on the boundary of the ref triangle, determine whether
   that is the minimum over the entire ref triangle.
   If the minimum over the entire ref triangle is on the boundary, then
   return 1 or 2 possible local neighbors to move to next (in order to keep
   searching for the global minimum).
   If the minimum is inside the ref triangle, then do not return any neighbors.
   (in this case, one needs to do some gradient descent within the cell.)

   local_neighbors[0,1] = local neighbor indices
         value: 0,1,2 (local neighbor (side) indices)
         value: -1 (no valid local neighbor)
*/
void Determine_Neighbors_From_Min_On_Triangle_Bdy(const VEC_2x1& Local_p, const VEC_2x1& Grad,
                                                  const int& side_index,  const double& TOL,
                                                  int local_neighbors[2])
{
    // define normal vectors of triangle sides
    static const double N0[2] = {INV_SQRT_2, INV_SQRT_2}; // Side 0
    static const double N1[2] = {-1.0,  0.0}; // Side 1
    static const double N2[2] = { 0.0, -1.0}; // Side 2

    // convenient variables
    double DP0 = 0.0;
    double DP1 = 0.0;
    double DP2 = 0.0;

    // init to no valid neighbors
    local_neighbors[0] = -1;
    local_neighbors[1] = -1;

    // if the gradient at the given minimum location (on the bdy) points *outside* the ref triangle
    // then the actual global minimum is *inside* the ref triangle (most likely anyway)
    // otherwise, the global minimum is in another cell, so return potential neighbors to search

    if (side_index==0) // min is on Side 0
        {
        // compute trend of cost across Side 0
        DP0 = N0[0]*Grad.v[0] + N0[1]*Grad.v[1];
        //mexPrintf("DP0 = %1.5f.\n",DP0);

        // if we are near a corner vertex of the reference triangle,
        //      then we need to also check the adjacent side that shares the corner vertex
        // i.e. the gradient must point away from *both sides* in order to say
        //      that the global minimum is inside the ref triangle.

        // if we are close to the top corner vertex, then check Side 1 also
        if (Local_p.v[0] < TOL) // (p,q) ~ (0,1)
            {
            DP1 = N1[0]*Grad.v[0] + N1[1]*Grad.v[1];
            //mexPrintf("DP1 = %1.5f.\n",DP1);

            if ( (DP0 < -TOL) || (DP1 < -TOL) ) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] = 0;
                local_neighbors[1] = 1;
                }
            }
        // else if we are close to the bottom-right corner vertex, then check Side 2 also
        else if (1.0 - Local_p.v[0] < TOL) // (p,q) ~ (1,0)
            {
            DP2 = N2[0]*Grad.v[0] + N2[1]*Grad.v[1];
            //mexPrintf("DP2 = %1.5f.\n",DP2);

            if ( (DP0 < -TOL) || (DP2 < -TOL) ) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] = 0;
                local_neighbors[1] = 2;
                }
            }
        else // we are away from the corners
            {
            if (DP0 < -TOL) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] =  0;
                local_neighbors[1] = -1; // null
                }
            }
        // note: if DP ~ 0, then minimum is (probably) exactly on the boundary,
        //       so need to search neighbors.
        }
    else if (side_index==1) // min is on Side 1
        {
        // compute trend of cost across Side 1
        DP1 = N1[0]*Grad.v[0] + N1[1]*Grad.v[1];
        //mexPrintf("DP1 = %1.5f.\n",DP1);

        // if we are near a corner vertex of the reference triangle,
        //      then we need to also check the adjacent side that shares the corner vertex
        // i.e. the gradient must point away from *both sides* in order to say
        //      that the global minimum is inside the ref triangle.

        // if we are close to the top corner vertex, then check Side 0 also
        if (1.0 - Local_p.v[1] < TOL) // (p,q) ~ (0,1)
            {
            DP0 = N0[0]*Grad.v[0] + N0[1]*Grad.v[1];
            //mexPrintf("DP0 = %1.5f.\n",DP0);

            if ( (DP1 < -TOL) || (DP0 < -TOL) ) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] = 1;
                local_neighbors[1] = 0;
                }
            }
        // else if we are close to the bottom-left corner vertex, then check Side 2 also
        else if (Local_p.v[1] < TOL) // (p,q) ~ (0,0)
            {
            DP2 = N2[0]*Grad.v[0] + N2[1]*Grad.v[1];
            //mexPrintf("DP2 = %1.5f.\n",DP2);

            if ( (DP1 < -TOL) || (DP2 < -TOL) ) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] = 1;
                local_neighbors[1] = 2;
                }
            }
        else // we are away from the corners
            {
            if (DP1 < -TOL) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] =  1;
                local_neighbors[1] = -1; // null
                }
            }
        // note: if DP ~ 0, then minimum is (probably) exactly on the boundary,
        //       so need to search neighbors.
        }
    else if (side_index==2) // min is on Side 2
        {
        // compute trend of cost across Side 2
        DP2 = N2[0]*Grad.v[0] + N2[1]*Grad.v[1];
        //mexPrintf("DP2 = %1.5f.\n",DP2);

        // if we are near a corner vertex of the reference triangle,
        //      then we need to also check the adjacent side that shares the corner vertex
        // i.e. the gradient must point away from *both sides* in order to say
        //      that the global minimum is inside the ref triangle.

        // if we are close to the bottom-left corner vertex, then check Side 1 also
        if (Local_p.v[0] < TOL) // (p,q) ~ (0,0)
            {
            DP1 = N1[0]*Grad.v[0] + N1[1]*Grad.v[1];
            //mexPrintf("DP1 = %1.5f.\n",DP1);

            if ( (DP2 < -TOL) || (DP1 < -TOL) ) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] = 2;
                local_neighbors[1] = 1;
                }
            }
        // else if we are close to the bottom-right corner vertex, then check Side 0 also
        else if (1.0 - Local_p.v[0] < TOL) // (p,q) ~ (1,0)
            {
            DP0 = N0[0]*Grad.v[0] + N0[1]*Grad.v[1];
            //mexPrintf("DP0 = %1.5f.\n",DP0);

            if ( (DP2 < -TOL) || (DP0 < -TOL) ) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] = 2;
                local_neighbors[1] = 0;
                }
            }
        else // we are away from the corners
            {
            if (DP2 < -TOL) // the cost decreases outside the cell
                {
                // potential neighbors to search
                local_neighbors[0] =  2;
                local_neighbors[1] = -1; // null
                }
            }
        // note: if DP ~ 0, then minimum is (probably) exactly on the boundary,
        //       so need to search neighbors.
        }
    // else there are no valid neighbors (already set above)
}
/***************************************************************************************/


/***************************************************************************************/
/* get cell_index of local neighbor (if it is valid).
   cell_index is modified by this routine (if it is valid).
   adj_side_index is set by this routine (if local neighbor is valid)
   Note: valid means the neighbor exists, and it has not been visited before.

   returns true/false indicating if the neighbor was valid.
*/
bool SpecificSEARCH::Get_Valid_Neighbor(unsigned int& cell_index, int& adj_side_index,
                                        const int& local_neighbor,
                                        const unsigned int* cell_index_queue,
                                        const unsigned int& queue_size)
{
    bool VALID = false; // init: assume the neighbor is not valid

    if (local_neighbor >= 0) // if there is a potential neighbor
        {
        // get neighbor info
        const unsigned int neighbor_cell_index =
                           Search_Data->Neighbor[local_neighbor][cell_index]; // MATLAB-style indexing

        // if the neighbor exists
        if (neighbor_cell_index > 0)
            {
            // make sure we have not visited this neighbor cell before

            const unsigned int new_ci_C_style = neighbor_cell_index - 1; // C-style indexing

            // have we *not* visited this cell before?
            if ( !is_element_in_array(cell_index_queue, queue_size, new_ci_C_style) )
                {
                // if so, we can move to that neighbor
                VALID = true;
                const unsigned int prev_cell_index_M_style = cell_index + 1; // use below
                // update the cell index
                cell_index = new_ci_C_style;

                // find the side index in the new cell that adjoins the previous cell
                adj_side_index = -1; // init
                // find neighbor of new cell that matches the previous cell
                if (Search_Data->Neighbor[0][cell_index]==prev_cell_index_M_style)
                    adj_side_index = 0;
                else if (Search_Data->Neighbor[1][cell_index]==prev_cell_index_M_style)
                    adj_side_index = 1;
                else if (Search_Data->Neighbor[2][cell_index]==prev_cell_index_M_style)
                    adj_side_index = 2;
                }
            }
        }

    return VALID;
}
/***************************************************************************************/


/***************************************************************************************/
/* search for the nearest point in the sub-domain.
  (Pt_Data.cell_index and Pt_Data.local_pt will be modified by this.) */
bool SpecificSEARCH::Find_Single_Point(PT_DATA_Top2_Geo3& Pt_Data)
{
    bool FOUND = false; // assume we do not find it

    // variables for searching for minimum
    Min_On_Cell_Top2  Min_On_Tri;
    // init the cell index to start from
    unsigned int current_cell_index = Pt_Data.cell_index;

    // keep track of which cells are visited
    unsigned int cell_index_queue[MAX_QUEUE_SIZE];
    unsigned int queue_size = 0;

    // store local neighbor choices
    int local_neighbors[2] = {-1, -1};

    // pre-compute the minimum on the first cell
    Compute_Min_On_Triangle(Pt_Data.global_pt, current_cell_index, -1, 0,
                            cell_index_queue, queue_size,
                            Min_On_Tri, local_neighbors);

    // iterate (i.e. traverse the mesh)
    //     until there are no new triangles to search (worst case)
    const unsigned int MAX_CELL_ITER = Search_Data->Num_Cells + 1;
    for (unsigned int ind = 0; ind < MAX_CELL_ITER; ind++)
        {
        FOUND =
        Find_Single_Point_Sub_Iter(Pt_Data.global_pt, current_cell_index,
                                   cell_index_queue, queue_size, Min_On_Tri, local_neighbors);
        if (FOUND) break;
        }

    // return the found minimum in the struct Pt_Data
    Pt_Data.cell_index = current_cell_index;
	Pt_Data.local_pt.Set_Equal_To(Min_On_Tri.x);

    return FOUND;
}
/***************************************************************************************/


/***************************************************************************************/
/* this is one iteration of the FOR loop in Find_Single_Point.
   Note: this expects the minimum on cell_index to already be computed in Min_On_Tri!

   Based on the incoming minimum data (and potential neighbors), this routine chooses
   a neighbor cell to go to next and computes the minimum on that neighbor cell.

   cell_index = index for the current cell.
   Note: local_neighbors[0,1] = two local neighbor indices
         value: 0,1,2 (local neighbor (side) indices of the current cell)
         value: -1 (no valid local neighbor)
   Also see the routine: "Determine_Neighbors_From_Min_On_Triangle_Bdy"
*/
bool SpecificSEARCH::Find_Single_Point_Sub_Iter(const VEC_3x1& Global_X,
                                                unsigned int& cell_index,
                                                unsigned int* cell_index_queue,
                                                unsigned int& queue_size,
                                                Min_On_Cell_Top2& Min_On_Tri,
                                                int local_neighbors[2])
{
    bool FOUND = false; // assume we do not find the minimum

    // determine valid neighbors
    // Note: we guess that neighbor A <=> local_neighbors[0]
    //       will be the one we go to
    int adj_side_index; // temp variable

    // create auxiliary variables for neighbor B <=> local_neighbors[1]
    unsigned int     cell_index_B = cell_index; // init
             int adj_side_index_B;

    // get local neighbor (side) indices for current cell_index
    const int local_neighbor_index_A = local_neighbors[0];
    const int local_neighbor_index_B = local_neighbors[1];

    // determine which neighbors are available to move to
    // note: this updates cell_index and sets adj_side_index
    bool valid_nb_A = Get_Valid_Neighbor(cell_index, adj_side_index, local_neighbor_index_A,
                                         cell_index_queue, queue_size);
    bool valid_nb_B = Get_Valid_Neighbor(cell_index_B, adj_side_index_B, local_neighbor_index_B,
                                         cell_index_queue, queue_size);

    // if both neighbors are viable
    if ( (valid_nb_A) && (valid_nb_B) )
        {
        // compare both neighbors
        // i.e. "look ahead" at the minimum cost on both neighbors
        //mexPrintf("TEST: BEGIN: try two neighbors:  %d  or  %d  !\n",cell_index+1,cell_index_B+1);

        // create auxiliary variables for neighbor B
        Min_On_Cell_Top2  Min_On_Tri_B;
        Copy_Min_On_Cell(Min_On_Tri, Min_On_Tri_B); // init
        int local_neighbors_B[2] = {-1, -1}; // init

        // find min on neighbor A
        Compute_Min_On_Triangle(Global_X, cell_index, adj_side_index, local_neighbor_index_A,
                                cell_index_queue, queue_size,
                                Min_On_Tri, local_neighbors);

        // find min on neighbor B
        Compute_Min_On_Triangle(Global_X, cell_index_B, adj_side_index_B, local_neighbor_index_B,
                                cell_index_queue, queue_size,
                                Min_On_Tri_B, local_neighbors_B);

        // now choose the neighbor with lowest cost to go to
        if (Min_On_Tri_B.Cx.a < Min_On_Tri.Cx.a)
            {
            // then move to neighbor B

            // update main variables
            Copy_Min_On_Cell(Min_On_Tri_B, Min_On_Tri);
            local_neighbors[0] = local_neighbors_B[0];
            local_neighbors[1] = local_neighbors_B[1];
            cell_index = cell_index_B;
            adj_side_index = adj_side_index_B;
            }
        // else move to neighbor A (variables are already updated)

        //mexPrintf("TEST: choose this cell_index: %d.\n",cell_index+1);
        //mexPrintf("TEST: END: try two neighbors!\n\n");
        }
    else if (valid_nb_A)
        {
        // then move to neighbor A

        // compute min for next iteration
        Compute_Min_On_Triangle(Global_X, cell_index, adj_side_index, local_neighbor_index_A,
                                cell_index_queue, queue_size,
                                Min_On_Tri, local_neighbors);
        }
    else if (valid_nb_B)
        {
        // then move to neighbor B

        // update main variables
        cell_index = cell_index_B;
        adj_side_index = adj_side_index_B;

        // compute min for next iteration
        Compute_Min_On_Triangle(Global_X, cell_index, adj_side_index, local_neighbor_index_B,
                                cell_index_queue, queue_size,
                                Min_On_Tri, local_neighbors);
        }
    else
        {
        // there are no neighbors to move to,
        // so the global minimum is in this cell
        //      and is already computed.
        FOUND = true;
        }

    return FOUND;
}
/***************************************************************************************/


/***************************************************************************************/
/* compute minimum on a given triangle.
   Global_X = needed to compute cost and gradient.
   cell_index = index of the *new* cell to compute minimum on.
   adj_side_index = local index (0,1,2) of the side in the *new* cell that adjoins
                    the *previous* cell visited. -1 indicates no adjoining side;
                    this would be the case if there is *no previous* cell.
   prev_min_side_index = local index (0,1,2) of the side in the *previous* cell
                         on which the minimum in 'Min_On_Tri' lies.
   cell_index_queue, queue_size = array for keeping track of which cells have been
                                  recently visited.
   Min_On_Tri = either contains invalid data, or it contains the minimum data
                on the *previous* cell visited.
   local_neighbors = potential neighbors to visit *next* time.
*/
void SpecificSEARCH::Compute_Min_On_Triangle(const VEC_3x1& Global_X,
                                             const unsigned int& cell_index,
                                             const int& adj_side_index,
                                             const int& prev_min_side_index,
                                             unsigned int* cell_index_queue,
                                             unsigned int& queue_size,
                                             Min_On_Cell_Top2& Min_On_Tri,
                                             int local_neighbors[2])
{
    // variables for performing optimization searches
    Min_On_Cell_Top2  Cost_at_V[3];   // holds cost and gradient at vertices 0,1,2
    Min_On_Cell_Top2  Min_On_Side[4]; // 0,1,2 are for computing min on sides 0,1,2
                                      // 3 is for computing cost at barycenter
    Min_On_Cell_Top2  Window_End; // holds opposite end of line search window
    VEC_2x1  unit_vec; // for computing directional derivative

    /* BEGIN: keep track of which cells have been visited. */
    // if the queue of elements exceeds the MAX, then reset it!
    if (queue_size >= MAX_QUEUE_SIZE) queue_size = 0;
    // record the cell you are looking at:
    cell_index_queue[queue_size] = cell_index;
    queue_size++; // update size
    /* END: keep track of which cells have been visited. */

    // pass cell index of the current triangle in order to compute the correct local map
    Domain->Read_Embed_Data(cell_index);
    //mexPrintf("\n\n");
    //mexPrintf("TEST: computing minimum on this cell_index: %d.\n",cell_index+1);

    // first, compute cost and gradient at the three vertices of the ref triangle
    Cost_at_V[0].x.v[0] = 0.0; Cost_at_V[0].x.v[1] = 0.0;
    Eval_Cost_And_Gradient(Global_X, Cost_at_V[0].x, Cost_at_V[0].Cx, Cost_at_V[0].Grad_Cx);
    Cost_at_V[1].x.v[0] = 1.0; Cost_at_V[1].x.v[1] = 0.0;
    Eval_Cost_And_Gradient(Global_X, Cost_at_V[1].x, Cost_at_V[1].Cx, Cost_at_V[1].Grad_Cx);
    Cost_at_V[2].x.v[0] = 0.0; Cost_at_V[2].x.v[1] = 1.0;
    Eval_Cost_And_Gradient(Global_X, Cost_at_V[2].x, Cost_at_V[2].Cx, Cost_at_V[2].Grad_Cx);

    // next, line-search the three sides of the reference triangle

    double Cost_Difference = 0.0; // init

    // line search on Side 0
    if (adj_side_index==0)
        {
        // don't need to line search again; just transfer data from before
        Translate_Line_Search_Data_Side0(prev_min_side_index, Min_On_Tri, Min_On_Side[0]);
        Eval_Cost_And_Gradient(Global_X, Min_On_Side[0].x, Min_On_Side[0].Cx, Min_On_Side[0].Grad_Cx);
        Cost_Difference = Min_On_Side[0].Cx.a - Min_On_Tri.Cx.a; // for error checking
        }
    else
        {
        // unit_vec = ( -1/sqrt(2), 1/sqrt(2) )
        unit_vec.v[0] = -INV_SQRT_2; unit_vec.v[1] = INV_SQRT_2;
        Copy_Min_On_Cell(Cost_at_V[1], Min_On_Side[0]);
        Copy_Min_On_Cell(Cost_at_V[2], Window_End);
        Bisection_And_Cubic_Line_Search(Global_X, unit_vec, NUM_INTERMEDIATE_PTS, OPT_TOL, Min_On_Side[0], Window_End);
        }

    // line search on Side 1
    if (adj_side_index==1)
        {
        // don't need to line search again; just transfer data from before
        Translate_Line_Search_Data_Side1(prev_min_side_index, Min_On_Tri, Min_On_Side[1]);
        Eval_Cost_And_Gradient(Global_X, Min_On_Side[1].x, Min_On_Side[1].Cx, Min_On_Side[1].Grad_Cx);
        Cost_Difference = Min_On_Side[1].Cx.a - Min_On_Tri.Cx.a; // for error checking
        }
    else
        {
        // unit_vec = ( 0, -1 )
        unit_vec.v[0] = 0.0; unit_vec.v[1] = -1.0;
        Copy_Min_On_Cell(Cost_at_V[2], Min_On_Side[1]);
        Copy_Min_On_Cell(Cost_at_V[0], Window_End);
        Bisection_And_Cubic_Line_Search(Global_X, unit_vec, NUM_INTERMEDIATE_PTS, OPT_TOL, Min_On_Side[1], Window_End);
        }

    // line search on Side 2
    if (adj_side_index==2)
        {
        // don't need to line search again; just transfer data from before
        Translate_Line_Search_Data_Side2(prev_min_side_index, Min_On_Tri, Min_On_Side[2]);
        Eval_Cost_And_Gradient(Global_X, Min_On_Side[2].x, Min_On_Side[2].Cx, Min_On_Side[2].Grad_Cx);
        Cost_Difference = Min_On_Side[2].Cx.a - Min_On_Tri.Cx.a; // for error checking
        }
    else
        {
        // unit_vec = ( 1, 0 )
        unit_vec.v[0] = 1.0; unit_vec.v[1] = 0.0;
        Copy_Min_On_Cell(Cost_at_V[0], Min_On_Side[2]);
        Copy_Min_On_Cell(Cost_at_V[1], Window_End);
        Bisection_And_Cubic_Line_Search(Global_X, unit_vec, NUM_INTERMEDIATE_PTS, OPT_TOL, Min_On_Side[2], Window_End);
        }
    /* simple error check */
    if (Cost_Difference > 1E-14)
        {
        mexPrintf("ERROR: adj_side_index = %d.\n",adj_side_index);
        mexPrintf("ERROR: prev_min_side_index = %d.\n",prev_min_side_index);
        mexPrintf("ERROR: Cost_Difference = %1.5G.\n",Cost_Difference);
        mexPrintf("ERROR: An inconsistency has been found while point searching the mesh.\n");
        mexPrintf("ERROR: Cell neighbors are not correctly defined!\n");
        mexPrintf("ERROR: There is something wrong with how the mesh (or neighbors) is defined!\n");
        mexPrintf("ERROR: The results cannot be guaranteed!\n");
        }

    // next, compute the cost at barycenter to see if it is better
	Init_Barycenter(Min_On_Side[3].x);
    Eval_Cost_And_Gradient(Global_X, Min_On_Side[3].x, Min_On_Side[3].Cx, Min_On_Side[3].Grad_Cx);

    // find the best one
    unsigned int argmin = 0;
    double  current_min = Min_On_Side[0].Cx.a;
    for (unsigned int jj = 1; jj < 4; jj++)
        {
        if (Min_On_Side[jj].Cx.a < current_min)
            {
            argmin = jj;
            current_min = Min_On_Side[jj].Cx.a;
            }
        }
    // set the guess for the closest point to be the best we know so far
    Copy_Min_On_Cell(Min_On_Side[argmin], Min_On_Tri);
    //mexPrintf("TEST: min is on side: %d.\n",argmin);

    // variable to store which side of ref triangle the minimum is on
    int min_side_index = -1; // -1 indicates min is in the *interior* (not on a side)
    if (argmin < 3) // 0, 1, or 2
        {
        // the minimum *might* be on a side of the cell,
        //     but we don't know for sure yet.

        // for now, indicate that minimum is on a side of the cell
        min_side_index = argmin;
        }

    // now determine if the minimum is within the cell or is outside it.
    // if it is outside, return 1 or 2 potential neighbors to check next
    // else, do not visit any new neighbors
    Determine_Neighbors_From_Min_On_Triangle_Bdy(
                             Min_On_Tri.x, Min_On_Tri.Grad_Cx, min_side_index,
                             OPT_TOL, local_neighbors);

    // if there are no neighbors to search
    if ( (local_neighbors[0]==-1) && (local_neighbors[1]==-1) )
        {
        // then the minimum is within the current cell,
        //      so run gradient descent to find it (done!)
        const bool CONVERGED = Run_Gradient_Descent(Global_X, Min_On_Tri, OPT_TOL);
        if (!CONVERGED)
            mexPrintf("Gradient Descent did *not* converge!\n");
        }
    // else we have the minimum on one of the sides

    //mexPrintf("TEST: local coordinates of minimum: %1.5f, %1.5f.\n",Min_On_Tri.x.v[0],Min_On_Tri.x.v[1]);
}
/***************************************************************************************/


/***************************************************************************************/
/* run gradient descent within the current cell.
   Note: Min_On_Tri.x, .Cx, .Grad_Cx, is modified by this.
   Note: initial cost and gradient is already computed for Min_On_Tri.
   returns true/false indicating whether it converged or not.
*/
bool SpecificSEARCH::Run_Gradient_Descent(const VEC_3x1& Global_X,
                                          Min_On_Cell_Top2& Min_On_Tri,
                                          const double& TOL)
{
    // useful variables
    VEC_2x1 unit_vec, prev_pt;
    // init to the starting point
	prev_pt.Set_Equal_To(Min_On_Tri.x);

    // loop until converged
    unsigned int iter;
    for (iter = 0; iter < MAX_GRADIENT_DESCENT_ITER; iter++)
        {
        // note: cost and gradient are already computed

        // norm of gradient
        const double Mag_Grad = l2_norm(Min_On_Tri.Grad_Cx);
        if (Mag_Grad < TOL)
            break; // you are at the minimum!
        else
            {
            // get search direction

            // approximate the Hessian of the cost functional
            MAT_2x2 Hessian;
            Mat_Transpose_Mat_Self(GeomFunc->Map_PHI_Grad[0], Hessian);
            SCALAR Hessian_Det_Inv;
            const double Hessian_Det = Determinant(Hessian);
            if (Hessian_Det < 1E-14)
                {
                // use identity for hessian,
                // i.e. compute search direction by standard gradient descent

                // get unit vector parallel to -gradient
                unit_vec.v[0] = -Min_On_Tri.Grad_Cx.v[0] / Mag_Grad;
                unit_vec.v[1] = -Min_On_Tri.Grad_Cx.v[1] / Mag_Grad;
                }
            else
                {
                Hessian_Det_Inv.a = 1.0 / Hessian_Det;
                MAT_2x2 Hessian_Inv;
                Matrix_Inverse(Hessian, Hessian_Det_Inv, Hessian_Inv);
                VEC_2x1 direction;
                // compute direction = Hessian^{-1} * Grad_Cx
                // i.e. this pre-conditions the gradient
                Mat_Vec(Hessian_Inv, Min_On_Tri.Grad_Cx, direction);

                // get unit vector along -direction
                const double Mag_dir = l2_norm(direction);
                unit_vec.v[0] = -direction.v[0] / Mag_dir;
                unit_vec.v[1] = -direction.v[1] / Mag_dir;
                }
            }

        // compute search window (how far along unit_vec to search)
        double t_var[3] = {1.5, 1.5, 1.5}; // init

        // compute intersection with Side 1
        if (unit_vec.v[0] < 0.0)
            t_var[0] = -Min_On_Tri.x.v[0] / unit_vec.v[0];

        // compute intersection with Side 2
        if (unit_vec.v[1] < 0.0)
            t_var[1] = -Min_On_Tri.x.v[1] / unit_vec.v[1];

        // compute intersection with Side 0
        const double u3 = unit_vec.v[0] + unit_vec.v[1];
        if (u3 > 0.0)
            t_var[2] = (1.0 - Min_On_Tri.x.v[0] - Min_On_Tri.x.v[1]) / u3;

        // take the smallest
        const double t0 = *std::min_element(t_var,t_var+3);

        // check that it is less than 1.5; otherwise there is an error!!!
        if (t0 > 1.5) mexErrMsgTxt("ERROR: the gradient descent made an impossible error!");

        // search window is too small, so stop
        if (t0 < TOL) break;
        // note: t0 should never be negative, but if it is we should also stop!

        // compute other end point of window
        Min_On_Cell_Top2  End;
        End.x.v[0] = Min_On_Tri.x.v[0] + t0 * unit_vec.v[0];
        End.x.v[1] = Min_On_Tri.x.v[1] + t0 * unit_vec.v[1];
        // compute cost and gradient info at the end of search window
        Eval_Cost_And_Gradient(Global_X, End.x, End.Cx, End.Grad_Cx);

        // line search it
        Bisection_And_Cubic_Line_Search(Global_X, unit_vec, NUM_INTERMEDIATE_PTS, TOL, Min_On_Tri, End);
        // note: Min_On_Tri now has the most recent Cost and Gradient;
        //       needed for the next iteration.

        // check convergence criteria
        VEC_2x1 DIFF;
        Subtract_Vector(Min_On_Tri.x, prev_pt, DIFF);
        const double DIFF_NORM = l2_norm(DIFF);
        // if converged, then stop iterating
        if (DIFF_NORM < TOL) break;

        // update the previous point
		prev_pt.Set_Equal_To(Min_On_Tri.x);
        }
    //mexPrintf("Number of Gradient Descent iterations: %d.\n",iter+1);

    // make sure the minimum point is inside the closure of the reference cell
    Project_Onto_Ref_Cell(Min_On_Tri.x, TOL);
    // recompute to be consistent
    Eval_Cost_And_Gradient(Global_X, Min_On_Tri.x, Min_On_Tri.Cx, Min_On_Tri.Grad_Cx);

    if (iter < MAX_GRADIENT_DESCENT_ITER)
        return true;  // optimization converged
    else
        return false; // optimization did not converge
}
/***************************************************************************************/


/***************************************************************************************/
/* Compute Cost := 1/2 (PHI(local) - global)^2.
   note: make sure we are on the correct cell before running this
  (i.e. get embedding data before running this)! */
double SpecificSEARCH::Eval_Cost(const VEC_3x1& global_pt, const VEC_2x1& local_pt)
{
    // compute local element transformation
	local_pt.Copy_To_Array(GeomFunc->local_coord);
    GeomFunc->Compute_Local_Transformation();

    // evaluate cost
    VEC_3x1 G_T;
    Subtract_Vector(GeomFunc->Map_PHI[0],global_pt,G_T);
    return ( 0.5 * Dot_Product(G_T, G_T) );
}
/***************************************************************************************/


/***************************************************************************************/
/* Compute Cost := 1/2 (PHI(local) - global)^2, and 2-D gradient of Cost.
   note: make sure we are on the correct cell before running this
  (i.e. get embedding data before running this)! */
void SpecificSEARCH::Eval_Cost_And_Gradient(const VEC_3x1& global_pt, const VEC_2x1& local_pt,
                                            SCALAR&  Cost,            VEC_2x1& Cost_Grad)
{
    // compute local element transformation
	local_pt.Copy_To_Array(GeomFunc->local_coord);
    GeomFunc->Compute_Local_Transformation();

    // evaluate cost
    VEC_3x1 G_T;
    Subtract_Vector(GeomFunc->Map_PHI[0],global_pt,G_T);
    Cost.a = 0.5 * Dot_Product(G_T, G_T);

    // evaluate gradient
    Vec_Transpose_Mat(G_T, GeomFunc->Map_PHI_Grad[0], Cost_Grad);
}
/***************************************************************************************/


/***************************************************************************************/
/* Compute Cost := 1/2 (PHI(local) - global)^2, and directional derivative of Cost.
   note: make sure we are on the correct cell before running this
  (i.e. get embedding data before running this)! */
void SpecificSEARCH::Eval_Cost_And_Directional_Deriv(const VEC_3x1& global_pt, const VEC_2x1& unit_vec,
                                                     const VEC_2x1& local_pt,
                                                           SCALAR&  Cost,            SCALAR& Derivative)
{
    // compute local element transformation
	local_pt.Copy_To_Array(GeomFunc->local_coord);
    GeomFunc->Compute_Local_Transformation();

    // evaluate cost
    VEC_3x1 G_T;
    Subtract_Vector(GeomFunc->Map_PHI[0],global_pt,G_T);
    Cost.a = 0.5 * Dot_Product(G_T, G_T);

    // evaluate gradient
    VEC_2x1 Cost_Grad;
    Vec_Transpose_Mat(G_T, GeomFunc->Map_PHI_Grad[0], Cost_Grad);
    Derivative.a = Dot_Product(Cost_Grad, unit_vec);
}
/***************************************************************************************/


/***************************************************************************************/
/* Run a hybrid bisection/cubic line search to find minimum in given search window.
   note the following is already initialized:
         Opt_a.x
         Opt_a.Cx
         Opt_a.Grad_Cx
         Opt_b.x
         Opt_b.Cx
         Opt_b.Grad_Cx

   Note: the minimum is returned in Opt_a.

   Num_Extra_pts: the number of intermdiate points to evaluate the function at
   to determine an initial smaller window to search.  The higher this number,
   the more likely the line search is to find the global minimum.
   TOL: the tolerance to use in finding the minimum.  If the window size,
   or the absolute value of the derivative, are ever less than TOL, then
   this signifies convergence of the algorithm (i.e. we find the minimum).
*/
void SpecificSEARCH::Bisection_And_Cubic_Line_Search(const VEC_3x1& Global_X,
                                                     const VEC_2x1& unit_vec,
                                                     const unsigned int& INPUT_Num_Extra_Pts,
                                                     const double& TOL,
                                                     Min_On_Cell_Top2& Opt_a,
                                                     Min_On_Cell_Top2& Opt_b)
{
    // these are used to evaluate the cost functional and derivative
    const VEC_3x1& X  = Global_X;
    const VEC_2x1& u  = unit_vec;

    // these are used to store the search window (which is updated)
    // note: the minimum that is found is returned in Opt_a
    VEC_2x1&       a = Opt_a.x;
    double&       fa = Opt_a.Cx.a;
    VEC_2x1& grad_fa = Opt_a.Grad_Cx;
    double       dfa = Dot_Product(grad_fa, unit_vec);

    VEC_2x1&       b = Opt_b.x;
    double&       fb = Opt_b.Cx.a;
    VEC_2x1& grad_fb = Opt_b.Grad_Cx;
    double       dfb = Dot_Product(grad_fb, unit_vec);

    // these are for the candidate point during each iteration
    Min_On_Cell_Top2    Opt_m;
    VEC_2x1&       m  = Opt_m.x;
    SCALAR& fm_scalar = Opt_m.Cx;
    double&        fm = fm_scalar.a;
    VEC_2x1&  grad_fm = Opt_m.Grad_Cx;
    double        dfm = 0.0; // init

    // don't need to compute more than MAX intermediate points (i.e. overkill)
    unsigned int Num_Extra_Pts = INPUT_Num_Extra_Pts;
    if (Num_Extra_Pts > NUM_INTERMEDIATE_PTS) Num_Extra_Pts = NUM_INTERMEDIATE_PTS; // max out

// We only need to compute intermediate points if the cell is not linear (e.g. quadratic)
// In other words, when the cell is flat, it easy to compute the minimum
//                 without the need of intermediate points.
#ifndef LINEAR_CELL

    // check which end-point has lowest function value
    int argmin;
    if (fa < fb)
        {
        argmin = -1; // indicates "a" is best value
        fm = fa;
        dfm = dfa;
        }
    else // (fa >= fb)
        {
        argmin = Num_Extra_Pts; // indicates "b" is best value
        fm = fb;
        dfm = dfb;
        }

    // allocate intermediate points
    Min_On_Cell_Top2  Opt_pts[NUM_INTERMEDIATE_PTS];
    double df_pts[NUM_INTERMEDIATE_PTS];

    const double step = 1.0 / (Num_Extra_Pts + 1.0);
    double t_var = 0.0;
    for (unsigned int ii = 0; ii < Num_Extra_Pts; ii++)
        {
        t_var += step; // increment by step
        // compute (local) coordinates of intermediate point by linear combination
        Opt_pts[ii].x.v[0] = ( (1.0 - t_var) * a.v[0] ) + ( t_var * b.v[0] );
        Opt_pts[ii].x.v[1] = ( (1.0 - t_var) * a.v[1] ) + ( t_var * b.v[1] );

        // evaluate function and derivative there
        Eval_Cost_And_Gradient(X, Opt_pts[ii].x, Opt_pts[ii].Cx, Opt_pts[ii].Grad_Cx);
        df_pts[ii] = Dot_Product(Opt_pts[ii].Grad_Cx, unit_vec);

        // update the current minimum
        if (Opt_pts[ii].Cx.a < fm)
            {
            argmin       = ii;
            fm           = Opt_pts[ii].Cx.a;
            dfm          = df_pts[ii];
            }
        }

    // if a has the minimum value
    if (argmin==-1)
        {
        // then start the search window next to a
        // update b
        Copy_Min_On_Cell(Opt_pts[0], Opt_b);
        dfb          = df_pts[0];
        }
    else if (argmin==Num_Extra_Pts) // b has the minimum value
        {
        // then start the search window next to b
        // update a
        Copy_Min_On_Cell(Opt_pts[Num_Extra_Pts-1], Opt_a);
        dfa          = df_pts[Num_Extra_Pts-1];
        }
    else // the initial minimum is inside the initial window
        {
        // choose an interval containing m

        // if derivative is small, then stop
        if (my_abs(dfm) < TOL)
            {
            // then we are done, so return the minimum in "a"
            Copy_Min_On_Cell(Opt_pts[argmin], Opt_a);
            //dfa          = dfm;
            return;
            }
        else // derivative is "big"
            {
            // narrow the search window
            if (dfm < 0)
                {
                // minimum must be to the right of m
                // set a = m
                Copy_Min_On_Cell(Opt_pts[argmin], Opt_a);
                dfa          = dfm;
                if ( argmin < (int) (Num_Extra_Pts-1) )
                    {
                    // then need to update b
                    // set b = m+1
                    Copy_Min_On_Cell(Opt_pts[argmin+1], Opt_b);
                    dfb          = df_pts[argmin+1];
                    }
                // else: don't need to update b (it already has the correct value)
                }
            else
                {
                // minimum must be to the left of m
                // set b = m
                Copy_Min_On_Cell(Opt_pts[argmin], Opt_b);
                dfb          = dfm;
                if (argmin > 0)
                    {
                    // then need to update a
                    // set a = m-1
                    Copy_Min_On_Cell(Opt_pts[argmin-1], Opt_a);
                    dfa          = df_pts[argmin-1];
                    }
                // else: do not need to update a (it already has the correct value)
                }
            }
        }
#endif

    // do way more iterations than we should need (should not be more than ~14)
    unsigned int iter;
    for (iter = 0; iter < MAX_LINE_SEARCH_ITER; iter++)
        {
        // get current window size
        VEC_2x1 b_minus_a;
        Subtract_Vector(b, a, b_minus_a);
        const double b_minus_a_norm = l2_norm(b_minus_a);

        // first, get a candidate location for the minimum in [a, b]

        // if the current window satisfies the "end conditions" for a minimum,
        if ( (dfa < 0) && (dfb > 0) )
            {
            // then try cubic interpolation to find the minimum
            const double w = dfb + dfa - 3.0 * (fb - fa) / b_minus_a_norm;
            const double v = sqrt(w*w - dfa*dfb);
            const double s = (dfb + v - w) / (dfb - dfa + 2*v);
            if ( (s < 0) || (s > 1) ) // m will be outside the current window
                {
                // this should not happen, but if it does just bisect!
                m.v[0] = 0.5 * a.v[0] + 0.5 * b.v[0];
                m.v[1] = 0.5 * a.v[1] + 0.5 * b.v[1];
                }
            else // 0 <= s <= 1
                {
                // b - m = (b - a) * (dfb + v - w) / (dfb - dfa + 2*v)
                // i.e.   m = s * a + (1.0 - s) * b
                m.v[0] = s * a.v[0] + (1.0 - s) * b.v[0];
                m.v[1] = s * a.v[1] + (1.0 - s) * b.v[1];
                // m is candidate minimum location from cubic approximation of function
                }
            }
        else if (fa < fb)
            {
#ifdef LINEAR_CELL
			// since the cell is a linear element (not curved),
			// the only possibility is that the minimum is at a
			// since the minimum is returned in a,
			break; // we stop!
#else
            // if the value is smaller at a,
            //    then do "biased" bisection toward a
            // m = 0.75 * a + 0.25 * b;
            m.v[0] = (1.0 - BIAS_TOL) * a.v[0] + BIAS_TOL * b.v[0];
            m.v[1] = (1.0 - BIAS_TOL) * a.v[1] + BIAS_TOL * b.v[1];
#endif
            }
        else if (fa > fb)
            {
#ifdef LINEAR_CELL
            // since the cell is a linear element (not curved),
            // the only possibility is that the minimum is at b
            Copy_Min_On_Cell(Opt_b, Opt_a); // copy to a (b/c the min is returned in a)
            break; // stop!
#else
            // if the value is smaller at b,
            //    then do "biased" bisection toward b
            // m = 0.25 * a + 0.75 * b;
            m.v[0] = BIAS_TOL * a.v[0] + (1.0 - BIAS_TOL) * b.v[0];
            m.v[1] = BIAS_TOL * a.v[1] + (1.0 - BIAS_TOL) * b.v[1];
#endif
            }
        else // last resort, just do bisection
            {
            m.v[0] = 0.5 * a.v[0] + 0.5 * b.v[0];
            m.v[1] = 0.5 * a.v[1] + 0.5 * b.v[1];
            }

        // the only function evaluations
        Eval_Cost_And_Gradient(X, m, fm_scalar, grad_fm);
        dfm = Dot_Product(grad_fm, unit_vec);

        // next, update the search window

        // if the candidate is the new best value
        if ( (fm < fa) && (fm < fb) )
            {
            // then it *might* be a minimum

            // if derivative is small, then stop
            if (my_abs(dfm) < TOL)
                {
                // we are done, so return the minimum in "a"
                Copy_Min_On_Cell(Opt_m, Opt_a);
                //dfa          = dfm;
                //mexPrintf("dfm is too small\n");
                break;
                }
            else // derivative is "big"
                {
                // narrow the search window
                if (dfm < 0)
                    {
                    // minimum must be in the right side of [a, m, b]
                    // set a = m
                    Copy_Min_On_Cell(Opt_m, Opt_a);
                    dfa          = dfm;
                    }
                else // dfm >= 0
                    {
                    // minimum must be in the left side of [a, m, b]
                    // set b = m
                    Copy_Min_On_Cell(Opt_m, Opt_b);
                    dfb          = dfm;
                    }
                }
            }
        // update window based on end-points
        else if (fa > fb)
            {
            // if derivative is small at b, then stop
            if (my_abs(dfb) < TOL)
                {
                // we are done, so return the minimum in "a"
                Copy_Min_On_Cell(Opt_b, Opt_a);
                //dfa          = dfb;
                //mexPrintf("dfb is too small\n");
                break;
                }
            else
                {
                // narrow search to right side of [a, m, b]
                // set a = m
                Copy_Min_On_Cell(Opt_m, Opt_a);
                dfa          = dfm;
                }
            }
        else // fb >= fa
            {
            // if derivative is small at a, then stop
            if (my_abs(dfa) < TOL)
                {
                // we are done, and the minimum is already in "a"
                //mexPrintf("dfa is too small\n");
                break;
                }
            else
                {
                // narrow search to left side of [a, m, b]
                // set b = m
                Copy_Min_On_Cell(Opt_m, Opt_b);
                dfb          = dfm;
                }
            }

        // check current window size
        const bool TOO_SMALL = (b_minus_a_norm < TOL);

        // if we exceeded the tolerance, then take minimum to be the
        // best end-point of the latest search window.
        if (TOO_SMALL)
            {
            if (fb < fa)
                {
                // the minimum is at "b"
                Copy_Min_On_Cell(Opt_b, Opt_a);
                //dfa          = dfb;
                // remember that the minimum is *returned* in "a"
                }
            // else the minimum is at "a" (it's already in there)

            break; // window is too small, so no need to search anymore
            //mexPrintf("window is TOO_SMALL\n");
            }
        }
    //mexPrintf("Number of Line Search iterations: %d.\n",iter+1);

    // make sure the minimum point is inside the closure of the reference cell
    Project_Onto_Ref_Cell(Opt_a.x, TOL);
    Eval_Cost_And_Gradient(X, Opt_a.x, Opt_a.Cx, Opt_a.Grad_Cx); // recompute to be consistent
}
/***************************************************************************************/

