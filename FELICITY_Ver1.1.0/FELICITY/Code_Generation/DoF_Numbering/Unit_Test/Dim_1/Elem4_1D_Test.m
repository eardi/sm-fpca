function Elem = Elem4_1D_Test()
%Elem4_1D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% name it!
Elem.Name = 'Elem4_Test';

% DIScontinuous galerkin space
Elem.Type = 'DG';

% intrinsic dimension and domain
Elem.Dim = 1;
Elem.Domain = 'interval';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis.Func =...
    {{'1 - x'};
     {'x'};
     {'x*(1 - x)'}}; % quadratic bubble
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0];
     {'phi'}, [0,1];
     {'phi'}, [(1/2),(1/2)]};
%

% NOTE: this IS used.
%%%%% nodal (topological) arrangement

% nodes attached to vertices
Elem.Nodal_Top.V = {[1;
                     2]};
%

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[3]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % no triangle in 1-D

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 1-D

end