function New_Subdomain = Refine_Subdomain_0D(Subdomain,Marked_Edges,New_Head_Edge_Indices)
%Refine_Subdomain_0D
%
%   This refines the given subdomain.  note: this is called by
%   'Refine_Edge_Mesh_1to2', so see it for more info.
%   Note: Marked_Edges is a list of cell indices.

% Copyright (c) 04-15-2011,  Shawn W. Walker

% NOTE:
% the first column of Subdomain.Data is the index of the cell that contains the
% subdomain (here just a vertex).
% the second column contains the local vertex index that is part
% of the subdomain.

% NOTE:
% also remember that all of the old vertex indices are still intact!  New
% vertices are added to the end.  This means that we just need to update which
% cell the subdomain vertex belongs to.

% find which (if any) of the cells that contain the subdomain were marked for
% refinement
[TF, LOC] = ismember(Subdomain.Data(:,1),Marked_Edges);

% if the vertex was the "tail" of the marked edge, then we can use the old cell
% index because the old marked edge is directly replaced (in the edge list) by
% the new "tail" piece of the bisection.  I.e. the edge index of the new "tail"
% piece of the bisection is the SAME as the index of the marked edge.

% get the part of the subdomain that was possibly effected by the bisection
Marked_Sub = Subdomain.Data(TF,:);

% find the subdomain vertices that are stored as the "head" vertex in the marked
% edge (because we only need to change those).
Head_Mask = (Marked_Sub(:,2) == 2);

% New_Head_Edge_Indices: is the list of edge indices for the new "head" edges
% that were appended to the total edge list.  This corresponds directly to the
% Marked_Edges list.
% so we need to get a sub list of New_Head_Edge_Indices that directly
% corresponds to Marked_Sub
New_Head_List = New_Head_Edge_Indices(LOC(TF));

% replace the old edge indices with the new "head" ones
New_Enclosing_Cell_Indices = New_Head_List(Head_Mask);
if ~isempty(New_Enclosing_Cell_Indices)
    Marked_Sub(Head_Mask,1) = New_Enclosing_Cell_Indices;
end

% create the new subdomain
New_Subdomain = Subdomain;
New_Subdomain.Data(TF,:) = Marked_Sub;

% NOTE: the new subdomain contains the same vertices it did before; just the
% enclosing cell that the vertex belongs to may be different.

% always sort the data (for refinement!)
New_Subdomain.Data = sortrows(New_Subdomain.Data,1);

end