function Elem = Elem1_3D_Test()
%Elem1_3D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% name it!
Elem.Name = 'Elem1_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func =...
    {{'1 - x - y - z'};
     {'x'};
     {'y'};
     {'z'}};
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3; 4]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]}; %

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % 
%F = {[{[1 2]}, {[3 4]}, {[5 6]}]; [{[1 2]}, {[3 4]}, {[5 6]}]; [{[1 2]}, {[3 4]}, {[5 6]}]; [{[1 2]}, {[3 4]}, {[5 6]}]};

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; %

end