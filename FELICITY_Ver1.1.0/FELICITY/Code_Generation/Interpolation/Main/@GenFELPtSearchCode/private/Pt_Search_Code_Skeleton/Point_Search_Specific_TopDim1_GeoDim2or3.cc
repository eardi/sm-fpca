/***************************************************************************************/
/* this searches for the given points in the sub-domain
   note: topological dimension is 1
           geometric dimension is 2 or 3  */
void SpecificSEARCH::Find_Points()
{
    const unsigned int Num_Pts_To_Find = Found_Points->Num_Pts;

    // loop through each point
    for (unsigned int Pt_Ind = 0; Pt_Ind < Num_Pts_To_Find; Pt_Ind++)
        {
        PT_DATA_TOPDIM_GEODIM_TYPE  Pt_Data;
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
/* Note: the standard reference interval looks like this:

     (N1)  v0 #------->-------# v1  (N0)    --->  p
                      S0

    vertex 0:  v0 = (0)
    vertex 1:  v1 = (1)

        side 0:  S0 = (v0,v1)
    neighbor 0:  N0 = adjacent cell opposite v0
    neighbor 1:  N1 = adjacent cell opposite v1
*/
/***************************************************************************************/


/***************************************************************************************/
/* Starting from the minimum on the boundary of the ref interval, determine whether
   that is the minimum over the entire ref interval.
   If the minimum over the entire ref interval is on the boundary, then
   return 0 or 1 possible local neighbors to move to next (in order to keep
   searching for the global minimum).
   If the minimum is inside the ref interval, then do not return any neighbors.
   (in this case, one needs to do some gradient descent within the cell.)

   local_neighbor = local neighbor index
         value: 0,1 (local neighbor indices)
         value: -1 (no valid local neighbor)
*/
void Determine_Neighbor_From_Min_On_Interval_Bdy(const VEC_1x1& Local_p, const VEC_1x1& Grad,
                                                 const int& vtx_index,   const double& TOL,
                                                 int& local_neighbor)
{
    // define normal vectors at boundary of interval
    static const double NV0 = -1.0; // vtx 0
    static const double NV1 =  1.0; // vtx 1

    // init to no valid neighbor
    local_neighbor = -1;

    // if the gradient at the given minimum location (on the bdy) points *outside* the ref interval
    // then the actual global minimum is *inside* the ref interval (most likely anyway)
    // otherwise, the global minimum is in another cell, so return potential neighbors to search

    if (vtx_index==0) // min is on vtx 0
        {
        // compute trend of cost across vtx 0
        const double DP = NV0*Grad.v[0];
        //mexPrintf("DP = %1.5f.\n",DP);

        if (DP < -TOL) // the cost decreases outside the cell
            {
            // potential neighbor to search
            local_neighbor = 1; // neighbor 1 adjoins vtx 0
            }
        }
    else if (vtx_index==1) // min is on vtx 1
        {
        // compute trend of cost across vtx 1
        const double DP = NV1*Grad.v[0];
        //mexPrintf("DP = %1.5f.\n",DP);

        if (DP < -TOL) // the cost decreases outside the cell
            {
            // potential neighbor to search
            local_neighbor = 0; // neighbor 0 adjoins vtx 1
            }
        }
    // else there is no valid neighbor (already set above)
}
/***************************************************************************************/


/***************************************************************************************/
/* get cell_index of local neighbor (if it is valid).
   cell_index is modified by this routine (if it is valid).
   Note: valid means the neighbor exists, and it has not been visited before.

   returns true/false indicating if the neighbor was valid.
*/
bool SpecificSEARCH::Get_Valid_Neighbor(unsigned int& cell_index,
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
                }
            }
        }

    return VALID;
}
/***************************************************************************************/


/***************************************************************************************/
/* search for the nearest point in the sub-domain.
  (Pt_Data.cell_index and Pt_Data.local_pt will be modified by this.) */
bool SpecificSEARCH::Find_Single_Point(PT_DATA_TOPDIM_GEODIM_TYPE& Pt_Data)
{
    bool FOUND = false; // assume we do not find it

    // variables for searching for minimum
    Min_On_Cell_Top1  Min_On_Int;
    // init the cell index to start from
    unsigned int current_cell_index = Pt_Data.cell_index;

    // keep track of which cells are visited
    unsigned int cell_index_queue[MAX_QUEUE_SIZE];
    unsigned int queue_size = 0;

    // store local neighbor choices
    int local_neighbor = -1;

    // pre-compute the minimum on the first cell
    Compute_Min_On_Interval(Pt_Data.global_pt, current_cell_index,
                            cell_index_queue, queue_size,
                            Min_On_Int, local_neighbor);

    // iterate (i.e. traverse the mesh)
    //     until there are no new cells to search (worst case)
    const unsigned int MAX_CELL_ITER = Search_Data->Num_Cells + 1;
    for (unsigned int ind = 0; ind < MAX_CELL_ITER; ind++)
        {
        FOUND =
        Find_Single_Point_Sub_Iter(Pt_Data.global_pt, current_cell_index,
                                   cell_index_queue, queue_size, Min_On_Int, local_neighbor);
        if (FOUND) break;
        }

    // return the found minimum in the struct Pt_Data
    Pt_Data.cell_index = current_cell_index;
	Pt_Data.local_pt.Set_Equal_To(Min_On_Int.x);

    return FOUND;
}
/***************************************************************************************/


/***************************************************************************************/
/* this is one iteration of the FOR loop in Find_Single_Point.
   Note: this expects the minimum on cell_index to already be computed in Min_On_Int!

   Based on the incoming minimum data (and potential neighbor), this routine chooses
   a neighbor cell to go to next and computes the minimum on that neighbor cell.

   cell_index = index for the current cell.
   Note: local_neighbor = local neighbor index
         value: 0,1 (local neighbor indices)
         value: -1 (no valid local neighbor)
   Also see the routine: "Determine_Neighbors_From_Min_On_Interval_Bdy"
*/
bool SpecificSEARCH::Find_Single_Point_Sub_Iter(const VEC_DIM_TYPE& Global_X,
                                                unsigned int& cell_index,
                                                unsigned int* cell_index_queue,
                                                unsigned int& queue_size,
                                                Min_On_Cell_Top1& Min_On_Int,
                                                int& local_neighbor)
{
    bool FOUND = false; // assume we do not find the minimum

    // determine if neighbor is available to move to
    // note: this updates cell_index
    bool valid_nb = Get_Valid_Neighbor(cell_index, local_neighbor,
                                       cell_index_queue, queue_size);

    if (valid_nb)
        {
        // then move to neighbor

        // compute min for next iteration
        Compute_Min_On_Interval(Global_X, cell_index,
                                cell_index_queue, queue_size,
                                Min_On_Int, local_neighbor);
        }
    else
        {
        // there is no neighbor to move to,
        // so the global minimum is in this cell
        //      and is already computed.
        FOUND = true;
        }

    return FOUND;
}
/***************************************************************************************/


/***************************************************************************************/
/* compute minimum on a given interval.
   Global_X = needed to compute cost and gradient.
   cell_index = index of the *new* cell to compute minimum on.
   cell_index_queue, queue_size = array for keeping track of which cells have been
                                  recently visited.
   Min_On_Int = either contains invalid data, or it contains the minimum data
                on the *previous* cell visited.
   local_neighbor = potential neighbor to visit *next* time.
*/
void SpecificSEARCH::Compute_Min_On_Interval(const VEC_DIM_TYPE& Global_X,
                                             const unsigned int& cell_index,
                                             unsigned int* cell_index_queue,
                                             unsigned int& queue_size,
                                             Min_On_Cell_Top1& Min_On_Int,
                                             int& local_neighbor)
{
    // variables for performing optimization searches
    Min_On_Cell_Top1  Cost_at_V[2];   // holds cost and gradient at vertices 0,1
    Min_On_Cell_Top1  Window_End; // holds opposite end of line search window
    //VEC_2x1  unit_vec; // for computing directional derivative

    /* BEGIN: keep track of which cells have been visited. */
    // if the queue of elements exceeds the MAX, then reset it!
    if (queue_size >= MAX_QUEUE_SIZE) queue_size = 0;
    // record the cell you are looking at:
    cell_index_queue[queue_size] = cell_index;
    queue_size++; // update size
    /* END: keep track of which cells have been visited. */

    // pass cell index of the current interval in order to compute the correct local map
    Domain->Read_Embed_Data(cell_index);
    //mexPrintf("\n\n");
    //mexPrintf("TEST: computing minimum on this cell_index: %d.\n",cell_index+1);

    // first, compute cost and gradient at the two vertices of the ref interval
    Cost_at_V[0].x.v[0] = 0.0;
    Eval_Cost_And_Gradient(Global_X, Cost_at_V[0].x, Cost_at_V[0].Cx, Cost_at_V[0].Grad_Cx);
    Cost_at_V[1].x.v[0] = 1.0;
    Eval_Cost_And_Gradient(Global_X, Cost_at_V[1].x, Cost_at_V[1].Cx, Cost_at_V[1].Grad_Cx);

    // next, line-search the whole reference interval
    Copy_Min_On_Cell(Cost_at_V[0], Min_On_Int);
    Copy_Min_On_Cell(Cost_at_V[1], Window_End);
    Bisection_And_Cubic_Line_Search(Global_X, NUM_INTERMEDIATE_PTS, OPT_TOL, Min_On_Int, Window_End);

    // variable to store which vtx of ref interval the minimum is on
    int min_vtx_index = -1; // -1 indicates min is in the *interior* (not on a vtx)
    if (Min_On_Int.x.v[0] < OPT_TOL)
        min_vtx_index = 0; // min is at vtx 0
    else if (1.0 - Min_On_Int.x.v[0] < OPT_TOL)
        min_vtx_index = 1; // min is at vtx 1

    // now determine if the minimum is within the cell or is outside it.
    // if it is outside, return 0 or 1 potential neighbor to check next
    // else, do not visit any new neighbor
    Determine_Neighbor_From_Min_On_Interval_Bdy(
                            Min_On_Int.x, Min_On_Int.Grad_Cx, min_vtx_index,
                            OPT_TOL, local_neighbor);

    //mexPrintf("TEST: local coordinates of minimum: %1.5f, %1.5f.\n",Min_On_Int.x.v[0],Min_On_Int.x.v[1]);
}
/***************************************************************************************/


/***************************************************************************************/
/* Compute Cost := 1/2 (PHI(local) - global)^2.
   note: make sure we are on the correct cell before running this
  (i.e. get embedding data before running this)! */
double SpecificSEARCH::Eval_Cost(const VEC_DIM_TYPE& global_pt, const VEC_1x1& local_pt)
{
    // compute local element transformation
	local_pt.Copy_To_Array(GeomFunc->local_coord);
    GeomFunc->Compute_Local_Transformation();

    // evaluate cost
    VEC_DIM_TYPE G_T;
    Subtract_Vector(GeomFunc->Map_PHI[0],global_pt,G_T);
    return ( 0.5 * Dot_Product(G_T, G_T) );
}
/***************************************************************************************/


/***************************************************************************************/
/* Compute Cost := 1/2 (PHI(local) - global)^2, and 1-D gradient of Cost.
   note: make sure we are on the correct cell before running this
  (i.e. get embedding data before running this)! */
void SpecificSEARCH::Eval_Cost_And_Gradient(const VEC_DIM_TYPE& global_pt, const VEC_1x1& local_pt,
                                            SCALAR&  Cost,            VEC_1x1& Cost_Grad)
{
    // compute local element transformation
	local_pt.Copy_To_Array(GeomFunc->local_coord);
    GeomFunc->Compute_Local_Transformation();

    // evaluate cost
    VEC_DIM_TYPE G_T;
    Subtract_Vector(GeomFunc->Map_PHI[0],global_pt,G_T);
    Cost.a = 0.5 * Dot_Product(G_T, G_T);

    // evaluate gradient
    MAT_DIM_TYPE& MAT = GeomFunc->Map_PHI_Grad[0];
	Vec_Transpose_Mat(G_T, MAT, Cost_Grad);
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
void SpecificSEARCH::Bisection_And_Cubic_Line_Search(const VEC_DIM_TYPE& Global_X,
                                                     const unsigned int& INPUT_Num_Extra_Pts,
                                                     const double& TOL,
                                                     Min_On_Cell_Top1& Opt_a,
                                                     Min_On_Cell_Top1& Opt_b)
{
    // these are used to evaluate the cost functional and derivative
    const VEC_DIM_TYPE& X  = Global_X;

    // these are used to store the search window (which is updated)
    // note: the minimum that is found is returned in Opt_a
    VEC_1x1&       a = Opt_a.x;
    double&       fa = Opt_a.Cx.a;
    VEC_1x1& grad_fa = Opt_a.Grad_Cx;
    double&      dfa = grad_fa.v[0];

    VEC_1x1&       b = Opt_b.x;
    double&       fb = Opt_b.Cx.a;
    VEC_1x1& grad_fb = Opt_b.Grad_Cx;
    double&      dfb = grad_fb.v[0];

    // these are for the candidate point during each iteration
    Min_On_Cell_Top1    Opt_m;
    VEC_1x1&       m  = Opt_m.x;
    SCALAR& fm_scalar = Opt_m.Cx;
    double&        fm = fm_scalar.a;
    VEC_1x1&  grad_fm = Opt_m.Grad_Cx;
    double&       dfm = grad_fm.v[0];
                  dfm = 0.0; // init

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
    Min_On_Cell_Top1  Opt_pts[NUM_INTERMEDIATE_PTS];

    const double step = 1.0 / (Num_Extra_Pts + 1.0);
    double t_var = 0.0;
    for (unsigned int ii = 0; ii < Num_Extra_Pts; ii++)
        {
        t_var += step; // increment by step
        // compute (local) coordinates of intermediate point by linear combination
        Opt_pts[ii].x.v[0] = ( (1.0 - t_var) * a.v[0] ) + ( t_var * b.v[0] );

        // evaluate function and derivative there
        Eval_Cost_And_Gradient(X, Opt_pts[ii].x, Opt_pts[ii].Cx, Opt_pts[ii].Grad_Cx);

        // update the current minimum
        if (Opt_pts[ii].Cx.a < fm)
            {
            argmin = ii;
            fm     = Opt_pts[ii].Cx.a;
            dfm    = Opt_pts[ii].Grad_Cx.v[0];
            }
        }

    // if a has the minimum value
    if (argmin==-1)
        {
        // then start the search window next to a
        // update b
        Copy_Min_On_Cell(Opt_pts[0], Opt_b);
        }
    else if (argmin==Num_Extra_Pts) // b has the minimum value
        {
        // then start the search window next to b
        // update a
        Copy_Min_On_Cell(Opt_pts[Num_Extra_Pts-1], Opt_a);
        }
    else // the initial minimum is inside the initial window
        {
        // choose an interval containing m

        // if derivative is small, then stop
        if (my_abs(dfm) < TOL)
            {
            // then we are done, so return the minimum in "a"
            Copy_Min_On_Cell(Opt_pts[argmin], Opt_a);
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
                if ( argmin < (int) (Num_Extra_Pts-1) )
                    {
                    // then need to update b
                    // set b = m+1
                    Copy_Min_On_Cell(Opt_pts[argmin+1], Opt_b);
                    }
                // else: don't need to update b (it already has the correct value)
                }
            else
                {
                // minimum must be to the left of m
                // set b = m
                Copy_Min_On_Cell(Opt_pts[argmin], Opt_b);
                if (argmin > 0)
                    {
                    // then need to update a
                    // set a = m-1
                    Copy_Min_On_Cell(Opt_pts[argmin-1], Opt_a);
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
        VEC_1x1 b_minus_a;
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
                }
            else // 0 <= s <= 1
                {
                // b - m = (b - a) * (dfb + v - w) / (dfb - dfa + 2*v)
                // i.e.   m = s * a + (1.0 - s) * b
                m.v[0] = s * a.v[0] + (1.0 - s) * b.v[0];
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
#endif
            }
        else // last resort, just do bisection
            {
            m.v[0] = 0.5 * a.v[0] + 0.5 * b.v[0];
            }

        // the only function evaluation
        Eval_Cost_And_Gradient(X, m, fm_scalar, grad_fm);

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
                    }
                else // dfm >= 0
                    {
                    // minimum must be in the left side of [a, m, b]
                    // set b = m
                    Copy_Min_On_Cell(Opt_m, Opt_b);
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
                //mexPrintf("dfb is too small\n");
                break;
                }
            else
                {
                // narrow search to right side of [a, m, b]
                // set a = m
                Copy_Min_On_Cell(Opt_m, Opt_a);
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

