function Elem = lagrange_deg2_dim1()
%lagrange_deg2_dim1
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 1;
Elem.Domain = 'interval';

% basis function definitions
Elem.Basis.Func =...
    {{'2 * (1 - x) * ((1/2) - x)'};
     {'2 * x * (x - (1/2))'};
     {'4 * x * (1 - x)'}};
% local mapping transformation to use
Elem.Basis.Transformation = 'H1_Trans';
Elem.Degree = 2;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0];
     {'phi'}, [0,1];
     {'phi'}, [0.5,0.5]};
%

% NOTE: this IS used.
%%%%% nodal (topological) arrangement

% nodes attached to vertices
Elem.Nodal_Top.V = {[1;
                     2]};
%

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[3]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % no triangle in 1-D

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 1-D

end