function [Tri_Edges, Tri_Edge_Flip] = Get_Triangle_Edge_Info(Tri,Edges)
%Get_Triangle_Edge_Info
%
%   This computes edge numbering and orientation for a given triangulation
%   and set of edges.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% SWW: is this still used?  can this be moved to the FELICITY mesh classes? or
% combined with other file:  'Get_Edge_Info_From_Triangles'?

error('do NOT use!');

% identify where each triangle edge belongs in the global edge list
[TF1, LOC1] = ismember(Tri(:,[2 3]),Edges,'rows');
[TF2, LOC2] = ismember(Tri(:,[3 1]),Edges,'rows');
[TF3, LOC3] = ismember(Tri(:,[1 2]),Edges,'rows');

Tri_Edges = zeros(size(Tri,1),3);
Tri_Edges(TF1,1) = LOC1(TF1);
Tri_Edges(TF2,2) = LOC2(TF2);
Tri_Edges(TF3,3) = LOC3(TF3);

% check the opposite orientation
[TF1, LOC1] = ismember(Tri(:,[3 2]),Edges,'rows');
[TF2, LOC2] = ismember(Tri(:,[1 3]),Edges,'rows');
[TF3, LOC3] = ismember(Tri(:,[2 1]),Edges,'rows');

Tri_Edges(TF1,1) = LOC1(TF1);
Tri_Edges(TF2,2) = LOC2(TF2);
Tri_Edges(TF3,3) = LOC3(TF3);

% record that these triangle edges have opposite orientation to what is in
% the global edge list
Tri_Edge_Flip = false(size(Tri,1),3);
Tri_Edge_Flip(TF1,1) = true;
Tri_Edge_Flip(TF2,2) = true;
Tri_Edge_Flip(TF3,3) = true;

end