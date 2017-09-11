function [Vtx, Edge] = Standard_Edge_Mesh_Test_Data()
%Standard_Edge_Mesh_Test_Data
%
%   This just outputs a standard test case for a 1-D triangulation.  Note:
%   they are not in order.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Vtx = [0;
       2;
       4;
       8;
       1;
       3;
       5;
       6;
       7;
       9];
%

Edge = [1  5;
        5  2;
        2  6;
        6  3;
        3  7;
        7  8;
        8  9;
        9  4;
        4 10];
%

end