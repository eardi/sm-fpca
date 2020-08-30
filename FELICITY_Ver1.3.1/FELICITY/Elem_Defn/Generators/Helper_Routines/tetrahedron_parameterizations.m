function Cell = tetrahedron_parameterizations()
%tetrahedron_parameterizations
%
%   This creates a structure containing parameterizations of the reference
%   tetrahedron as well as param's of the facets (faces) and edges.
%
%   Note: The "u,v,w" coordinates are the local variables for computing
%         integrations to evaluate nodal degrees of freedom.
%         The "x,y,z" coordinates are the global variables (in which to
%         express the nodal basis functions).

% Copyright (c) 09-24-2016,  Shawn W. Walker

syms u v w x y z real;
two = sym('2');
three = sym('3');
sqrt_2 = sqrt(two);
sqrt_3 = sqrt(three);
zz0 = sym('0');

% define cell (triangle) parameterization
% [x,y,z] = X(u,v,w)
% [u,v,w] = X^{-1}(x,y,z)
Cell.Param     = [u; v; w]; % 0 <= u,v,w <= 1,  0 <= u + v + w <= 1
Cell.Param_Inv = [x; y; z]; % 0 <= x,y,z <= 1,  0 <= x + y + z <= 1
Cell.Measure   = sym(1/6);

% define facet (face) parametrizations (and unit normals)
% [x,y,z] = X(u,v)
%   [u,v] = X^{-1}(x,y,z)
Cell.Facet(4).Param      = []; % init

Cell.Facet(1).Local_Var  = [u; v];
Cell.Facet(1).Param      = [1-u-v; u; v]; % = [x,y,z]; 0 <= u,v <= 1, 0 <= u + v <= 1
Cell.Facet(1).Param_Inv  = [y; z];        % = [u,v];   0 <= y,z <= 1
Cell.Facet(1).Normal     = [1/sqrt_3; 1/sqrt_3; 1/sqrt_3];
Cell.Facet(1).Measure    = sqrt_3/2;

Cell.Facet(2).Local_Var  = [u; v];
Cell.Facet(2).Param      = [zz0; v; u]; % = [x,y,z]; 0 <= u,v <= 1, 0 <= u + v <= 1
Cell.Facet(2).Param_Inv  = [z; y];      % = [u,v];   0 <= y,z <= 1
Cell.Facet(2).Normal     = sym([-1; 0; 0]);
Cell.Facet(2).Measure    = sym(1/2);

Cell.Facet(3).Local_Var  = [u; v];
Cell.Facet(3).Param      = [u; zz0; v]; % = [x,y,z]; 0 <= u,v <= 1, 0 <= u + v <= 1
Cell.Facet(3).Param_Inv  = [x; z];      % = [u,v];   0 <= x,z <= 1
Cell.Facet(3).Normal     = sym([0; -1; 0]);
Cell.Facet(3).Measure    = sym(1/2);

Cell.Facet(4).Local_Var  = [u; v];
Cell.Facet(4).Param      = [v; u; zz0]; % = [x,y,z]; 0 <= u,v <= 1, 0 <= u + v <= 1
Cell.Facet(4).Param_Inv  = [y; x];      % = [u,v];   0 <= x,y <= 1
Cell.Facet(4).Normal     = sym([0; 0; -1]);
Cell.Facet(4).Measure    = sym(1/2);

% define edge parametrizations (and unit tangents)
% [x,y,z] = X(u)
%       u = X^{-1}(x,y,z)
Cell.Edge(6).Param      = []; % init

Cell.Edge(1).Local_Var  = u;
Cell.Edge(1).Param      = [u; zz0; zz0]; % = [x,y,z]; 0 <= u <= 1
Cell.Edge(1).Param_Inv  = [x];           % = u;       0 <= x <= 1
Cell.Edge(1).Tangent    = sym([1; 0; 0]);
Cell.Edge(1).Measure    = sym(1);

Cell.Edge(2).Local_Var  = u;
Cell.Edge(2).Param      = [zz0; u; zz0]; % = [x,y,z]; 0 <= u <= 1
Cell.Edge(2).Param_Inv  = [y];           % = u;       0 <= y <= 1
Cell.Edge(2).Tangent    = sym([0; 1; 0]);
Cell.Edge(2).Measure    = sym(1);

Cell.Edge(3).Local_Var  = u;
Cell.Edge(3).Param      = [zz0; zz0; u]; % = [x,y,z]; 0 <= u <= 1
Cell.Edge(3).Param_Inv  = [z];           % = u;       0 <= z <= 1
Cell.Edge(3).Tangent    = sym([0; 0; 1]);
Cell.Edge(3).Measure    = sym(1);

Cell.Edge(4).Local_Var  = u;
Cell.Edge(4).Param      = [1-u; u; zz0]; % = [x,y,z]; 0 <= u <= 1
Cell.Edge(4).Param_Inv  = [y];           % = u;       0 <= y <= 1
Cell.Edge(4).Tangent    = [-1/sqrt_2; 1/sqrt_2; zz0];
Cell.Edge(4).Measure    = sqrt_2;

Cell.Edge(5).Local_Var  = u;
Cell.Edge(5).Param      = [zz0; 1-u; u]; % = [x,y,z]; 0 <= u <= 1
Cell.Edge(5).Param_Inv  = [z];           % = u;       0 <= z <= 1
Cell.Edge(5).Tangent    = [zz0; -1/sqrt_2; 1/sqrt_2];
Cell.Edge(5).Measure    = sqrt_2;

Cell.Edge(6).Local_Var  = u;
Cell.Edge(6).Param      = [u; zz0; 1-u]; % = [x,y,z]; 0 <= u <= 1
Cell.Edge(6).Param_Inv  = [x];           % = u;       0 <= x <= 1
Cell.Edge(6).Tangent    = [1/sqrt_2; zz0; -1/sqrt_2];
Cell.Edge(6).Measure    = sqrt_2;

end