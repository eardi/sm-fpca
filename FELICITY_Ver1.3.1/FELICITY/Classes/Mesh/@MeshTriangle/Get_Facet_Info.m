function [Tri_Edge, Tri_Edge_Orient] = Get_Facet_Info(obj,Edges)
%Get_Facet_Info
%
%   Given a global "facet" list (just edges in a TriangleMesh), this outputs a
%   data structure that indicates which global facets (edges) are attached to
%   each triangle in the mesh, as well as the orientation of the local facets
%   (edges) with respect to the global list.
%
%   [Tri_Edge, Tri_Edge_Orient] = obj.Get_Facet_Info(Edges);
%
%   Edges = Rx2 matrix of oriented mesh edges.
%
%   Tri_Edge = Mx3 matrix that connects obj.ConnectivityList with Edges. The (i,j)
%              entry, where 1 <= i <= M, 1 <= j <= 3, stores an index that
%              points into the rows of Edges, i.e. Edges(Tri_Edge(i,j),:) is the
%              *global* edge representation of local edge j of triangle i:
%              obj.ConnectivityList(i,:).
%              Note: M = obj.Num_Cell (number of tri's in obj.ConnectivityList).
%              Note: the orientation of Edges is ignored here.
%              Note: if Tri_Edge(i,j)==0, then local edge j of triangle i is
%              NOT in Edges (in either orientation).
%   Tri_Edge_Orient = (boolean) Mx3 matrix indicates whether the orientation of
%                     local edge j of triangle i is opposite to the orientation
%                     of Edges(Tri_Edge(i,j),:).
%                     true means:
%                     local edge j of triangle i = Edges(Tri_Edge(i,j),[1 2])
%                     false means:
%                     local edge j of triangle i = Edges(Tri_Edge(i,j),[2 1])
%
%   Example:
%            Vtx = [0 0; 1 0; 1 1; 0 1; 0.5 0.5]; % coordinates
%            Tri = [1 2 5; 2 3 5; 3 4 5; 4 1 5];  % triangle connectivity
%            obj = MeshTriangle(Tri,Vtx,'Square');
%            Edges = obj.edges;
%            [Tri_Edge, Tri_Edge_Orient] = obj.Get_Facet_Info(Edges);

% Copyright (c) 05-20-2013,  Shawn W. Walker

if (size(Edges,2)~=2)
    error('Input facet list for a triangle mesh must have 2 columns (because they are edges).');
end

% find local edges with global orientation
[TF1, LOC1] = ismember(obj.ConnectivityList(:,[2 3]),Edges,'rows'); % local facet (edge) 1
[TF2, LOC2] = ismember(obj.ConnectivityList(:,[3 1]),Edges,'rows'); % local facet (edge) 2
[TF3, LOC3] = ismember(obj.ConnectivityList(:,[1 2]),Edges,'rows'); % local facet (edge) 3

Tri_Edge = zeros(obj.Num_Cell,3);
Tri_Edge(TF1,1) = LOC1(TF1);
Tri_Edge(TF2,2) = LOC2(TF2);
Tri_Edge(TF3,3) = LOC3(TF3);

% find local edges with opposite global orientation
[TF1, LOC1] = ismember(obj.ConnectivityList(:,[3 2]),Edges,'rows'); % local facet (edge) 1 (reverse orientation)
[TF2, LOC2] = ismember(obj.ConnectivityList(:,[1 3]),Edges,'rows'); % local facet (edge) 2 (reverse orientation)
[TF3, LOC3] = ismember(obj.ConnectivityList(:,[2 1]),Edges,'rows'); % local facet (edge) 3 (reverse orientation)

Tri_Edge(TF1,1) = LOC1(TF1);
Tri_Edge(TF2,2) = LOC2(TF2);
Tri_Edge(TF3,3) = LOC3(TF3);

% record which edges have orientation opposite to the given global list
Tri_Edge_Orient = true(obj.Num_Cell,3);
Tri_Edge_Orient(TF1,1) = false;
Tri_Edge_Orient(TF2,2) = false;
Tri_Edge_Orient(TF3,3) = false;

end