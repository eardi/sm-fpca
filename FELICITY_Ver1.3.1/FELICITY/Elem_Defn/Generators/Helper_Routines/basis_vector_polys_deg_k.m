function basis = basis_vector_polys_deg_k(indep_vars,deg_k,num_comp,exact)
%basis_vector_polys_deg_k
%
%   This returns a set of vector-valued basis polynomials (of degree <= k)
%   in the given independent variables.
%
%   indep_vars = col. vector of symbolic independent vars;
%                all must be distinct!
%   deg_k      = maximum degree of basis polynomials.
%   num_comp   = number of vector components.
%   exact      = boolean
%                 true: degree of polynomial basis functions is *exactly* deg_k.
%                false: (default) degree of basis functions is <= deg_k.

% Copyright (c) 09-30-2016,  Shawn W. Walker

if (nargin==3)
    exact = false;
end

% scalar basis functions
scalar_basis = basis_polys_deg_k(indep_vars,deg_k,exact);
num_scalar_basis = length(scalar_basis);

% tensor product the scalar basis functions
num_vec_basis = num_comp*num_scalar_basis;
basis(num_vec_basis).func = []; % init
zero_vec_func = sym(zeros(num_comp,1));
for vv = 1:num_comp
    for ii = 1:num_scalar_basis
        scalar_func = scalar_basis(ii).func;
        vec_func = zero_vec_func; % init
        % form vector basis function
        vec_func(vv) = scalar_func;
        basis(ii + (vv-1)*num_scalar_basis).func = vec_func;
    end
end

end