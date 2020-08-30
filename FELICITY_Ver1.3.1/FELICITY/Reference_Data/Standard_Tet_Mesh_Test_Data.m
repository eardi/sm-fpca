function [Vtx, Tet] = Standard_Tet_Mesh_Test_Data()
%Standard_Tet_Mesh_Test_Data
%
%   This just outputs a standard test case for a 3-D triangulation.

% Copyright (c) 12-01-2010,  Shawn W. Walker

Vtx = [0 0 0;
       1 0 0;
       1 1 0;
       0 1 0;
       0.5 0.5 0;
       0.5 0.5 1];
%

Tet = [1     2     5     6;
       2     3     5     6;
       3     4     5     6;
       4     1     5     6];
%

% GE =
% 
%      1     2
%      1     4
%      1     5
%      1     6
%      2     3
%      2     5
%      2     6
%      3     4
%      3     5
%      3     6
%      4     5
%      4     6
%      5     6
% 

end