function [Sk_Plus, Sk_Minus] = Get_Skeleton(obj)
%Get_Skeleton
%
%   This extracts the mesh "skeleton" data for a 2-D mesh, i.e. how *all*
%   the edges are embedded in the mesh.  Moreover, we separate the +/-
%   sides of each edge.  This is useful for computing "jump" terms.
%
%   [Sk_Plus, Sk_Minus] = obj.Get_Skeleton();
%
%   Sk_Plus, Sk_Minus:
%          Mx2 matrices, where M is the total number of edges in the mesh.
%          First column are triangle indices that refer to triangles in the
%          global mesh that contain the edges. Second column are local edge
%          indices (1, 2, or 3) within the triangle that
%          represent an edge in the global mesh.  Each row of each matrix
%          cooresponds to a unique edge in the global mesh.

% Copyright (c) 03-29-2018,  Shawn W. Walker

% setup unique list of oriented edges
Tri_Data = obj.ConnectivityList;
Oriented_Edges = obj.edges;
FB = obj.freeBoundary;
if isempty(FB)
    Oriented_Edges_without_FB = sort(Oriented_Edges,2);
else
    Oriented_Edges_without_FB = setdiff(sort(Oriented_Edges,2),sort(FB,2),'rows');
end
Oriented_Edges = [Oriented_Edges_without_FB; FB]; % put back so they have positive orientation

% get list of triangle index numbers
Tri_Indices = (1:1:size(Tri_Data,1))';

% get list of edges
Edge1 = [Tri_Data(:,[2 3]), Tri_Indices, 1*ones(size(Tri_Indices,1),1)];
Edge2 = [Tri_Data(:,[3 1]), Tri_Indices, 2*ones(size(Tri_Indices,1),1)];
Edge3 = [Tri_Data(:,[1 2]), Tri_Indices, 3*ones(size(Tri_Indices,1),1)];

% POSITIVE orientation: find the (local) edge that corresponds to the given edge
[P_Mask1, P_LOC_1] = ismember(Oriented_Edges,Edge1(:,[1 2]),'rows');
[P_Mask2, P_LOC_2] = ismember(Oriented_Edges,Edge2(:,[1 2]),'rows');
[P_Mask3, P_LOC_3] = ismember(Oriented_Edges,Edge3(:,[1 2]),'rows');

Sk_Plus = [Edge1(P_LOC_1(P_Mask1,1),3:4);
           Edge2(P_LOC_2(P_Mask2,1),3:4);
           Edge3(P_LOC_3(P_Mask3,1),3:4)];
%

if (size(Sk_Plus,1)~=size(Oriented_Edges,1))
    error('This should NOT happen!');
end

% NEGATIVE orientation: find the (local) edge that corresponds to the given edge
[N_Mask1, N_LOC_1] = ismember(Oriented_Edges_without_FB(:,[2 1]),Edge1(:,[1 2]),'rows');
[N_Mask2, N_LOC_2] = ismember(Oriented_Edges_without_FB(:,[2 1]),Edge2(:,[1 2]),'rows');
[N_Mask3, N_LOC_3] = ismember(Oriented_Edges_without_FB(:,[2 1]),Edge3(:,[1 2]),'rows');

% Note: keep the orientation positive, because we want to compute jumps!
Sk_Minus = [Edge1(N_LOC_1(N_Mask1,1),3:4);
            Edge2(N_LOC_2(N_Mask2,1),3:4);
            Edge3(N_LOC_3(N_Mask3,1),3:4)];
%

if (size(Sk_Minus,1)~=size(Oriented_Edges_without_FB,1))
    error('This should NOT happen!');
end

end