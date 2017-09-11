function Elem = lagrange_deg1_dim2()
%lagrange_deg1_dim2
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 2;
Elem.Domain = 'triangle';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func =...
    {{'1 - x - y'};
     {'x'};
     {'y'}};
% local mapping transformation to use
Elem.Basis.Transformation = 'H1_Trans';
Elem.Degree = 1;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]}; % NONE

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % NONE

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end