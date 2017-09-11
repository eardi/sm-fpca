function Elem = Elem1_1D_Test()
%Elem1_1D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% name it!
Elem.Name = 'Elem1_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 1;
Elem.Domain = 'interval';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis.Func =...
    {{'1 - x'};
     {'x'}};
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0];
     {'phi'}, [0,1]};
%

% NOTE: this IS used.
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