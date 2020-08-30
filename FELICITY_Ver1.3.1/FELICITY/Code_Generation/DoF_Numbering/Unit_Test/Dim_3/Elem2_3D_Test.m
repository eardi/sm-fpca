function Elem = Elem2_3D_Test()
%Elem2_3D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% name it!
Elem.Name = 'Elem2_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim    = 3;
Elem.Domain = 'tetrahedron';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis(12).Func = [];
Elem.Basis(1).Func = {'1 - x - y - z'};
Elem.Basis(2).Func = {'x'};
Elem.Basis(3).Func = {'y'};
Elem.Basis(4).Func = {'x'};
Elem.Basis(5).Func = {'y'};
Elem.Basis(6).Func = {'z'};
Elem.Basis(7).Func = {'1 - x - y - z'};
Elem.Basis(8).Func = {'x'};
Elem.Basis(9).Func = {'y'};
Elem.Basis(10).Func = {'x'};
Elem.Basis(11).Func = {'y'};
Elem.Basis(12).Func = {'z'};

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(12).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(3).Data = {[1, 0, 0, 0], 'eval_edge', 2};
Elem.Nodal_Var(4).Data = {[0, 0, 1, 0], 'eval_edge', 2};
Elem.Nodal_Var(5).Data = {[1, 0, 0, 0], 'eval_edge', 3};
Elem.Nodal_Var(6).Data = {[0, 0, 0, 1], 'eval_edge', 3};
Elem.Nodal_Var(7).Data = {[0, 1, 0, 0], 'eval_edge', 4};
Elem.Nodal_Var(8).Data = {[0, 0, 1, 0], 'eval_edge', 4};
Elem.Nodal_Var(9).Data = {[0, 0, 1, 0], 'eval_edge', 5};
Elem.Nodal_Var(10).Data = {[0, 0, 0, 1], 'eval_edge', 5};
Elem.Nodal_Var(11).Data = {[0, 0, 0, 1], 'eval_edge', 6};
Elem.Nodal_Var(12).Data = {[0, 1, 0, 0], 'eval_edge', 6};

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[ 1  2;
                      3  4;
                      5  6;
                      7  8;
                      9 10;
                     11 12]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % 

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; %

end