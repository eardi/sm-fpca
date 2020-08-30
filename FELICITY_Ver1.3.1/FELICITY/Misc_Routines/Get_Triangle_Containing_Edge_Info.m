function [Codim_Data_Pos, Codim_Data_Neg] = Get_Triangle_Containing_Edge_Info(Tri,Edges)
%Get_Triangle_Containing_Edge_Info
%
%   From a given set of mesh edges, this finds the triangles that contain that
%   edge and the local edge entity index corresponding to that edge.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% SWW: is this still used?  can this be moved to the FELICITY mesh classes?

Codim_Data_Pos = zeros(size(Edges,1),2);
Codim_Data_Neg = zeros(size(Edges,1),2);

% POSITIVE orientation: find the triangle (local edge) that corresponds to the given edge
[TF1, LOC1] = ismember(Edges,Tri(:,[2 3]),'rows');
[TF2, LOC2] = ismember(Edges,Tri(:,[3 1]),'rows');
[TF3, LOC3] = ismember(Edges,Tri(:,[1 2]),'rows');

Codim_Data_Pos(TF1,1) = LOC1(TF1);
Codim_Data_Pos(TF1,2) = 1;
Codim_Data_Pos(TF2,1) = LOC2(TF2);
Codim_Data_Pos(TF2,2) = 2;
Codim_Data_Pos(TF3,1) = LOC3(TF3);
Codim_Data_Pos(TF3,2) = 3;

% NEGATIVE orientation: find the triangle (local edge) that corresponds to the given edge
[TF1, LOC1] = ismember(Edges,Tri(:,[3 2]),'rows');
[TF2, LOC2] = ismember(Edges,Tri(:,[1 3]),'rows');
[TF3, LOC3] = ismember(Edges,Tri(:,[2 1]),'rows');

Codim_Data_Neg(TF1,1) = LOC1(TF1);
Codim_Data_Neg(TF1,2) = -1;
Codim_Data_Neg(TF2,1) = LOC2(TF2);
Codim_Data_Neg(TF2,2) = -2;
Codim_Data_Neg(TF3,1) = LOC3(TF3);
Codim_Data_Neg(TF3,2) = -3;

end