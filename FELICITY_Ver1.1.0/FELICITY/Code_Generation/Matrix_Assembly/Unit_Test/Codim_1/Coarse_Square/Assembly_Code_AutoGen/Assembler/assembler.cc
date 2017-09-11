/***

femat_sparse -- sparse matrix assembly for MATLAB
Copyright (c) 2008
David Bindel

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

#include <vector>
#include <algorithm>
// #include "block_alloc.h"


class MatrixAssembler: public AbstractAssembler {
public:
    MatrixAssembler(int m, int n, bool include_zeros = true) :
        pre_nnz(0), include_zeros(include_zeros), cols((unsigned int)n), AbstractAssembler(m, n) {}
    ~MatrixAssembler () {}

    int get_pre_nnz() { return pre_nnz; }

    void add_entries(int* i, int* j, double* A, int m, int n,
                     int shift_i, int shift_j);
    int get_nnz();
    template<class intT>
    void fill_csc(intT* jc, intT* ir, double* pr);
    mxArray* export_matrix();

private:
    struct ColRec {      // Record of one column of an element matrix:
        int*    ir;      //  Row index data
        double* pr;      //  Column data
        ColRec* next;    //  List link
    };

    int pre_nnz;         // Number of nonzeros, including duplicates
    bool include_zeros;  // Copy element zeros into matrix?

    std::vector<ColRec*> cols;  // Column lists
    Arena<ColRec> cpool;
    Arena<int>    ipool;
    Arena<double> dpool;
};


void MatrixAssembler::add_entries(int* iAe, int* jAe, double* Ae, int mAe, int nAe,
                                  int shift_i, int shift_j)
{
    ColRec* csave = cpool.malloc(nAe);
    int*    isave = ipool.malloc(mAe+1);
    int     TOTAL = mAe*nAe;
    double* dsave = dpool.malloc(TOTAL);
    isave[0] = mAe;
    for (int ii = 0; ii < mAe; ++ii) {
        int row_index = iAe[ii] + shift_i;
        isave[ii+1] = row_index;
        if (row_index < 0 || row_index >= m) {
            printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
            printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",row_index,m);
            printf("See 'assembler.cc'.\n");
            }
        }
    std::copy(Ae,  Ae+TOTAL, dsave);
    for (unsigned int jj = 0; jj < (unsigned int)nAe; ++jj) {
        unsigned int j = (unsigned int)(jAe[jj] + shift_j);
        if (j < (unsigned int)n) {
            csave[jj].ir = isave;
            csave[jj].pr = dsave+jj*mAe;
            csave[jj].next = cols[j];
            cols[j] = csave+jj;
        }
        else {
            printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
            printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",j,n);
            printf("See 'assembler.cc'.\n");
        }
    }
    pre_nnz += TOTAL;
}


int MatrixAssembler::get_nnz()
{
    std::vector<bool> marks((unsigned int)m);
    std::vector<int>  col_ir((unsigned int)m);
    int nnz = 0;
    for (unsigned int j = 0; j < (unsigned int)n; ++j) {
        unsigned int nnzcol = 0;
        for (ColRec* crec = cols[j]; crec != NULL; crec = crec->next) {
            int  nrows = crec->ir[0];
            int* rows  = crec->ir+1;
            double* v  = crec->pr;
            for (int ii = 0; ii < nrows; ++ii) {
                int row = rows[ii];
                if (row >= 0 && row < m && !marks[(unsigned int)row] &&
                    (include_zeros || v[ii] != 0)) {
                    col_ir[nnzcol++] = row;
                    marks[(unsigned int)row] = 1;
                }
            }
        }
        for (unsigned int k = 0; k < nnzcol; ++k)
            marks[(unsigned int)col_ir[k]] = 0;
        nnz += (int) nnzcol;
    }
    return nnz;
}


template<class intT>
void MatrixAssembler::fill_csc(intT* jc, intT* ir, double* pr)
{
    std::vector<bool>   marks((unsigned int)m);
    std::vector<double> col_pr((unsigned int)m);
    jc[0] = 0;
    for (unsigned int j = 0; j < (unsigned int)n; ++j) {
        int nnzcol = 0;
        for (ColRec* crec = cols[j]; crec != NULL; crec = crec->next) {
            int  nrows = crec->ir[0];
            int* rows  = crec->ir+1;
            double* v  = crec->pr;
            for (unsigned int ii = 0; ii < (unsigned int)nrows; ++ii) {
                unsigned int row = (unsigned int)rows[ii];
                if ((row < (unsigned int)m) && (include_zeros || v[ii] != 0)) {
                    col_pr[row] += v[ii];
                    if (!marks[row]) {
                        marks[row] = 1;
                        ir[nnzcol++] = (intT)row;
                    }
                }
            }
        }
        std::sort(ir, ir+nnzcol);
        for (int ii = 0; ii < nnzcol; ++ii) {
            unsigned int i     = (unsigned int) ir[ii];
            pr[ii]    = col_pr[i];
            col_pr[i] = 0;
            marks[i]  = 0;
        }
        ir += nnzcol;
        pr += nnzcol;
        jc[j+1] = jc[j]+nnzcol;
    }
}


mxArray* MatrixAssembler::export_matrix()
{
    int nnz = get_nnz();
    mxArray* result = mxCreateSparse((mwSize)m, (mwSize)n, (mwSize)nnz, mxREAL);
    fill_csc(mxGetJc(result), mxGetIr(result), mxGetPr(result));
    return result;
}
