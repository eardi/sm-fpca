function x = Solve_With_LU(obj,LU,b)
%Solve_With_LU
%
%   This solves a linear Ax = b system by a pre-computed LU decomp.  Use the "Get_LU"
%   sub-routine with this.

% Copyright (c) 05-05-2014,  Shawn W. Walker

b_rescaled = b ./ LU.r; % pre-scaling
c = b_rescaled(LU.p,1); % permute

% back-substitution
v = LU.L \ c;
w = LU.U \ v;

x = 0*w; % init
x(LU.q) = w; % permute

% [L,U,P,Q,R] = LU(A) returns unit lower triangular matrix L, upper
%     triangular matrix U, permutation matrices P and Q, and a diagonal
%     scaling matrix R so that P*(R\A)*Q = L*U for sparse non-empty A.
%     This uses UMFPACK as well.  Typically, but not always, the row-scaling
%     leads to a sparser and more stable factorization.  Note that this
%     factorization is the same as that used by sparse MLDIVIDE when
%     UMFPACK is used.

end