function [New_Vtx_Coord, New_Tri_List, New_Neighbor_List, New_Subdomain] =...
              Refine_Tri_Mesh_Rivara_Bisection(Vtx_Coord,Tri_List,Neighbor_List,Marked_Triangles,Subdomain)
%Refine_Tri_Mesh_Rivara_Bisection
%
%   This routine takes a given Triangle Mesh and refines a select few triangles
%   using Rivara LEPP bisection (for 2D triangulations only).
%
%   [New_Vtx_Coord, New_Tri_List, New_Neighbor_List, New_Subdomain] =
%            Refine_Tri_Mesh_Rivara_Bisection(Vtx_Coord,Tri_List,Neighbor_List,
%                                             Marked_Triangles,Subdomain)
%
%   Vtx_Coord = coordinates of mesh vertices.
%   Tri_List  = connectivity of triangles in mesh (indexes into Vtx_Coord).
%   Neighbor_List = neighbor data for triangle mesh.
%   Marked_Triangles = column vector of triangle (cell) indices into Tri_List.
%                      These triangles will be refined (bisected), and possibly
%                      others to maintain conformity.
%   Subdomain = array of Subdomain structs (see 'Create_Subdomain' in the
%               'AbstractMesh' class for their format).
%
%   New_Vtx_Coord     = same as 'Vtx_Coord' except for the refined mesh.
%   New_Tri_List      = same as 'Tri_List' except for the refined mesh.
%   New_Neighbor_List = same as 'Neighbor_List' except for the refined mesh.
%   New_Subdomain     = same as 'Subdomain' except for the refined mesh.

% Copyright (c) 02-18-2013,  Shawn W. Walker

Tri_List         = uint32(Tri_List);
Neighbor_List    = uint32(Neighbor_List);
Marked_Triangles = uint32(Marked_Triangles);

MESH = {Vtx_Coord, Tri_List};
[NEW_MESH, New_Neighbor_List, New_Subdomain] =...
           mexLEPP_Bisection_2D(MESH, Neighbor_List, Marked_Triangles, Subdomain);
%
New_Vtx_Coord = NEW_MESH{1};
New_Tri_List  = NEW_MESH{2};

end