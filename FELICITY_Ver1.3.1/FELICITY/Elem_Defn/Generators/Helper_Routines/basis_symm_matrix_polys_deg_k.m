function [basis, const_basis] = basis_symm_matrix_polys_deg_k(indep_vars,deg_k,mat_size,exact)
%basis_symm_matrix_polys_deg_k
%
%   This returns a set of symmetric matrix-valued basis polynomials
%   (of degree <= k) in the given independent variables.
%
%   indep_vars = col. vector of symbolic independent vars;
%                all must be distinct!
%   deg_k      = maximum degree of basis polynomials.
%   mat_size   = size of matrix.
%   exact      = boolean
%                 true: degree of polynomial basis functions is *exactly* deg_k.
%                false: (default) degree of basis functions is <= deg_k.

% Copyright (c) 03-22-2018,  Shawn W. Walker

if (nargin==3)
    exact = false;
end

% scalar basis functions
scalar_basis = basis_polys_deg_k(indep_vars,deg_k,exact);
num_scalar_basis = length(scalar_basis);

% tensor product the scalar basis functions
const_basis = get_symm_mat_basis(mat_size);
num_basis_of_symm_mat = mat_size * (mat_size+1)/2;
if (length(const_basis)~=num_basis_of_symm_mat)
    error('These should match!');
end
num_mat_basis = num_basis_of_symm_mat * num_scalar_basis;
basis(num_mat_basis).func = []; % init

for mm = 1:num_basis_of_symm_mat
    for ii = 1:num_scalar_basis
        scalar_func = scalar_basis(ii).func;
        % form symmetric matrix basis function
        mat_func = const_basis(mm).mat * scalar_func;
        basis(ii + (mm-1)*num_scalar_basis).func = mat_func;
    end
end

end

function const_basis = get_symm_mat_basis(mat_size)

num_basis_of_symm_mat = mat_size * (mat_size+1)/2;
const_basis(num_basis_of_symm_mat).mat = [];

% init
zero_mat = zeros(mat_size,mat_size);

% get diagonal component bases
for kk = 1:mat_size
    MB = zero_mat;
    MB(kk,kk) = 1;
    const_basis(kk).mat = MB;
end
INDEX = mat_size;

% get off-diagonal component bases
for ii = 1:mat_size
for jj = ii+1:mat_size
    MB = zero_mat;
    MB(ii,jj) = 1;
    INDEX = INDEX + 1;
    const_basis(INDEX).mat = (1/2)*(MB + MB');
end
end

end