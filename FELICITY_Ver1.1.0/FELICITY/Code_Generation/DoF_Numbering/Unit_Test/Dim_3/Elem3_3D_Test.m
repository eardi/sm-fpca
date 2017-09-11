function Elem = Elem3_3D_Test()
%Elem3_3D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% name it!
Elem.Name = 'Elem3_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim    = 3;
Elem.Domain = 'tetrahedron';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis.Func =...
    {{'1 - x - y - z'};
     {'x'};
     {'y'};
     {'x'};
     {'y'};
     {'z'};
     {'1 - x - y - z'};
     {'x'};
     {'y'};
     {'x'};
     {'y'};
     {'z'};
     {'1 - x - y - z'};
     {'x'};
     {'y'};
     {'x'};
     {'y'};
     {'z'};
     {'1 - x - y - z'};
     {'x'};
     {'y'};
     {'x'};
     {'y'};
     {'z'};
     {'1 - x - y - z'}};
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1];
     {'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1];
     {'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1];
     {'phi'}, [1,0,0,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,1,0,0];
     {'phi'}, [0,0,1,0];
     {'phi'}, [0,0,0,1];
     {'phi'}, [0,0,0,1]};
%

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[]};

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[ 1  2  3  4  5  6;
                      7  8  9 10 11 12;
                     13 14 15 16 17 18;
                     19 20 21 22 23 24]};
%

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[25]}; %

end