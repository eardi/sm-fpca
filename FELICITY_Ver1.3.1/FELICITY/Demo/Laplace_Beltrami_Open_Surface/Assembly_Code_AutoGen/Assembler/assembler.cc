/***

sparse matrix assembly for MATLAB (using column stacks)
Copyright (c) 2018
Shawn W. Walker

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

****/

/* @T
 * The [[Assembler]] class accumulates element contributions to be turned
 * into a sparse matrix in MATLAB's compressed sparse column format.
 * The assembly consists of two phases: accumulation of element matrices,
 * and compression into the final format.
 *
 * In the accumulation phase, we keep linked lists of data that will go into
 * each column.  Each entry in a column's linked list corresponds to one
 * column of an element matrix.  The entry has two pointers: one to a count
 * of the number of entries and a list of affected rows, and another to the
 * actual data.  The row count and list is shared across all the columns of
 * a single element matrix, which cuts down somewhat on the memory overhead
 * for storing indices.  Memory is allocated from a fast pool-type allocator.
 *
 * In the compression phase, we merge duplicates in each column.  We do this by
 * simply accumulating all the contributions into a {\em dense} vector.  At the
 * same time, we build a list of positions (without repeats) of nonzeros in the
 * accumulation vector.  As we go, we keep track of whether we have seen a
 * nonzero before by keeping a bit vector with a mark for each known nonzero
 * location.  After processing all the data for the column, we sort the indices
 * that correspond to nonzero positions and copy in the corresponding data from
 * the accumulation vector.  Finally, we zero out the nonzero entries in the
 * bit vector and the accumulation vector.
 *
 * The routine to compress the data into CSC format takes pre-allocated index
 * and data arrays as input.  To figure out the number of nonzero entries that
 * should be allocated in this compressed data structure, one can either take
 * a conservative estimate (e.g. the total number of nonzeroes including
 * duplicates, as returned by [[get_pre_nnz]]), or one can get the exact
 * nonzero count using a ``lightweight'' version of the compression algorithm
 * described above (as implemented by [[get_nnz]]).
 *
 * @q */
//

// REWRITE!!!!!!!!

#include <vector>
#include <algorithm>
// #include "block_alloc.h"


/***************************************************************************************/
struct IV_Pair
{
	int     I;
	double  V;
};

class MatrixAssembler: public AbstractAssembler {
public:
    MatrixAssembler(int m, int n, bool include_zeros = true) :
        pre_nnz(0), include_zeros(include_zeros), AbstractAssembler(m, n)
        {
		// create internal column stacks
		ColStack.clear();
		ColStack.resize(n);
		
		//mexPrintf("Constructor called!\n");
		
		// each entry:  "contains row,val pairs"
		for (int jj = 0; jj < n; ++jj) {
			//ColStack[jj].clear();
			ColStack[jj].reserve(10);
			}
        }
    ~MatrixAssembler ()
		{
		// clear it
		// each entry:  "contains row,val pairs"
		for (int jj = 0; jj < n; ++jj) {
			ColStack[jj].clear();
			}
		//
		ColStack.clear();
		//mexPrintf("Destructor called!\n");
		}

    int get_pre_nnz() { return pre_nnz; }

	void add_entries(const int*, const int*, const int*, const double*, const int&);
	
    int get_nnz();
    template<class intT>
    void fill_csc(intT* jc, intT* ir, double* pr);
    mxArray* export_matrix();

private:
    // struct ColRec {      // Record of one column of an element matrix:
        // int*    ir;      //  Row index data
        // double* pr;      //  Column data
        // ColRec* next;    //  List link
    // };

    int pre_nnz;         // Number of nonzeros, including duplicates
    bool include_zeros;  // Copy element zeros into matrix?

    // std::vector<ColRec*> cols;  // Column lists
    // Arena<ColRec> cpool;
    // Arena<int>    ipool;
    // Arena<double> dpool;
	
	// test stuff Column-Stacks
	std::vector< std::vector<IV_Pair> > ColStack;
};



// bool IV_Pair_Comparision(IV_Pair& p, int index)
// {
	// if(p.I == index)
		// return true;
	// else
		// return false;
// }

// struct IV_Pair_Comp
// {
  // explicit IV_Pair_Comp(int i) n(i) { }
  // inline bool operator()(const IV_Pair & p) const { return p.I == n; }
// private:
  // int n;
// };

void MatrixAssembler::add_entries(const int*    coo_i, const int* coo_j,  const int* coo_j_iv_range,
                                  const double* coo_v, const int& num_col)
{
    // go through each column in ascending order
    for (int jj = 0; jj < num_col; ++jj) {
        const int  col_index = coo_j[jj];
		
		// get the local range (for the current column)
		const int local_start = coo_j_iv_range[jj];
		const int local_end   = coo_j_iv_range[jj+1];
		
        if (col_index >= 0 && col_index < n) {
			std::vector<IV_Pair>& Current_Col = ColStack[col_index];
			for (int ii = local_start; ii < local_end; ++ii) {
				const int row_index = coo_i[ii];
				if (row_index < 0 || row_index >= m) {
					printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
					printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",row_index,m);
					printf("Note: C-style indexing is used here.\n");
					printf("See 'assembler.cc'.\n");
					}
				// linear search to find if entry is already there
				std::vector<IV_Pair>::iterator  row_find;
				row_find = std::find_if(Current_Col.begin(), Current_Col.end(),
				           [&row_index] (IV_Pair const& p) -> bool { return p.I == row_index; } );
				
				// // [&row_index](int kk, int qq) { return (Row_Indices_0[kk] < Row_Indices_0[qq]); });
				//[i](LWItem a)->bool { return a->GetID()==i; } 

// find_if(strings.begin(), strings.end(), [](const string& s) {
    // return matches_wildcard(s, "hell*");
// });
				
// // std::find_if(v.begin(), v.end(),
             // // [n](const MyClass & m) -> bool { return m.myInt == n; });
				
				const double val = coo_v[ii];
				// found index!
				if (row_find!=Current_Col.end()) {
					// mexPrintf("Found!\n");
					(*row_find).V += val; // add it in
					// mexPrintf("I = %d,   V = %1.5G\n",row_index,(*row_find).V);
				}
				else {
					// mexPrintf("size = %d,   capacity = %d\n",(int) Current_Col.size(), (int) Current_Col.capacity());
					const size_t CC_size = Current_Col.size();
					if (CC_size==Current_Col.capacity()) {
						Current_Col.reserve(CC_size + 10);
					}
					// mexPrintf("Not found!\n");
					IV_Pair  my_pair;
					my_pair.I = row_index;
					my_pair.V = val;
					// mexPrintf("I = %d,   V = %1.5G\n",my_pair.I,my_pair.V);
					Current_Col.push_back(my_pair);
				}
			}
		}
		else {
			printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
			printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",col_index,n);
			printf("Note: C-style indexing is used here.\n");
			printf("See 'assembler.cc'.\n");
		}
    }
	pre_nnz += coo_j_iv_range[num_col];
}


// void MatrixAssembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                  // const int* no_use)
// {
    // add_entries(iAe, jAe, Ae, mAe, nAe);
// }

// void MatrixAssembler::add_entries(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                  // const int* no_use1, const mwIndex** no_use2, const bool& none)
// {
    // add_entries(iAe, jAe, Ae, mAe, nAe);
// }

// /* this uses a sorted IJV format to add the entries
   // NOTE: if you want to add the transpose, then that needs to be done outside this! */
// void MatrixAssembler::add_entries(const int*    coo_i, const int* coo_j,const int* coo_j_iv_range,
                                  // const int&  num_row, const int& num_col,
                                  // const double* coo_v)
// {
// }

// /* add the transpose of the local FE matrix */
// void MatrixAssembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe)
// {
    // ColRec* csave = cpool.malloc(nAe);
    // int*    isave = ipool.malloc(mAe+1);
    // int     TOTAL = mAe*nAe;
    // double* dsave = dpool.malloc(TOTAL);
    // isave[0] = mAe;
    // for (int ii = 0; ii < mAe; ++ii) {
        // const int row_index = iAe[ii];
        // isave[ii+1] = row_index;
        // if (row_index < 0 || row_index >= m) {
            // printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
            // printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",row_index,m);
            // printf("Note: C-style indexing is used here.\n");
            // printf("See 'assembler.cc'.\n");
            // }
        // }
    // // copy the transpose
    // for (unsigned int jj = 0; jj < (unsigned int)nAe; ++jj)
        // for (unsigned int ii = 0; ii < (unsigned int)mAe; ++ii)
            // dsave[ii*nAe + jj] = Ae[jj*mAe + ii];

    // for (unsigned int jj = 0; jj < (unsigned int)nAe; ++jj) {
        // const unsigned int col_index = (unsigned int)(jAe[jj]);
        // if (col_index < (unsigned int)n) {
            // csave[jj].ir = isave;
            // csave[jj].pr = dsave+jj*mAe;
            // csave[jj].next = cols[col_index];
            // cols[col_index] = csave+jj;
        // }
        // else {
            // printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
            // printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",col_index,n);
            // printf("Note: C-style indexing is used here.\n");
            // printf("See 'assembler.cc'.\n");
        // }
    // }
    // pre_nnz += TOTAL;
// }

// void MatrixAssembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                  // const int* no_use)
// {
    // add_entries_transpose(iAe, jAe, Ae, mAe, nAe);
// }

// void MatrixAssembler::add_entries_transpose(const int* iAe, const int* jAe, const double* Ae, const int& mAe, const int& nAe,
                                  // const int* no_use1, const mwIndex** no_use2, const bool& none)
// {
    // add_entries_transpose(iAe, jAe, Ae, mAe, nAe);
// }


int MatrixAssembler::get_nnz()
{
	int nnz = 0;
	for (std::vector< std::vector<IV_Pair> >::iterator it = ColStack.begin(); it != ColStack.end(); ++it) {
		nnz += (int) (*it).size();
	}
    return nnz;
}

template<class intT>
void MatrixAssembler::fill_csc(intT* jc, intT* ir, double* pr)
{
    jc[0] = 0;
	for (unsigned int j = 0; j < (unsigned int)n; ++j) {
		// focus on the current column
		std::vector<IV_Pair>& Current_Col = ColStack[j];
		
		std::vector<int> local_row_ind(Current_Col.size(),0); // init with all zeros
		// fill with increasing numbers: 0, 1, 2, ..., N-1
		for (int kk = 0; kk < local_row_ind.size(); ++kk) {
			local_row_ind[kk] = kk;
		}
		
		// sort so the row indices are in increasing order
		std::sort(local_row_ind.begin(), local_row_ind.end(),
              [&Current_Col](int kk, int qq) { return (Current_Col[kk].I < Current_Col[qq].I); });

		// build the CSC format
		const intT Num_in_Col = (intT) Current_Col.size(); // number of entries in the column
		for (int kk = 0; kk < Num_in_Col; ++kk) {
			ir[jc[j]+kk] = (intT)   Current_Col[local_row_ind[kk]].I;
			pr[jc[j]+kk] = (double) Current_Col[local_row_ind[kk]].V;
		}
		jc[j+1] = jc[j] + Num_in_Col; // record where the column entries start
	}
}

mxArray* MatrixAssembler::export_matrix()
{
    int nnz = get_nnz();
    mxArray* result = mxCreateSparse((mwSize)m, (mwSize)n, (mwSize)nnz, mxREAL);
    fill_csc(mxGetJc(result), mxGetIr(result), mxGetPr(result));
    return result;
}
