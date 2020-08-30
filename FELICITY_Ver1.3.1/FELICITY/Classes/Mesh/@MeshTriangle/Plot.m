function Plot_Handle = Plot(obj)
%Plot
%
%   This plots the whole triangle mesh.
%
%   Plot_Handle = obj.Plot;

% Copyright (c) 08-19-2009,  Shawn W. Walker

hold on;
GD = obj.Geo_Dim;
if (GD==3)
    Plot_Handle = trimesh(obj.ConnectivityList,obj.Points(:,1),obj.Points(:,2),obj.Points(:,3));
    view(3);
else
    Plot_Handle = trimesh(obj.ConnectivityList,obj.Points(:,1),obj.Points(:,2),0*obj.Points(:,2));
    view(2);
end
shading interp;
set(Plot_Handle,'edgecolor','k'); % make mesh black
axis equal;
title(obj.Name);
hold off;

end