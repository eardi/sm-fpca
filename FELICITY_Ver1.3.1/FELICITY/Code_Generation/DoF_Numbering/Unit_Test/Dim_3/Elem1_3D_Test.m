function Elem = Elem1_3D_Test()
%Elem1_3D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% name it!
Elem.Name = 'Elem1_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis(4).Func = []; % init
Elem.Basis(1).Func = {'1 - x - y - z'};
Elem.Basis(2).Func = {'x'};
Elem.Basis(3).Func = {'y'};
Elem.Basis(4).Func = {'z'};

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(4).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1, 0], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 0, 0, 1], 'eval_vertex', 4};

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3; 4]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]}; %

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % 

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; %

end