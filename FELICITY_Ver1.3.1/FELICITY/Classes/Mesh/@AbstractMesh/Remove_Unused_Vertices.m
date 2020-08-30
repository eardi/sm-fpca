function obj = Remove_Unused_Vertices(obj)
%Remove_Unused_Vertices
%
%   This removes any unused vertices from the triangulation, and renumbers the
%   remaining vertices accordingly.  Of course, the Triangulation data is also
%   updated.
%
%   obj = obj.Remove_Unused_Vertices;

% Copyright (c) 09-12-2012,  Shawn W. Walker

Actual_Vertices_Referenced = unique(obj.ConnectivityList(:));

[G2L, L2G] = Create_Global_Local_Index_Mapping(Actual_Vertices_Referenced,max(Actual_Vertices_Referenced));

New_Tri = obj.ConnectivityList; % init
New_Tri(:) = G2L(New_Tri(:)); % reorder
New_Vtx = obj.Points(L2G,:); % only keep the vertices that are used

MeshClass = str2func(class(obj)); % get the mesh type
New_Mesh = MeshClass(New_Tri, New_Vtx, obj.Name);

% copy over the subdomain data (it has *not* changed!)
New_Mesh.Subdomain = obj.Subdomain;

obj = New_Mesh; % overwrite

end