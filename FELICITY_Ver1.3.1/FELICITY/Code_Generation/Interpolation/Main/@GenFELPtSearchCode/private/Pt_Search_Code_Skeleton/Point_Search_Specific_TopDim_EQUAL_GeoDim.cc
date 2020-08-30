/***************************************************************************************/
/* this searches for the given points in the sub-domain
   note: topological dimension EQUALS geometric dimension (1, 2, or 3) */
void SpecificSEARCH::Find_Points()
{
    const unsigned int Num_Pts_To_Find = Found_Points->Num_Pts;

    // loop through each point
    for (unsigned int Pt_Ind = 0; Pt_Ind < Num_Pts_To_Find; Pt_Ind++)
        {
        PT_DATA_TOPDIM_GEODIM_TYPE  Pt_Data;

        // get the (fixed) global point
        Search_Data->Read_Global_X(Pt_Ind, Pt_Data.global_pt.v);

        // get the initial guess for the enclosing cell index
        Pt_Data.cell_index = Found_Points->Cell_Index[Pt_Ind] - 1; // need to offset for C-style indexing
        Init_Barycenter(Pt_Data.local_pt);

        // find the enclosing cell and local reference domain coordinates
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
/* search for a single point in the sub-domain
  (Pt_Data.cell_index and Pt_Data.local_pt will be modified by this.) */
bool SpecificSEARCH::Find_Single_Point(PT_DATA_TOPDIM_GEODIM_TYPE& Pt_Data)
{
    bool FOUND = false; // assume we do not find it

    // pass the initial cell index so we can compute the correct local map
    Domain->Read_Embed_Data(Pt_Data.cell_index);

#ifdef LINEAR_CELL

    // we should not need to look beyond ~the number of cells in the sub-domain
    const unsigned int MAX_ITER = Search_Data->Num_Cells + 10;
    for (unsigned int ind = 0; ind < MAX_ITER; ind++)
        {
        const int argmin = One_Iteration(Pt_Data);
        if (argmin==-1) // we found the enclosing cell AND the local coordinates
            {
            FOUND = true;
            break; // exit loop
            }
        else // we have not found the cell
            {
            // so go to neighbor cell...
            const unsigned int trial_cell_index = Search_Data->Neighbor[argmin][Pt_Data.cell_index]; // MATLAB-style indexing
            if (trial_cell_index==0) // no neighbor is present
                break; // could not locate point!
            else // move to neighbor
                {
                Pt_Data.cell_index = trial_cell_index - 1; // C-style indexing
                // pass the new cell index so we can compute the correct local map
                Domain->Read_Embed_Data(Pt_Data.cell_index);
                }
            }
        }
#else

    //mexPrintf("\nStart running Newton iteration!\n");

    // initialize previous point
    VEC_DIM_TYPE  prev_pt;
    Init_Bogus_Pt(prev_pt);

    // we should not need to look beyond ~the number of cells in the sub-domain
    const unsigned int MAX_ITER = Search_Data->Num_Cells + 10;
    for (unsigned int ind = 0; ind < MAX_ITER; ind++)
        {
        const int argmin = One_Iteration(Pt_Data);
        if (argmin==-1) // we found the enclosing cell
            {
            FOUND = true;
            // check convergence
            Subtract_Vector(Pt_Data.local_pt, prev_pt, prev_pt); // prev_pt contains temporary value
            const double norm_diff_error = l2_norm(prev_pt);
            //mexPrintf("norm_diff_error = %1.5g.\n",norm_diff_error);
            if (norm_diff_error < NEWTON_TOL)
                break; // stop iterating

            // update previous point
			prev_pt.Set_Equal_To(Pt_Data.local_pt);
            }
        else // we have not found the cell
            {
            FOUND = false;

            // and go to neighbor cell...
            const unsigned int trial_cell_index = Search_Data->Neighbor[argmin][Pt_Data.cell_index]; // MATLAB-style indexing
            if (trial_cell_index==0) // no neighbor is present
                break; // could not locate point!
            else // move to neighbor
                {
                Pt_Data.cell_index = trial_cell_index - 1; // C-style indexing
                // pass the new cell index so we can compute the correct local map
                Domain->Read_Embed_Data(Pt_Data.cell_index);
                // reset previous point to bogus value
                Init_Bogus_Pt(prev_pt);
                }
            }
        }
#endif
    // project point to the ref cell
    Project_Onto_Ref_Cell(Pt_Data.local_pt, REF_CELL_TOL);

    return FOUND;
}
/***************************************************************************************/


/***************************************************************************************/
/* run one iteration of reference coordinate calculation.
   note: the sub-Domain cell index is already accounted for before running this.
  (Pt_Data.local_pt will be modified by this.) */
int SpecificSEARCH::One_Iteration(PT_DATA_TOPDIM_GEODIM_TYPE& Pt_Data)
{
    // define vector
    VEC_DIM_TYPE  AA, BB;

    // get the local element transformation
	Pt_Data.local_pt.Copy_To_Array(GeomFunc->local_coord);
    GeomFunc->Compute_Local_Transformation();

    // apply one step of Newton's method
    Subtract_Vector(GeomFunc->Map_PHI[0],Pt_Data.global_pt,AA);
    Mat_Vec(GeomFunc->Map_PHI_Inv_Grad[0],AA,BB);
    Subtract_Vector(Pt_Data.local_pt,BB,Pt_Data.local_pt);

    // apply selection criterium
    double min_N, max_N;
    const int argmin = Selection_Criterium(Pt_Data.local_pt, min_N, max_N);

    // if the point is in the current cell
    if ( (min_N >= -REF_CELL_TOL) && (max_N - 1.0 <= REF_CELL_TOL) )
        return -1; // then we found the cell
    else
        // otherwise, we must keep searching or fail...
        return argmin;
}
/***************************************************************************************/

