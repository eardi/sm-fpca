function Elem = Elem4_2D_Test()
%Elem4_2D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% name it!
Elem.Name = 'Elem4_Test';

% DIScontinuous galerkin space
Elem.Type = 'DG';

% intrinsic dimension and domain
Elem.Dim = 2;
Elem.Domain = 'triangle';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func =...
    {{'1 - x - y'};
     {'x'};
     {'y'};
     {'x*y*(1 - x - y)'}}; % cubic bubble
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1];
     {'phi'}, [(1/3), (1/3), (1/3)]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]}; % NONE

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[4]};

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end