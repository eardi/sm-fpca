function Elem = Elem4_3D_Test()
%Elem4_3D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% name it!
Elem.Name = 'Elem4_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim    = 3;
Elem.Domain = 'tetrahedron';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis(16).Func = [];
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
Elem.Basis(13).Func = {'1 - x - y - z'};
Elem.Basis(14).Func = {'x'};
Elem.Basis(15).Func = {'y'};
Elem.Basis(16).Func = {'x'};

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(16).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 0, 1/2, 1/2], 'eval_facet', 1, 'dof_set', 1};
Elem.Nodal_Var(2).Data = {[0, 1/2, 0, 1/2], 'eval_facet', 1, 'dof_set', 1};
Elem.Nodal_Var(3).Data = {[0, 1/2, 1/2, 0], 'eval_facet', 1, 'dof_set', 1};

Elem.Nodal_Var(4).Data = {[0, 0, 1/2, 1/2], 'eval_facet', 2, 'dof_set', 1};
Elem.Nodal_Var(5).Data = {[1/2, 0, 1/2, 0], 'eval_facet', 2, 'dof_set', 1};
Elem.Nodal_Var(6).Data = {[1/2, 0, 0, 1/2], 'eval_facet', 2, 'dof_set', 1};

Elem.Nodal_Var(7).Data = {[0, 1/2, 0, 1/2], 'eval_facet', 3, 'dof_set', 1};
Elem.Nodal_Var(8).Data = {[1/2, 0, 0, 1/2], 'eval_facet', 3, 'dof_set', 1};
Elem.Nodal_Var(9).Data = {[1/2, 1/2, 0, 0], 'eval_facet', 3, 'dof_set', 1};

Elem.Nodal_Var(10).Data = {[0, 1/2, 1/2, 0], 'eval_facet', 4, 'dof_set', 1};
Elem.Nodal_Var(11).Data = {[1/2, 1/2, 0, 0], 'eval_facet', 4, 'dof_set', 1};
Elem.Nodal_Var(12).Data = {[1/2, 0, 1/2, 0], 'eval_facet', 4, 'dof_set', 1};

Elem.Nodal_Var(13).Data = {[0, 1/3, 1/3, 1/3], 'eval_facet', 1, 'dof_set', 2};
Elem.Nodal_Var(14).Data = {[1/3, 0, 1/3, 1/3], 'eval_facet', 2, 'dof_set', 2};
Elem.Nodal_Var(15).Data = {[1/3, 1/3, 0, 1/3], 'eval_facet', 3, 'dof_set', 2};
Elem.Nodal_Var(16).Data = {[1/3, 1/3, 1/3, 0], 'eval_facet', 4, 'dof_set', 2};

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[ 1  2  3;
                      4  5  6;
                      7  8  9;
                     10 11 12],...
                     [13;
                      14;
                      15;
                      16]};
%

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; %

end