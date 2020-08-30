function Global_Edges = Get_Subdomain_Edge_List(obj,Subdomain)
%Get_Subdomain_Edge_List
%
%   This extracts the Global Edge list for a given 1-D subdomain.
%
%   Global_Edges = obj.Get_Subdomain_Edge_List(Subdomain);
%
%   Subdomain = struct representing a subdomain (see 'Create_Subdomain' in
%               'AbstractMesh' for more info).
%
%   Global_Edges = Mx2 matrix representing the 1-D subdomain (indexes into
%                  obj.Points).

% Copyright (c) 09-16-2011,  Shawn W. Walker

if (Subdomain.Dim~=1)
    error('Subdomain must be 1-D!');
end

P_Mask1 = (Subdomain.Data(:,2) == 1);
P_Mask2 = (Subdomain.Data(:,2) == 2);
P_Mask3 = (Subdomain.Data(:,2) == 3);
N_Mask1 = (Subdomain.Data(:,2) == -1);
N_Mask2 = (Subdomain.Data(:,2) == -2);
N_Mask3 = (Subdomain.Data(:,2) == -3);

% get the (oriented) edge data
Global_Edges = zeros(size(Subdomain.Data,1),2);
Global_Edges(P_Mask1,:) = obj.ConnectivityList(Subdomain.Data(P_Mask1,1),[2 3]);
Global_Edges(P_Mask2,:) = obj.ConnectivityList(Subdomain.Data(P_Mask2,1),[3 1]);
Global_Edges(P_Mask3,:) = obj.ConnectivityList(Subdomain.Data(P_Mask3,1),[1 2]);
Global_Edges(N_Mask1,:) = obj.ConnectivityList(Subdomain.Data(N_Mask1,1),[3 2]);
Global_Edges(N_Mask2,:) = obj.ConnectivityList(Subdomain.Data(N_Mask2,1),[1 3]);
Global_Edges(N_Mask3,:) = obj.ConnectivityList(Subdomain.Data(N_Mask3,1),[2 1]);

end