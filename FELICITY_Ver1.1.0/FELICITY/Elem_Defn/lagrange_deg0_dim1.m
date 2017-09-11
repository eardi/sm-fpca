function Elem = lagrange_deg0_dim1()
%lagrange_deg0_dim1
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 03-28-2012,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% DIS-continuous galerkin space
Elem.Type = 'DG';

% intrinsic dimension and domain
Elem.Dim = 1;
Elem.Domain = 'interval';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func =...
    {{'1'}};
% local mapping transformation to use
Elem.Basis.Transformation = 'H1_Trans';
Elem.Degree = 0;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, (1/2) * [1,1]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]}; % NONE

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[1]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % no triangles in 1-D

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 1-D

end