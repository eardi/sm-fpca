function Plot_Handle = Plot_Subdomain_1D(obj,Subdomain)
%Plot_Subdomain_1D
%
%   This plots a 1D sub-domain of the global mesh.
%
%   Plot_Handle = obj.Plot_Subdomain_1D(Subdomain);
%
%   Subdomain = (struct) subdomain of the global mesh.  See 'Create_Subdomain'
%               in the 'AbstractMesh' class for more info on this struct.

% Copyright (c) 04-15-2011,  Shawn W. Walker

Color_RGB = [0 0 0];
MarkerSize = 10;
LineWidth = 1.5;

GE = Get_Subdomain_Edge_List(obj,Subdomain);

% plot each segment as a vector
VEC = obj.X(GE(:,2),:) - obj.X(GE(:,1),:);
scale = 0;
Plot_Handle = quiver3(obj.X(GE(:,1),1),obj.X(GE(:,1),2),obj.X(GE(:,1),3),...
                      VEC(:,1),VEC(:,2),VEC(:,3),scale,'Color',Color_RGB,...
                      'MarkerSize',MarkerSize,'LineWidth',LineWidth);
title(Subdomain.Name);

end