function [obj, Neighbor_List] = Refine(obj,Refine_Type,Marked_Triangles,Neighbor_List)
%Refine
%
%   This replaces the current mesh with a refined mesh.  Note: the subdomain
%   data is correctly maintained through refinement.  Note: if adaptive
%   bisection is used, other triangles may need to be refined to maintain
%   conformity.
%
%   [obj, Neighbor_List] =...
%         obj.Refine(Refine_Type,Marked_Triangles,Neighbor_List);
%
%   Refine_Type = (string) specifies type of refinement uniform '1to4' or
%                 adaptive Rivara 'bisection'.
%   Marked_Triangles = column vector of triangle (cell) indices into
%                      obj.ConnectivityList.  These triangles will be refined.
%                      This argument is optional, and if it is omitted, then
%                      *all* mesh triangles will be bisected.  This argument is
%                      only usable with bisection.
%   Neighbor_List = optional argument; same as 'obj.neighbors'.
%
%   Neighbor_List (output) = updated Neighbor_List for refined mesh.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if nargin < 2
    Refine_Type = '1to4'; % default to uniform refinement of all triangles
end
if and(nargin == 2,strcmp(Refine_Type,'bisection'))
    Marked_Triangles = (1:1:obj.Num_Cell)'; % select all triangles in the mesh
end
if nargin < 4
    Neighbor_List = obj.neighbors();
end

if strcmp(Refine_Type,'1to4')
    % perform one uniform mesh refinement
    [Vtx, Tri, Subdomain] = Refine_Tri_Mesh_1to4(obj.Points,obj.edges,obj.ConnectivityList,obj.Subdomain);
elseif strcmp(Refine_Type,'bisection')
    % perform one pass of selective Rivara bisection
    [Vtx, Tri, Neighbor_List, Subdomain] =...
               Refine_Tri_Mesh_Rivara_Bisection(obj.Points,obj.ConnectivityList,Neighbor_List,...
                                                Marked_Triangles,obj.Subdomain);
else
    error('Invalid refinement type!');
end

% you have to create a NEW object!
obj           = MeshTriangle(double(Tri),Vtx,obj.Name);
% store the subdomains
obj.Subdomain = Subdomain;

if and(strcmp(Refine_Type,'1to4'),nargout==2)
    % if they want the neighbor list,
    % then it should be the most up-to-date one
    Neighbor_List = obj.neighbors();
end

end