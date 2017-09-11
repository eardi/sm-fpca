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

    void add_entries(int* i, int* j, double* A, int m, int n,
                     int shift_i, int shift_j);
    mxArray* export_matrix();

private:
    mxArray* MATLAB_MAT;
    double*  pr;
};


void SimpleMatrixAssembler::add_entries(int* iAe, int* jAe, double* Ae, int mAe, int nAe,
                                        int shift_i, int shift_j)
{
    for (unsigned int ii = 0; ii < (unsigned int)mAe; ++ii) {
        for (unsigned int jj = 0; jj < (unsigned int)nAe; ++jj) {
            unsigned int row_index = (unsigned int) (iAe[ii] + shift_i);
            unsigned int col_index = (unsigned int) (jAe[jj] + shift_j);
            if (row_index >= (unsigned int)m) {
                printf("Warning: local element matrix row indices outside range of Global Matrix!\n");
                printf("Bad row index is: %d.  The row index should be >= 0 and < %d.\n",row_index,m);
                printf("See 'simple_assembler.cc'.\n");
                }
            else if (col_index >= (unsigned int)n) {
                printf("Warning: local element matrix column indices outside range of Global Matrix!\n");
                printf("Bad column index is: %d.  The column index should be >= 0 and < %d.\n",col_index,n);
                printf("See 'simple_assembler.cc'.\n");
                }
            else {
                // add in the entries
                pr[col_index*(unsigned int)m + row_index] += Ae[jj*(unsigned int)mAe + ii];
                }
            }
        }
}


mxArray* SimpleMatrixAssembler::export_matrix()
{
    return MATLAB_MAT;
}
