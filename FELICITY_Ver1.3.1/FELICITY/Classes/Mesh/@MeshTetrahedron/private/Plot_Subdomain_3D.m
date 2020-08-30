function Plot_Handle = Plot_Subdomain_3D(obj,Subdomain)
%Plot_Subdomain_3D
%
%   This plots a 3D sub-domain of the global mesh.
%
%   Plot_Handle = obj.Plot_Subdomain_3D(Subdomain);
%
%   Subdomain = (struct) subdomain of the global mesh.  See 'Create_Subdomain'
%               in the 'AbstractMesh' class for more info on this struct.

% Copyright (c) 04-15-2011,  Shawn W. Walker

Color_RGB = [1 0 0];
MarkerSize = 10;
LineWidth = 1.5;
Mesh_Edge_Color = 'k';
FaceNormal_Scale = 0.5;

Plot_Handle = tetramesh(obj.ConnectivityList(Subdomain.Data(:,1),:),obj.Points);

% Plot_Handle = patch('Faces',Global_Tri,'Vertices',obj.Points,'FaceColor',Color_RGB);
% if (obj.Geo_Dim==3)
%     % plot oriented normals! (only in 3-D)
%     Pt = obj.incenters;
%     fnormal = obj.faceNormals;
%     quiver3(Pt(:,1),Pt(:,2),Pt(:,3),fnormal(:,1),fnormal(:,2),fnormal(:,3),FaceNormal_Scale,'color',Mesh_Edge_Color);
% end
set(Plot_Handle,'edgecolor',Mesh_Edge_Color,'LineWidth',LineWidth); % make mesh edges black
title(Subdomain.Name);

end