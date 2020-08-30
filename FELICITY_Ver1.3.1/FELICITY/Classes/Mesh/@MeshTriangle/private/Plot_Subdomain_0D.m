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
IND = sub2ind(size(obj.ConnectivityList),Subdomain.Data(:,1),Subdomain.Data(:,2));
Vtx_Indices = obj.ConnectivityList(IND);

if (obj.Geo_Dim==3)
    Plot_Handle = plot3(obj.Points(Vtx_Indices,1),obj.Points(Vtx_Indices,2),obj.Points(Vtx_Indices,3),Color_str,'MarkerSize',myMarkerSize);
else
    Plot_Handle = plot(obj.Points(Vtx_Indices,1),obj.Points(Vtx_Indices,2),Color_str,'MarkerSize',myMarkerSize);
end
title(Subdomain.Name);

end