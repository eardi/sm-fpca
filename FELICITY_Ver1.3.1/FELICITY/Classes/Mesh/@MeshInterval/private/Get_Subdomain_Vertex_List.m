function Global_Vertices = Get_Subdomain_Vertex_List(obj,Subdomain)
%Get_Subdomain_Vertex_List
%
%   This extracts the Global Vertex list for a given 0-D subdomain.
%
%   Global_Vertices = obj.Get_Subdomain_Vertex_List(Subdomain);
%
%   Subdomain = struct representing a subdomain (see 'Create_Subdomain' in
%               'AbstractMesh' for more info).
%
%   Global_Vertices = column vector representing the 0-D subdomain (indexes into
%                     obj.Points).

% Copyright (c) 09-16-2011,  Shawn W. Walker

if (Subdomain.Dim~=0)
    error('Subdomain must be 0-D!');
end

Mask1 = (Subdomain.Data(:,2) == 1);
Mask2 = (Subdomain.Data(:,2) == 2);

% get the vertex data
Global_Vertices = zeros(size(Subdomain.Data,1),1);
Global_Vertices(Mask1,:) = obj.ConnectivityList(Subdomain.Data(Mask1,1),1);
Global_Vertices(Mask2,:) = obj.ConnectivityList(Subdomain.Data(Mask2,1),2);

end