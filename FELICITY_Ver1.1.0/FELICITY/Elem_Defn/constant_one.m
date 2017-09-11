function Elem = constant_one()
%constant_one
%
%   This defines a finite element to be used by FELICITY.
%   For this particular element, most values are EMPTY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% no space - this function is identically ONE
Elem.Type = 'constant_one';

% intrinsic dimension and domain
Elem.Dim = [];
Elem.Domain = [];

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func = {{'1'}};
Elem.Basis.Transformation = 'H1_Trans'; % local mapping transformation to use
Elem.Degree = 0;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = '';
Elem.Nodal_Var.Basis = {};

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]};

end