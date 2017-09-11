/***

A matrix RE-assembler for MATLAB
Copyright (c) 2013
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
		//std::copy(pr1, (pr1+nnz), pr_ptr); // copy old matrix over (for testing purposes)
		}
    ~MatrixReassembler () {}

	int nnz;
	int find_row(const int kvals[5], const int ir_vals[3], const int& i);
    void add_entries(int* i, int* j, double* A, int m, int n,
                     int shift_i, int shift_j);
    mxArray* export_matrix() { return result; }
	
private:

	// access to data
    mwIndex* jc_ptr;
    mwIndex* ir_ptr;
	double*  pr_ptr;
	
	mxArray* result;
};

// int MatrixReassembler::find_row(int klo, int khi, const int& i)
// {
    // // for (int index = klo; index <= khi; index++) {
		// // if (((int)ir_ptr[index])==i) return index;
	// // } // brute force code
    // while (klo <= khi) {
        // const int kmid = klo + (khi-klo)/2;
        // const int imid = (int) ir_ptr[kmid];
        // if (imid < i)
            // klo = kmid + 1;
        // else if (imid > i)
            // khi = kmid - 1;
        // else
            // return kmid;
    // }
    // return -1;
// }

int MatrixReassembler::find_row(const int kvals[5], const int ir_vals[3], const int& i)
{
	int klo, khi;
	// do pre-recorded search
	if (ir_vals[1] < i)
		{
		if (ir_vals[2] < i)
			{
			klo = kvals[3] + 1;
			khi = kvals[4];
			}
		else if (ir_vals[2] > i)
			{
			klo = kvals[2] + 1;
			khi = kvals[3] - 1;
			}
		else
			return kvals[3];
		}
	else if (ir_vals[1] > i)
		{
		if (ir_vals[0] < i)
			{
			klo = kvals[1] + 1;
			khi = kvals[2] - 1;
			}
		else if (ir_vals[0] > i)
			{
			klo = kvals[0];
			khi = kvals[1] - 1;
			}
		else
			return kvals[1];
		}
	else
		return kvals[2];

	// continue with search
    while (klo <= khi) {
        const int kmid = klo + (khi-klo)/2;
        const int imid = (int) ir_ptr[kmid];
        if (imid < i)
            klo = kmid + 1;
        else if (imid > i)
            khi = kmid - 1;
        else
            return kmid;
    }
    return -1;
}

void MatrixReassembler::add_entries(int* iAe, int* jAe, double* Ae, int mAe, int nAe,
                                    int shift_i, int shift_j)
{
	// loop through columns of local matrix
    for (int jj = 0; jj < nAe; ++jj, Ae += mAe) {
        const int j = jAe[jj] + shift_j;
		
		// record initial part of binary search
		int kvals[5];
		kvals[0] = (int)  jc_ptr[j];
		kvals[4] = (int) (jc_ptr[j+1] - 1);
		const int N_4 = (kvals[4] - kvals[0])/4;
		kvals[1] = kvals[0] + N_4;
		kvals[2] = kvals[1] + N_4;
		kvals[3] = kvals[2] + N_4;
		const int ir_vals[3] = {(int) ir_ptr[kvals[1]], (int) ir_ptr[kvals[2]], (int) ir_ptr[kvals[3]]};
		
        if (j >= 0 && j < n) {
			// loop through rows of local matrix
            for (int ii = 0; ii < mAe; ++ii) {
                const int i = iAe[ii] + shift_i;
				const int k = find_row(kvals, ir_vals, i);
                if (k >= 0)
                    pr_ptr[k] += Ae[ii];
                else 
                    mexPrintf("Failed element update (%d, %d)\n", i, j);
            }
        }
    }
}
