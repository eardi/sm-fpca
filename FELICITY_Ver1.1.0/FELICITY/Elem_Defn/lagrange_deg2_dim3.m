function Elem = lagrange_deg2_dim3()
%lagrange_deg2_dim3
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 08-14-2014,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func =...
    {{'(1 - x - y - z) * (2 * (1 - x - y - z) - 1)'};
     {'x * (2 * x - 1)'};
     {'y * (2 * y - 1)'};
     {'z * (2 * z - 1)'};
     {'4 * (1 - x - y - z) * x'};
     {'4 * (1 - x - y - z) * y'};
     {'4 * (1 - x - y - z) * z'};
     {'4 * x * y'};
     {'4 * y * z'};
     {'4 * z * x'}};
% local mapping transformation to use
Elem.Basis.Transformation = 'H1_Trans';
Elem.Degree = 2;

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1];
     {'phi'}, [(1/2), (1/2), 0, 0];
     {'phi'}, [(1/2), 0, (1/2), 0];
     {'phi'}, [(1/2), 0, 0, (1/2)];
     {'phi'}, [0, (1/2), (1/2), 0];
     {'phi'}, [0, 0, (1/2), (1/2)];
     {'phi'}, [0, (1/2), 0, (1/2)]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3; 4]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[5; 6; 7; 8; 9; 10]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % NONE

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % NONE

end