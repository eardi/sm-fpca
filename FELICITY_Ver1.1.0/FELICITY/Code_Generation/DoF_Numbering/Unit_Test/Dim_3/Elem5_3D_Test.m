function Elem = Elem5_3D_Test()
%Elem5_3D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 05-29-2013,  Shawn W. Walker

% name it!
Elem.Name = 'Elem5_Test';

% DIScontinuous galerkin space
Elem.Type = 'DG';

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
     {'z'};
     {'x*y*z*(1 - x - y - z)'}}; % quartic bubble
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1];
     {'phi'}, [0.25,0.25,0.25,0.25]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3; 4]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]}; %

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % 

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[5]}; %

end