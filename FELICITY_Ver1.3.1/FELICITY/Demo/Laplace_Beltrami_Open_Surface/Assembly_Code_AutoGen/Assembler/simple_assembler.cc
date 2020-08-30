/***

A simple matrix assembler for MATLAB
Copyright (c) 2011
Shawn W. Walker

****/


class SimpleMatrixAssembler: public AbstractAssembler {
public:
    SimpleMatrixAssembler(int m, int n) :
        AbstractAssembler(m, n)
        { MATLAB_MAT = mxCreateNumericMatrix(m, n, mxDOUBLE_CLASS, mxREAL);
          pr         = (double*) mxGetPr(MATLAB_MAT);}
    ~SimpleMatrixAssembler () {}

    // void add_entries(const int*, const int*, const double*, const int&, const int&);
    // void add_entries(const int*, const int*, const double*, const int&, const int&, const int*);
    // void add_entries(const int*, const int*, const double*, const int&, const int&, const int*, const mwIndex**, const bool&);
	
	void add_entries(const int*, const int*, const int*, const double*, const int&);
	
    // void add_entries_transpose(const int*, const int*, const double*, const int&, const int&);
    // void add_entries_transpose(const int*, const int*, const double*, const int&, const int&, const int*);
    // void add_entries_transpose(const int*, const int*, const double*, const int&, const int&, const int*, const mwIndex**, const bool&);
    mxArray* export_matrix();

private:
    mxArray* MATLAB_MAT;
    double*  pr;
};

// void SimpleMatrixAssembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe)
// {
    // for (unsigned int ii = 0; ii < (unsigned int)mAe; ++ii) {
        // for (unsigned int jj = 0; jj < (unsigned int)nAe; ++jj) {
            // if ( (iAe[ii] < 0) || (iAe[ii] >= m) ) {
                // printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
                // printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",iAe[ii],m);
                // printf("Note: C-style indexing is used here.\n");
                // printf("See 'simple_assembler.cc'.\n");
                // }
            // else if ( (jAe[jj] < 0) || (jAe[jj] >= n) ) {
                // printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
                // printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",jAe[jj],n);
                // printf("Note: C-style indexing is used here.\n");
                // printf("See 'simple_assembler.cc'.\n");
                // }
            // else {
                // // add in the entries
                // pr[jAe[jj]*(unsigned int)m + iAe[ii]] += Ae[jj*(unsigned int)mAe + ii];
                // }
            // }
        // }
// }

// void SimpleMatrixAssembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                        // const int* no_use)
// {
    // add_entries(iAe, jAe, Ae, mAe, nAe);
// }

// void SimpleMatrixAssembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                        // const int* no_use1, const mwIndex** no_use2, const bool& none)
// {
    // add_entries(iAe, jAe, Ae, mAe, nAe);
// }

/* this uses a sorted IJV format to add the entries
   NOTE: if you want to add the transpose, then that needs to be done outside this! */
void SimpleMatrixAssembler::add_entries(const int*    coo_i, const int* coo_j,  const int* coo_j_iv_range,
                                        const double* coo_v, const int& num_col)
{
    // go through each column in ascending order
    for (int jj = 0; jj < num_col; ++jj) {
        const int  col_index = coo_j[jj];
		
		// get the local range (for the current column)
		const int local_start = coo_j_iv_range[jj];
		const int local_end   = coo_j_iv_range[jj+1];
		
        if (col_index >= 0 && col_index < n) {
			// simple look-up
			for (int local_row = local_start; local_row < local_end; ++local_row) {
				const int row_index = coo_i[local_row];
				if ( (row_index < 0) || (row_index >= m) ) {
					printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
					printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",row_index,m);
					printf("Note: C-style indexing is used here.\n");
					printf("See 'simple_assembler.cc'.\n");
				}
				else {
					// add in the entries
					pr[col_index*(unsigned int)m + row_index] += coo_v[local_row];
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

// /* add the transpose of the local FE matrix */
// void SimpleMatrixAssembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe)
// {
    // for (unsigned int ii = 0; ii < (unsigned int)mAe; ++ii) {
        // for (unsigned int jj = 0; jj < (unsigned int)nAe; ++jj) {
            // if ( (iAe[ii] < 0) || (iAe[ii] >= m) ) {
                // printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
                // printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",iAe[ii],m);
                // printf("Note: C-style indexing is used here.\n");
                // printf("See 'simple_assembler.cc'.\n");
                // }
            // else if ( (jAe[jj] < 0) || (jAe[jj] >= n) ) {
                // printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
                // printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",jAe[jj],n);
                // printf("Note: C-style indexing is used here.\n");
                // printf("See 'simple_assembler.cc'.\n");
                // }
            // else {
                // // add in the entries (take the transpose!)
                // pr[jAe[jj]*(unsigned int)m + iAe[ii]] += Ae[ii*(unsigned int)nAe + jj];
                // }
            // }
        // }
    // mexErrMsgTxt("SWW: this has not been tested yet!\n");
// }

// void SimpleMatrixAssembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                                  // const int* no_use)
// {
    // add_entries_transpose(iAe, jAe, Ae, mAe, nAe);
// }

// void SimpleMatrixAssembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                                  // const int* no_use1, const mwIndex** no_use2, const bool& none)
// {
    // add_entries_transpose(iAe, jAe, Ae, mAe, nAe);
// }

mxArray* SimpleMatrixAssembler::export_matrix()
{
    return MATLAB_MAT;
}
