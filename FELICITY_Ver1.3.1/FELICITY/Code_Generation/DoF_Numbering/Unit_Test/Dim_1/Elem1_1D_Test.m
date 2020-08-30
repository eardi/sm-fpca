function Elem = Elem1_1D_Test()
%Elem1_1D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% name it!
Elem.Name = 'Elem1_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 1;
Elem.Domain = 'interval';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis(2).Func = [];
Elem.Basis(1).Func = {'1 - x'};
Elem.Basis(2).Func = {'x'};

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(2).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1], 'eval_vertex', 2};

%%%%% nodal (topological) arrangement

% nodes attached to vertices
Elem.Nodal_Top.V = {[1;
                     2]};
%

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % no triangle in 1-D

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 1-D

end