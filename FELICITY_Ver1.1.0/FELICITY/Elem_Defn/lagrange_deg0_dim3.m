function Elem = lagrange_deg0_dim3()
%lagrange_deg0_dim3
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 08-10-2012,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% DIS-continuous galerkin space
Elem.Type = 'DG';

% intrinsic dimension and domain
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

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
    {{'phi'}, (1/4) * [1,1,1,1]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]}; % NONE

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]}; % NONE

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[1]};

end