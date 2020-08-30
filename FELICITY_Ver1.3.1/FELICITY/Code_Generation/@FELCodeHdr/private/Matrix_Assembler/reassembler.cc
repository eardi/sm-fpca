/***

A matrix RE-assembler for MATLAB
Copyright (c) 2018
Shawn W. Walker

 * The [[Reassembler]] class accumulates element contributions into an
 * existing compressed sparse column matrix data structure.  Elements
 * that do not fit into the existing index structure are silently ignored,
 * but an error message is output to the MATLAB display.

****/

// #include <vector>
// #include <algorithm>

class MatrixReassembler: public AbstractAssembler {
public:
    MatrixReassembler(mwIndex* jc1, mwIndex* ir1, double* pr1, int m, int n) : AbstractAssembler(m, n)
        {
        nnz = (int) jc1[n];
        result = mxCreateSparse((mwSize)m, (mwSize)n, (mwSize)nnz, mxREAL);
        jc_ptr = (mwIndex*) mxGetJc(result);
        ir_ptr = (mwIndex*) mxGetIr(result);
        pr_ptr =  (double*) mxGetPr(result);
        // copy old sparsity pattern over
        std::copy(jc1, (jc1+n+1), jc_ptr);
        std::copy(ir1, (ir1+nnz), ir_ptr);
        std::fill(pr_ptr, pr_ptr+nnz, 0); // initialize to all zero matrix
		
		// std::memcpy ( jc_ptr, jc1, (n+1) * sizeof(mwIndex) );
		// std::memcpy ( ir_ptr, ir1,   nnz * sizeof(mwIndex) );
		// std::memset ( pr_ptr,   0,   nnz * sizeof(double));
		
        //std::copy(pr1, (pr1+nnz), pr_ptr); // copy old matrix over (for testing purposes)
		
		/* SWW:   NEW CODE!!!   */
		
		// // create internal column stacks
		// ColStack.reserve(n);
		// ValStack.reserve(n);
		
		// // each entry:  ColStack[j]."Row indices"
		// for (int jj = 0; jj < n; ++jj) {
            // const mwIndex* const start = ir_ptr+jc_ptr[jj];
            // const mwIndex* const   end = ir_ptr+jc_ptr[jj+1];
			// // find number of entries in this column
			// const int Num_Entries = (int) (end - start);
			// ColStack[jj].reserve(Num_Entries);
			// //ValStack[jj].reserve(Num_Entries);
			// // fill them!
			// for (int kk = 0; kk < Num_Entries; ++kk) {
				// std::copy(start, end, ColStack[jj].begin());
				// ValStack[jj].assign(Num_Entries,0);
				// //std::fill (ValStack[jj].begin(), ValStack[jj].begin() + Num_Entries, 0);
			// }
		// }
        }
    ~MatrixReassembler () {}

    int nnz;

    // void add_entries(const int*, const int*, const double*, const int&, const int&);
    // void add_entries(const int*, const int*, const double*, const int&, const int&, const int*);
    // void add_entries(const int*, const int*, const double*, const int&, const int&, const int*, const mwIndex**, const bool&);
	
	void add_entries(const int*, const int*, const int*, const double*, const int&);

    // void add_entries_transpose(const int*, const int*, const double*, const int&, const int&);
    // void add_entries_transpose(const int*, const int*, const double*, const int&, const int&, const int*);
    // void add_entries_transpose(const int*, const int*, const double*, const int&, const int&, const int*, const mwIndex**, const bool&);

    mxArray* export_matrix() { return result; }

private:

    // access to data
    mwIndex* jc_ptr;
    mwIndex* ir_ptr;
    double*  pr_ptr;

    mxArray* result;
	
	// // test stuff
	// std::vector< std::vector<int>     > ColStack;
	// std::vector< std::vector<double>  > ValStack;
};

// void MatrixReassembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe)
// {
    // // loop through columns of local matrix
    // for (int jj = 0; jj < nAe; ++jj, Ae += mAe) {
        // const int  col_index = jAe[jj];

        // if (col_index >= 0 && col_index < n) {
            // const mwIndex* const start = ir_ptr+jc_ptr[col_index];
            // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // loop through rows of local matrix
            // for (int ii = 0; ii < mAe; ++ii) {
                // // linear search to find row
                // const int row_index = iAe[ii];
                // const mwIndex* const p = std::find(start, end, row_index);

                // // found index!
                // if (p!=end) {
                    // const int k = (int) (p - ir_ptr); // shift back to get index
                    // pr_ptr[k] += Ae[ii]; // add it in
                // }
                // else
                    // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // }
        // }
    // }
// }

// /* local_row_indices is sorted so that we loop through iAe in ascending order */
// void MatrixReassembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                    // const int* local_row_indices)
// {
    // // loop through columns of local matrix
    // for (int jj = 0; jj < nAe; ++jj, Ae += mAe) {
        // const int  col_index = jAe[jj];

        // if (col_index >= 0 && col_index < n) {
            // const mwIndex*    row_find = ir_ptr+jc_ptr[col_index]; // start at the beginning
            // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // loop through rows of local matrix
            // for (int ii = 0; ii < mAe; ++ii) {
                // // linear search to find row
                // const int row_index = iAe[local_row_indices[ii]];
                // row_find = std::find(row_find, end, row_index);

                // // found index!
                // if (row_find!=end) {
                    // const int k = (int) (row_find - ir_ptr); // shift back to get index
                    // pr_ptr[k] += Ae[local_row_indices[ii]]; // add it in
                    // ++row_find; // go to next one
                // }
                // else
                    // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // }
        // }
    // }
// }

// /* this also gives an initial guess for searching for the row_index;
   // Warning: make sure the initial guess is valid! */
// void MatrixReassembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                    // const int* local_row_indices, const mwIndex** row_find, const bool& reset)
// {
    // // loop through columns of local matrix
    // for (int jj = 0; jj < nAe; ++jj, Ae += mAe) {
        // const int  col_index = jAe[jj];

        // if (col_index >= 0 && col_index < n) {
            // if (reset) // start at the beginning
                // row_find[jj]           = ir_ptr+jc_ptr[col_index];

            // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // loop through rows of local matrix
            // for (int ii = 0; ii < mAe; ++ii) {
                // // linear search to find row
                // const int row_index = iAe[local_row_indices[ii]];
                // row_find[jj] = std::find(row_find[jj], end, row_index);

                // // found index!
                // if (row_find[jj]!=end) {
                    // const int k = (int) (row_find[jj] - ir_ptr); // shift back to get index
                    // pr_ptr[k] += Ae[local_row_indices[ii]]; // add it in
                    // ++row_find[jj]; // go to next one
                // }
                // else
                    // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // }
        // }
    // }
// }



/* this uses a sorted IJV format to add the entries
   NOTE: if you want to add the transpose, then that needs to be done outside this! */
void MatrixReassembler::add_entries(const int*    coo_i, const int* coo_j,  const int* coo_j_iv_range,
                                    const double* coo_v, const int& num_col)
{
    // go through each column in ascending order
    for (int jj = 0; jj < num_col; ++jj) {
        const int  col_index = coo_j[jj];
		
		// get the local range (for the current column)
		const int local_start = coo_j_iv_range[jj];
		const int local_end   = coo_j_iv_range[jj+1];
		
        if (col_index >= 0 && col_index < n) {
			// get the global range to search
			const mwIndex*       global_row = ir_ptr+jc_ptr[col_index]; // init
			const int               ir_stop = (int) jc_ptr[col_index+1];
			const mwIndex* const global_end = ir_ptr+ir_stop;
			
			// find where the global row indices are in ir_ptr/pr_ptr
			for (int local_row = local_start; local_row < local_end; ++local_row) {
				global_row = std::find(global_row, global_end, coo_i[local_row]);
				const int k_index = (int) (global_row - ir_ptr); // shift back to get index
				++global_row; // go to next one
				if (k_index < ir_stop) {
					pr_ptr[k_index] += coo_v[local_row];
				}
				else {
					printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
					printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",coo_i[local_row],m);
					printf("Note: C-style indexing is used here.\n");
					printf("See 'reassembler.cc'.\n");
				}
			}
		}
		else {
			printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
			printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",col_index,n);
			printf("Note: C-style indexing is used here.\n");
			printf("See 'reassembler.cc'.\n");
		}
    }
}



// /* the following sub-routines are for adding the transpose of the local FE matrix */

// void MatrixReassembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe)
// {
    // // loop through columns of local matrix
    // for (int jj = 0; jj < nAe; ++jj, ++Ae) {
        // const int  col_index = jAe[jj];

        // if (col_index >= 0 && col_index < n) {
            // const mwIndex* const start = ir_ptr+jc_ptr[col_index];
            // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // loop through rows of local matrix
            // for (int ii = 0; ii < mAe; ++ii) {
                // // linear search to find row
                // const int row_index = iAe[ii];
                // const mwIndex* const p = std::find(start, end, row_index);

                // // found index!
                // if (p!=end) {
                    // const int k = (int) (p - ir_ptr); // shift back to get index
                    // pr_ptr[k] += Ae[ii*nAe]; // add it in (the transpose, that is)
                // }
                // else
                    // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // }
        // }
    // }
// }

// /* local_row_indices is sorted so that we loop through iAe in ascending order */
// void MatrixReassembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                              // const int* local_row_indices)
// {
    // // loop through columns of local matrix
    // for (int jj = 0; jj < nAe; ++jj, ++Ae) {
        // const int  col_index = jAe[jj];

        // if (col_index >= 0 && col_index < n) {
            // const mwIndex*    row_find = ir_ptr+jc_ptr[col_index]; // start at the beginning
            // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // loop through rows of local matrix
            // for (int ii = 0; ii < mAe; ++ii) {
                // // linear search to find row
                // const int row_index = iAe[local_row_indices[ii]];
                // row_find = std::find(row_find, end, row_index);

                // // found index!
                // if (row_find!=end) {
                    // const int k = (int) (row_find - ir_ptr); // shift back to get index
                    // pr_ptr[k] += Ae[local_row_indices[ii]*nAe]; // add it in (the transpose, that is)
                    // ++row_find; // go to next one
                // }
                // else
                    // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // }
        // }
    // }
// }

// // SWW: DELETE

// /* this also gives an initial guess for searching for the row_index;
   // Warning: make sure the initial guess is valid! */
// void MatrixReassembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                              // const int* local_row_indices, const mwIndex** row_find, const bool& reset)
// {
    // // // loop through columns of local matrix
    // // for (int jj = 0; jj < nAe; ++jj, ++Ae) {
        // // const int  col_index = jAe[jj];

        // // if (col_index >= 0 && col_index < n) {
            // // if (reset) // start at the beginning
                // // row_find[jj]           = ir_ptr+jc_ptr[col_index];

            // // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // // loop through rows of local matrix
            // // for (int ii = 0; ii < mAe; ++ii) {
                // // // linear search to find row
                // // const int row_index = iAe[local_row_indices[ii]];
                // // row_find[jj] = std::find(row_find[jj], end, row_index);

                // // // found index!
                // // if (row_find[jj]!=end) {
                    // // const int k = (int) (row_find[jj] - ir_ptr); // shift back to get index
                    // // pr_ptr[k] += Ae[local_row_indices[ii]*nAe]; // add it in (the transpose, that is)
                    // // ++row_find[jj]; // go to next one
                // // }
                // // else
                    // // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // // }
        // // }
    // // }
// }



// /* this also gives an initial guess for searching for the row_index;
   // Warning: make sure the initial guess is valid! */
// void MatrixReassembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                              // const int* local_row_indices, const mwIndex** row_find, const bool& reset)
// {
    // // loop through columns of local matrix
    // for (int jj = 0; jj < nAe; ++jj, ++Ae) {
        // const int  col_index = jAe[jj];

        // if (col_index >= 0 && col_index < n) {
            // if (reset) // start at the beginning
                // row_find[jj]           = ir_ptr+jc_ptr[col_index];

            // const mwIndex* const   end = ir_ptr+jc_ptr[col_index+1];
            // // loop through rows of local matrix
            // for (int ii = 0; ii < mAe; ++ii) {
                // // linear search to find row
                // const int row_index = iAe[local_row_indices[ii]];
                // row_find[jj] = std::find(row_find[jj], end, row_index);

                // // found index!
                // if (row_find[jj]!=end) {
                    // const int k = (int) (row_find[jj] - ir_ptr); // shift back to get index
                    // pr_ptr[k] += Ae[local_row_indices[ii]*nAe]; // add it in (the transpose, that is)
                    // ++row_find[jj]; // go to next one
                // }
                // else
                    // mexPrintf("Failed element update at this matrix entry: (%d, %d).\n", row_index, col_index);
            // }
        // }
    // }
// }
