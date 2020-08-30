function obj = Refine(obj,Refine_Type)
%Refine
%
%    This replaces the current mesh with a refined mesh.
%
%    NOT IMPLEMENTED!

% Copyright (c) 04-13-2011,  Shawn W. Walker

error('not implemented!');

if nargin < 2
    Refine_Type = '1to4';
end

if strcmp(Refine_Type,'1to4')
    % perform one uniform mesh refinement
    [Vtx, Tri, Subdomain] = Refine_Tri_Mesh_1to4(obj.Points,obj.edges,obj.ConnectivityList,obj.Subdomain);
elseif strcmp(Refine_Type,'bisection')
    error('Not implemented!');
    %         % refine by bisection
    %         Marked_Triangles = (1:1:size(Mesh_Tri,1))';
    %         [Vtx_Coord, Mesh_Tri, Bdy_Seg]=...
    %             Nochettos_bisection(Vtx_Coord,Mesh_Tri,Bdy_Seg,Bdy_Seg,Marked_Triangles);
else
    error('Invalid refinement type!');
end

% you have to create a NEW object!
obj           = MeshTriangle(Tri,Vtx,obj.Name);
% store the subdomains
obj.Subdomain = Subdomain;

end