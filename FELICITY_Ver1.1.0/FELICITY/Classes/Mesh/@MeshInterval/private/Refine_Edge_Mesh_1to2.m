function [New_Vtx_Coord, New_Edge_List, New_Subdomain] =...
                         Refine_Edge_Mesh_1to2(Vtx_Coord,Edge_List,Subdomain,Marked_Edges)
%Refine_Edge_Mesh_1to2
%
%   This routine takes a given Interval Mesh and refines marked edges using
%   1-to-2 refinement (for 1D triangulations only).
%
%   [New_Vtx_Coord, New_Edge_List, New_Subdomain] =...
%            Refine_Edge_Mesh_1to2(Vtx_Coord,Edge_List,Subdomain,Marked_Edges);
%
%   Vtx_Coord = coordinates of mesh vertices.
%   Edge_List = connectivity of edges in mesh (indexes into Vtx_Coord).
%   Subdomain = array of Subdomain structs (see 'Create_Subdomain' in the
%               'AbstractMesh' class for their format).
%   Marked_Edges = column vector of edge (cell) indices into Edge_List.
%                  These edges will be refined (bisected).
%
%   New_Vtx_Coord = same as 'Vtx_Coord' except for the refined mesh.
%   New_Edge_List = same as 'Edge_List' except for the refined mesh.
%   New_Subdomain = same as 'Subdomain' except for the refined mesh.

% Copyright (c) 02-14-2013,  Shawn W. Walker

% first compute the locations of the new vertices (these are additional)
Num_Old_Vtx = size(Vtx_Coord,1);
New_Vtx = 0.5 * ( Vtx_Coord(Edge_List(Marked_Edges,1),:) + Vtx_Coord(Edge_List(Marked_Edges,2),:) );
New_Vtx_Ind = (1:1:size(New_Vtx,1))' + Num_Old_Vtx;
% note that the new vertices correspond directly to the OLD (marked) edge list
New_Vtx_Coord = [Vtx_Coord; New_Vtx];

% generate new edges (each corresponds to OLD edge list that is marked)
New_Edge1 = [Edge_List(Marked_Edges,1), New_Vtx_Ind];
New_Edge2 = [New_Vtx_Ind, Edge_List(Marked_Edges,2)];

% generate new edge list:
%
% so each marked edge gets bisected into two pieces; a "tail" piece and a "head"
% piece (i.e. the "tail" piece has the same "tail" vertex as the father edge,
% and likewise with the "head" piece).  Then, we replace all of the marked edges
% by the "tail" part of the bisection.  Then, we append to the end of the list
% all of the new "head" pieces.
New_Edge_List = [Edge_List; New_Edge2]; % init and append "head" edges
New_Edge_List(Marked_Edges,:) = New_Edge1; % replace by "tail" edges

% create the edge index list for all of the new "head" edges; corresponds
% directly to the Marked_Edges list
Num_Old_Edges = size(Edge_List,1);
New_Head_Edge_Indices = (1:1:length(Marked_Edges))' + Num_Old_Edges;

% don't forget to refine subdomains
if ~isempty(Subdomain)
    New_Subdomain = Subdomain(1); % just init
    for ind = 1:length(Subdomain)
        if (Subdomain(ind).Dim==0)
            New_Subdomain(ind) = Refine_Subdomain_0D(Subdomain(ind),Marked_Edges,New_Head_Edge_Indices);
        elseif (Subdomain(ind).Dim==1)
            New_Subdomain(ind) = Refine_Subdomain_1D(Subdomain(ind),Marked_Edges,New_Head_Edge_Indices);
        end
    end
else
    New_Subdomain = [];
end

end