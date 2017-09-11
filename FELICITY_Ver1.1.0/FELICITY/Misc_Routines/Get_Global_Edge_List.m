function Edges = Get_Global_Edge_List(Tri)
%Get_Global_Edge_List
%
%   This computes a unique global list of edges in the triangulation.

% Copyright (c) 12-01-2010,  Shawn W. Walker

% SWW: can use TriRep.edges instead!

% all triangle edge list (sorted in each individual row)
Edges = [sort(Tri(:,[2 3]),2);sort(Tri(:,[3 1]),2);sort(Tri(:,[1 2]),2)];
% remove duplicates and sort by rows
Edges = unique(Edges,'rows');

end