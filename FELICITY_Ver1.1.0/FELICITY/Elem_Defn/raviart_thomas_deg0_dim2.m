function Elem = raviart_thomas_deg0_dim2()
%raviart_thomas_deg0_dim2
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
    {{'x'; 'y'};
     {'x - 1'; 'y - 0'};
     {'x - 0'; 'y - 1'}};
% local mapping transformation to use
Elem.Basis.Transformation = 'Hdiv_Trans';
Elem.Degree = 0;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'facet average'; % not implemented
Elem.Nodal_Var.Basis =...
    {{'phi'}, [0, (1/2), (1/2)];
     {'phi'}, [(1/2), 0, (1/2)];
     {'phi'}, [(1/2),(1/2), 0]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[1; 2; 3]}; %

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % NONE

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end