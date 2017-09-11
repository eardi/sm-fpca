function Elem = brezzi_douglas_marini_deg1_dim2()
%brezzi_douglas_marini_deg1_dim2
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 04-03-2012,  Shawn W. Walker

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
    {{'4*x'; '-2*y'};
     {'-2*x'; '4*y'};
     {'2 - 6*y - 2*x'; '4*y'};
     {'4*x + 6*y - 4'; '-2*y'};
     {'-2*x'; '6*x + 4*y - 4'};
     {'4*x'; '2 - 2*y - 6*x'}};
% local mapping transformation to use
Elem.Basis.Transformation = 'Hdiv_Trans';
Elem.Degree = 1;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'facet average'; % not implemented
Elem.Nodal_Var.Basis =...
    {{'phi'}, [0, 1, 0];
     {'phi'}, [0, 0, 1];
     {'phi'}, [0, 0, 1];
     {'phi'}, [1, 0, 0];
     {'phi'}, [1, 0, 0];
     {'phi'}, [0, 1, 0]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[1, 2;
                     3, 4;
                     5, 6]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % NONE

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end