function New_Subdomain = Refine_Subdomain_1D(Subdomain,Marked_Edges,New_Head_Edge_Indices)
%Refine_Subdomain_1D
%
%   This refines the given subdomain.  note: this is called by
%   'Refine_Edge_Mesh_1to2', so see it for more info.

% Copyright (c) 04-15-2011,  Shawn W. Walker

% NOTE:
% the ONLY column of Subdomain.Data is the index of the cell that IS part of the
% subdomain (here just an edge).

% NOTE:
% also remember that all of the edge indices that were NOT marked for bisection
% are still intact!

% find which (if any) of the subdomain cells (edges) were marked for refinement
[TF, LOC] = ismember(Subdomain.Data(:,1),Marked_Edges);

% if an edge in the subdomain was marked for bisection, then the two children of
% the bisection ("tail" and "head") will be part of the new subdomain.

% recall that the "tail" pieces have the same global edge indices as the
% original marked edges.
% so we just need to add the global edge indices of the "head" pieces of marked
% edges that were part of the subdomain.

% % % get the part of the subdomain that was possibly effected by the bisection
% % Marked_Sub = Subdomain.Data(TF,:);

% New_Head_Edge_Indices: is the list of edge indices for the new "head" edges
% that were appended to the total edge list.  This corresponds directly to the
% Marked_Edges list.
% so we need to get a sub list of New_Head_Edge_Indices that directly
% corresponds to Marked_Sub
New_Head_List = New_Head_Edge_Indices(LOC(TF));

% create the new subdomain
New_Subdomain = Subdomain;
% append the new "head" edge indices
New_Subdomain.Data = [New_Subdomain.Data; New_Head_List];

% good to sort the data
New_Subdomain.Data = sortrows(New_Subdomain.Data,1);

end