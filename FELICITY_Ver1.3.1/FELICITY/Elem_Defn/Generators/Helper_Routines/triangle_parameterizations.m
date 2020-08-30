function Cell = triangle_parameterizations()
%triangle_parameterizations
%
%   This creates a structure containing parameterizations of the reference
%   triangle as well as param's of the facets (edges).
%
%   Note: The "u,v" coordinates are the local variables for computing
%         integrations to evaluate nodal degrees of freedom.
%         The "x,y" coordinates are the global variables (in which to
%         express the nodal basis functions).

% Copyright (c) 09-24-2016,  Shawn W. Walker

syms u v x y real;
two = sym('2');
sqrt_2 = sqrt(two);
z0 = sym('0');

% define cell (triangle) parameterization
% [x,y] = X(u,v)
% [u,v] = X^{-1}(x,y)
Cell.Param     = [u; v]; % 0 <= u,v <= 1,  0 <= u + v <= 1
Cell.Param_Inv = [x; y]; % 0 <= x,y <= 1,  0 <= x + y <= 1
Cell.Measure   = sym(1/2);

% define facet (edge) parametrizations (and unit normals)
% [x,y] = X(u)
%     u = X^{-1}(x,y)
Cell.Facet(3).Param      = []; % init

Cell.Facet(1).Local_Var  = u;
Cell.Facet(1).Param      = [1-u; u]; % = [x,y]; 0 <= u <= 1
Cell.Facet(1).Param_Inv  = [y];      % = u;     0 <= y <= 1
Cell.Facet(1).Normal     = [1/sqrt_2; 1/sqrt_2];
Cell.Facet(1).Measure    = sqrt_2;

Cell.Facet(2).Local_Var  = u;
Cell.Facet(2).Param      = [z0; 1-u]; % = [x,y]; 0 <= u <= 1
Cell.Facet(2).Param_Inv  = [1-y];     % = u;     0 <= y <= 1
Cell.Facet(2).Normal     = sym([-1; 0]);
Cell.Facet(2).Measure    = sym(1);

Cell.Facet(3).Local_Var  = u;
Cell.Facet(3).Param      = [u; z0]; % = [x,y]; 0 <= u <= 1
Cell.Facet(3).Param_Inv  = [x];     % = u;     0 <= x <= 1
Cell.Facet(3).Normal     = sym([0; -1]);
Cell.Facet(3).Measure    = sym(1);

% define edge parametrizations (and unit tangents)
% [x,y,z] = X(u)
%       u = X^{-1}(x,y,z)
% Note: these are the same as Cell.Facet(:).
Cell.Edge(3).Param      = []; % init

Cell.Edge(1).Local_Var  = Cell.Facet(1).Local_Var;
Cell.Edge(1).Param      = Cell.Facet(1).Param;
Cell.Edge(1).Param_Inv  = Cell.Facet(1).Param_Inv;
Cell.Edge(1).Tangent    = [-1/sqrt_2; 1/sqrt_2];
Cell.Edge(1).Measure    = sqrt_2;

Cell.Edge(2).Local_Var  = Cell.Facet(2).Local_Var;
Cell.Edge(2).Param      = Cell.Facet(2).Param;
Cell.Edge(2).Param_Inv  = Cell.Facet(2).Param_Inv;
Cell.Edge(2).Tangent    = sym([0; -1]);
Cell.Edge(2).Measure    = sym(1);

Cell.Edge(3).Local_Var  = Cell.Facet(3).Local_Var;
Cell.Edge(3).Param      = Cell.Facet(3).Param;
Cell.Edge(3).Param_Inv  = Cell.Facet(3).Param_Inv;
Cell.Edge(3).Tangent    = sym([1; 0]);
Cell.Edge(3).Measure    = sym(1);

end