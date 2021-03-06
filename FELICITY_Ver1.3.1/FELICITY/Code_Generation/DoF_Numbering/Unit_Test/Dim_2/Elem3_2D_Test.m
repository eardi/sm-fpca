function Elem = Elem3_2D_Test()
%Elem3_2D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 10-12-2016,  Shawn W. Walker

% name it!
Elem.Name = 'Elem3_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 2;
Elem.Domain = 'triangle';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis(18).Func = [];
Elem.Basis(1).Func = {'x'};
Elem.Basis(2).Func = {'y'};
Elem.Basis(3).Func = {'1 - x - y'};
Elem.Basis(4).Func = {'x'};
Elem.Basis(5).Func = {'y'};
Elem.Basis(6).Func = {'1 - x - y'};
Elem.Basis(7).Func = {'x'};
Elem.Basis(8).Func = {'y'};
Elem.Basis(9).Func = {'1 - x - y'};
Elem.Basis(10).Func = {'y'};
Elem.Basis(11).Func = {'1 - x - y'};
Elem.Basis(12).Func = {'x'};
Elem.Basis(13).Func = {'y'};
Elem.Basis(14).Func = {'1 - x - y'};
Elem.Basis(15).Func = {'x'};
Elem.Basis(16).Func = {'y'};
Elem.Basis(17).Func = {'1 - x - y'};
Elem.Basis(18).Func = {'1 - x - y'};

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(18).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 1, 0], 'eval_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 0, 1], 'eval_facet', 2};
Elem.Nodal_Var(6).Data = {[1, 0, 0], 'eval_facet', 3};
Elem.Nodal_Var(7).Data = {[0, 0, 1], 'eval_facet', 1};
Elem.Nodal_Var(8).Data = {[1, 0, 0], 'eval_facet', 2};
Elem.Nodal_Var(9).Data = {[0, 1, 0], 'eval_facet', 3};
Elem.Nodal_Var(10).Data = {[0, 1, 0], 'eval_facet', 1};
Elem.Nodal_Var(11).Data = {[0, 0, 1], 'eval_facet', 2};
Elem.Nodal_Var(12).Data = {[1, 0, 0], 'eval_facet', 3};
Elem.Nodal_Var(13).Data = {[0, 0, 1], 'eval_facet', 1};
Elem.Nodal_Var(14).Data = {[1, 0, 0], 'eval_facet', 2};
Elem.Nodal_Var(15).Data = {[0, 1, 0], 'eval_facet', 3};
Elem.Nodal_Var(16).Data = {[1, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(17).Data = {[0, 1, 0], 'eval_vertex', 2};
Elem.Nodal_Var(18).Data = {[0, 0, 1], 'eval_vertex', 3};

%%%%% nodal (topological) arrangement

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3],...
                    [16; 17; 18]};
%

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[4, 7;
                     5, 8;
                     6, 9],...
                    [10, 13;
                     11, 14;
                     12, 15]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % none

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end