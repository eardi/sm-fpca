function Elem = Elem3_2D_Test()
%Elem3_2D_Test
%
%   This defines a finite element for testing the DoF allocation code.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% name it!
Elem.Name = 'Elem3_Test';

% continuous galerkin space
Elem.Type = 'CG';

% intrinsic dimension and domain
Elem.Dim = 2;
Elem.Domain = 'triangle';

% basis function definitions
% NOTE: these basis functions are NOT used in this test!
Elem.Basis.Func =...
    {{'x'};
     {'y'};
     {'1 - x - y'};
     {'x'};
     {'y'};
     {'1 - x - y'};
     {'x'};
     {'y'};
     {'1 - x - y'};
     {'y'};
     {'1 - x - y'};
     {'x'};
     {'y'};
     {'1 - x - y'};
     {'x'};
     {'y'};
     {'1 - x - y'};
     {'1 - x - y'}};
%

% nodal variables (dual basis)
% note: there can be more than one set of nodal variables (see above)
% barycentric coordinates (point evaluation)
Elem.Nodal_Var.Type  = 'point evaluation';
Elem.Nodal_Var.Basis =...
    {{'phi'}, [1,0,0];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1];
     {'phi'}, [1,0,0];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1];
     {'phi'}, [0,0,1];
     {'phi'}, [1,0,0];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1];
     {'phi'}, [1,0,0];
     {'phi'}, [0,1,0];
     {'phi'}, [0,0,1];
     {'phi'}, [0,0,1];
     {'phi'}, [1,0,0];
     {'phi'}, [0,1,0]};
%

% NOTE: this IS used.
%%%%% nodal (topological) arrangement

% nodes attached to vertices
Elem.Nodal_Top.V = {[1; 2; 3],...
                    [16; 17; 18]};
%

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[4, 7;
                     5, 8;
                     6, 9],...
                    [10, 13;
                     11, 14;
                     12, 15]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % cubic bubble

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end