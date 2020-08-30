function LU = Get_LU(obj,Big_Matrix)
%Get_LU
%
%   This calls MATLAB's "lu" command.  This routine should be used with "Solve_With_LU".

% Copyright (c) 05-05-2014,  Shawn W. Walker

LU.L = [];
LU.U = [];
LU.p = [];
LU.q = [];
LU.r = [];

[LU.L, LU.U, LU.p, LU.q, R] = lu(Big_Matrix,'vector');
LU.r = full(diag(R,0));

% [L,U,P,Q,R] = LU(A) returns unit lower triangular matrix L, upper
%     triangular matrix U, permutation matrices P and Q, and a diagonal
%     scaling matrix R so that P*(R\A)*Q = L*U for sparse non-empty A.
%     This uses UMFPACK as well.  Typically, but not always, the row-scaling
%     leads to a sparser and more stable factorization.  Note that this
%     factorization is the same as that used by sparse MLDIVIDE when
%     UMFPACK is used.

end