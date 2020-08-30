function [Edges, Tri_Edges, Tri_Edge_Flip] = Get_Edge_Info_From_Triangles(Tri)
%Get_Edge_Info_From_Triangles
%
%   This computes various info about the edges in a 2-D triangulation.
%
%   [Edges, Tri_Edges, Tri_Edge_Flip] = Get_Edge_Info_From_Triangles(Tri);
%
%   Tri = Mx3 matrix containing triangle connectivity data.
%
%   Edges         = Rx2 matrix of oriented mesh edges.
%   Tri_Edges     = Mx3 matrix that connects Tri with Edges. The (i,j) entry,
%                   where 1 <= i <= M, 1 <= j <= 3, stores an index that points
%                   into the rows of Edges, i.e. Edges(Tri_Edges(i,j),:)
%                   corresponds to local edge j of Tri(i,:).  Note: the
%                   orientation of the edges does not matter here.
%   Tri_Edge_Flip = (boolean) Mx3 matrix that indicates whether the orientation
%                   of local edge j of Tri(i,:) is flipped (opposite) to the
%                   orientation of Edges(Tri_Edges(i,j),:). false means it is
%                   NOT flipped, true means it is flipped.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% SWW: should probably move this to the FELICITY mesh classes.

error('do not use!');

% generate the edge lists that correspond to the new nodes
Edge1 = Tri(:,[2 3]);
Edge2 = Tri(:,[3 1]);
Edge3 = Tri(:,[1 2]);

% all triangle edge list
ALL_TRI_EDGE = [sort(Edge1,2);sort(Edge2,2);sort(Edge3,2)];
ALL_TRI_EDGE = unique(ALL_TRI_EDGE,'rows');

Edges = ALL_TRI_EDGE;

% SWW: need to separate the above code!

[TF1, LOC1] = ismember(Edge1,ALL_TRI_EDGE,'rows');
[TF2, LOC2] = ismember(Edge2,ALL_TRI_EDGE,'rows');
[TF3, LOC3] = ismember(Edge3,ALL_TRI_EDGE,'rows');

Tri_Edges = zeros(size(Tri,1),3);
Tri_Edges(TF1,1) = LOC1(TF1);
Tri_Edges(TF2,2) = LOC2(TF2);
Tri_Edges(TF3,3) = LOC3(TF3);

[TF1, LOC1] = ismember(Edge1(:,[2 1]),ALL_TRI_EDGE,'rows');
[TF2, LOC2] = ismember(Edge2(:,[2 1]),ALL_TRI_EDGE,'rows');
[TF3, LOC3] = ismember(Edge3(:,[2 1]),ALL_TRI_EDGE,'rows');

Tri_Edges(TF1,1) = LOC1(TF1);
Tri_Edges(TF2,2) = LOC2(TF2);
Tri_Edges(TF3,3) = LOC3(TF3);

Tri_Edge_Flip = false(size(Tri,1),3);
Tri_Edge_Flip(TF1,1) = true;
Tri_Edge_Flip(TF2,2) = true;
Tri_Edge_Flip(TF3,3) = true;

end