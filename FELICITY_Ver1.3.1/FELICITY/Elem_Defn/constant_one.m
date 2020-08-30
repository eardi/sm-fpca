function Elem = constant_one()
%constant_one
%
%   This defines a finite element to be used by FELICITY, which is the
%   constant "1".  For this particular element, most values are EMPTY.

% Copyright (c) 01-11-2018,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% no space - this function is identically ONE everywhere
Elem.Type = 'constant_one';

% intrinsic dimension and domain
Elem.Dim = [];
Elem.Domain = [];

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(1).Func = {'1'};
Elem.Transformation = 'Constant_Trans'; % local mapping transformation to use
Elem.Degree = 0;

% nodal variable data
Elem.Nodal_Var(1).Data = {};

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