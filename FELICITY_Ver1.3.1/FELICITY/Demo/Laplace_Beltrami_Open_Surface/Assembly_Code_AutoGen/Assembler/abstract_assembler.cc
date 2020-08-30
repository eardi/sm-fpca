/***

XXXXXXXXXX -- sparse matrix assembly for MATLAB
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

// REWRITE


class AbstractAssembler {
public:
    //AbstractAssembler (); // constructor
    AbstractAssembler(int m, int n) :
        m(m), n(n) {}
    virtual ~AbstractAssembler () {} // DE-structor (it MUST be virtual!)

    int get_m() { return m; }
    int get_n() { return n; }

    // multiple versions depending on what is supplied
    virtual void add_entries(const int*, const int*, const int*, const double*, const int&)=0;

    virtual mxArray* export_matrix()=0;

protected:
    int m, n;            // Matrix dimensions
};
