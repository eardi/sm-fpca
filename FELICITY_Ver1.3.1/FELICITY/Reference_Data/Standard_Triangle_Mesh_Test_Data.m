function [Vtx, Tri] = Standard_Triangle_Mesh_Test_Data()
%Standard_Triangle_Mesh_Test_Data
%
%   This just outputs a standard test case for a 2-D triangulation.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Vtx = [0 0;
       1 0;
       2 0;
       0.5 0.5;
       1.5 0.5;
       0 1;
       1 1;
       2 1;
       0.5 1.5;
       1.5 1.5;
       0 2;
       1 2;
       2 2];
%

Tri = [1 4 6;
       1 2 4;
       2 7 4;
       7 6 4;
       2 5 7;
       2 3 5;
       3 8 5;
       5 8 7;
       6 9 11;
       6 7 9;
       7 12 9;
       12 11 9;
       7 10 12;
       7 8 10;
       8 13 10
       10 13 12];
%

end