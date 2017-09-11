function Plot_Handle = Plot_Subdomain_0D(obj,Subdomain)
%Plot_Subdomain_0D
%
%   This plots a 0D sub-domain of the global mesh.
%
%   Plot_Handle = obj.Plot_Subdomain_0D(Subdomain);
%
%   Subdomain = (struct) subdomain of the global mesh.  See 'Create_Subdomain'
%               in the 'AbstractMesh' class for more info on this struct.

% Copyright (c) 04-15-2011,  Shawn W. Walker

Color_str = 'b.';
myMarkerSize = 14;

% get global vertex indices
IND = sub2ind(size(obj.Triangulation),Subdomain.Data(:,1),Subdomain.Data(:,2));
Vtx_Indices = obj.Triangulation(IND);

Plot_Handle = plot3(obj.X(Vtx_Indices,1),obj.X(Vtx_Indices,2),obj.X(Vtx_Indices,3),Color_str,'MarkerSize',myMarkerSize);
title(Subdomain.Name);

end