function basis = basis_polys_deg_k(indep_vars,deg_k,exact)
%basis_polys_deg_k
%
%   This returns a set of basis polynomials (of degree <= k) in the given
%   independent variables.  If "exact" is true, then degree is exactly k.
%
%   indep_vars = col. vector of symbolic independent vars;
%                all must be distinct!
%   deg_k      = maximum degree of basis polynomials.
%   exact      = boolean
%                 true: degree of polynomial basis functions is *exactly* deg_k.
%                false: (default) degree of basis functions is <= deg_k.

% Copyright (c) 09-30-2016,  Shawn W. Walker

if (nargin==2)
    exact = false;
end

% check that independent variables are distinct
num_vars = length(indep_vars);
var_list = symvar(indep_vars);
if length(var_list)~=num_vars
    error('Independent variables are not distinct!');
end

% create matrix containing exponent multiindex for creating poly basis
deg_mat = create_exponent_multiindex_matrix(num_vars,deg_k,exact);
%deg_mat

num_basis = size(deg_mat,1);
basis(num_basis).func = []; % init
for ii = 1:num_basis
    deg_vec = deg_mat(ii,:)';
    basis(ii).func = prod(indep_vars.^deg_vec);
end

end