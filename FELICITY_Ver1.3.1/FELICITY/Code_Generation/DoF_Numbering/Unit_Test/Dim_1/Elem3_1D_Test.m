function Elem = Elem3_1D_Test()
%Elem3_1D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% name it!
Elem.Name = 'Elem3_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 1;
Elem.Domain = 'interval';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis(6).Func = [];
Elem.Basis(1).Func = {'x'};
Elem.Basis(2).Func = {'1 - x'};
Elem.Basis(3).Func = {'x'};
Elem.Basis(4).Func = {'1 - x'};
Elem.Basis(5).Func = {'x'};
Elem.Basis(6).Func = {'1 - x'};

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(6).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[1, 0], 'eval_cell', 1};
Elem.Nodal_Var(4).Data = {[0, 1], 'eval_cell', 1};
Elem.Nodal_Var(5).Data = {[1, 0], 'eval_vertex', 1};
Elem.Nodal_Var(6).Data = {[0, 1], 'eval_vertex', 2};

%%%%% nodal (topological) arrangement

% nodes attached to vertices
Elem.Nodal_Top.V = {[1;
                     2],...
                    [5;
                     6]};
%

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[3, 4]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % no triangle in 1-D

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 1-D

end