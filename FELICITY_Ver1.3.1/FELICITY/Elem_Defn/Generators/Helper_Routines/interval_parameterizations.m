function Cell = interval_parameterizations()
%interval_parameterizations
%
%   This creates a structure containing parameterizations of the reference
%   interval ........as well as param's of the facets (edges).
%
%   Note: The "u" coordinates are the local variables for computing
%         integrations to evaluate nodal degrees of freedom.
%         The "x" coordinates are the global variables (in which to
%         express the nodal basis functions).

% Copyright (c) 09-24-2016,  Shawn W. Walker

syms u x real;
% two = sym('2');
% sqrt_2 = sqrt(two);
%z0 = sym('0');

% define cell (interval) parameterization
% [x] = X(u)
% [u] = X^{-1}(x)
Cell.Param     = [u]; % 0 <= u <= 1
Cell.Param_Inv = [x]; % 0 <= x <= 1
Cell.Measure   = sym(1);

% define facet (vertex) stuff (normals)
Cell.Facet(2).Param      = []; % init
Cell.Facet(1).Normal     = sym([-1]);
Cell.Facet(1).Measure    = sym(0);
Cell.Facet(2).Normal     = sym([1]);
Cell.Facet(2).Measure    = sym(0);

end