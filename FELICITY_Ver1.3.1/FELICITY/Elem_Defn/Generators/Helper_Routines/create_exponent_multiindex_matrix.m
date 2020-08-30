function deg_mat = create_exponent_multiindex_matrix(num_vars,deg_k,exact)
%create_exponent_multiindex_matrix
%
%   This creates a matrix, where each row represents a multiindex which
%   will be the exponents to apply to some independent variables.
%
%   num_vars = number of indep variables.
%   deg_k    = maximum degree of sum of multiindex.
%   exact    = boolean
%               true: only return multiindices that sums *exactly* deg_k.
%              false: return multiindices that sum to <= deg_k.

% Copyright (c) 09-23-2016,  Shawn W. Walker

deg_vec = (0:1:deg_k)'; % defn
deg_mat = deg_vec; % init

for ii = 2:num_vars
    Len1 = size(deg_mat,1);
    next = kron(deg_vec,ones(Len1,1));
    r1   = repmat(deg_mat,[deg_k+1, 1]);
    deg_mat = [next, r1];
end

% sort it so its nice (low degrees appear first)
s1 = sum(deg_mat,2);
deg_mat_aux = [s1, deg_mat];
deg_mat_aux = sortrows(deg_mat_aux,1);

if exact
    % only keep the indices that give total degree EXACTLY k
    Mask = (deg_mat_aux(:,1) == deg_k);
else
    % only keep the indices that give total degree <= k
    Mask = (deg_mat_aux(:,1) <= deg_k);
end
deg_mat = deg_mat_aux(Mask,2:end);

end