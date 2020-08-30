function Plot_Handle = Plot_Subdomain_1D(obj,Subdomain)
%Plot_Subdomain_1D
%
%   This plots a 1D sub-domain of the global mesh.
%
%   Plot_Handle = obj.Plot_Subdomain_1D(Subdomain);
%
%   Subdomain = (struct) subdomain of the global mesh.  See 'Create_Subdomain'
%               in the 'AbstractMesh' class for more info on this struct.

% Copyright (c) 02-14-2013,  Shawn W. Walker

if isempty(Subdomain)
    Edge_Ind = (1:1:obj.Num_Cell)';
    Subdomain_Name = obj.Name;
else
    Edge_Ind = Subdomain.Data;
    Subdomain_Name = Subdomain.Name;
end

LineWidth = 1.5;
Color_RGB = [0 0 0];

% plot each segment as a vector
VEC = obj.Points(obj.ConnectivityList(Edge_Ind,2),:) - obj.Points(obj.ConnectivityList(Edge_Ind,1),:);
scale = 0;
GD = obj.Geo_Dim;
hold on;
if (GD==3)
    Plot_Handle = quiver3(obj.Points(obj.ConnectivityList(Edge_Ind,1),1),obj.Points(obj.ConnectivityList(Edge_Ind,1),2),...
                          obj.Points(obj.ConnectivityList(Edge_Ind,1),3),...
                          VEC(:,1),VEC(:,2),VEC(:,3),scale,'Color',Color_RGB,...
                          'LineWidth',LineWidth);
elseif (GD==2)
    Plot_Handle = quiver(obj.Points(obj.ConnectivityList(Edge_Ind,1),1),obj.Points(obj.ConnectivityList(Edge_Ind,1),2),...
                         VEC(:,1),VEC(:,2),scale,'Color',Color_RGB,'LineWidth',LineWidth);
else
    Plot_Handle = quiver(obj.Points(obj.ConnectivityList(Edge_Ind,1),1),0*obj.Points(obj.ConnectivityList(Edge_Ind,1),1),...
                         VEC(:,1),0*VEC(:,1),scale,'Color',Color_RGB,...
                         'LineWidth',LineWidth,'ShowArrowHead','off');
end
axis equal;
title(Subdomain_Name);
hold off;

end