function Plot_Handle = Plot_Subdomain_2D(obj,Subdomain)
%Plot_Subdomain_2D
%
%   This plots a 2D sub-domain of the global mesh.
%
%   Plot_Handle = obj.Plot_Subdomain_2D(Subdomain);
%
%   Subdomain = (struct) subdomain of the global mesh.  See 'Create_Subdomain'
%               in the 'AbstractMesh' class for more info on this struct.

% Copyright (c) 04-15-2011,  Shawn W. Walker

Color_RGB = [1 0 0]; % red
%MarkerSize = 10;
LineWidth = 1.5;
Mesh_Edge_Color = 'k';
FaceNormal_Scale = 0.5;

GF = Get_Subdomain_Face_List(obj,Subdomain);

% plot the faces
Plot_Handle = patch('Faces',GF,'Vertices',obj.Points,'FaceColor',Color_RGB);

% plot oriented normals
warning('off', 'MATLAB:TriRep:PtsNotInTriWarnId'); % temporarily turn this off
tr = triangulation(GF,obj.Points);
warning('on', 'MATLAB:TriRep:PtsNotInTriWarnId');
Pt = tr.incenter;
fnormal = tr.faceNormal;
PLOT_WAS_HELD = ishold;
if ~PLOT_WAS_HELD
    hold on;
end
quiver3(Pt(:,1),Pt(:,2),Pt(:,3),fnormal(:,1),fnormal(:,2),fnormal(:,3),FaceNormal_Scale,'color',Mesh_Edge_Color);
if ~PLOT_WAS_HELD
    hold off;
end

set(Plot_Handle,'edgecolor',Mesh_Edge_Color,'LineWidth',LineWidth); % make mesh edges black
title(Subdomain.Name);
axis equal;

end