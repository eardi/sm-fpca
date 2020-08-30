function Global_Faces = Get_Subdomain_Face_List(obj,Subdomain)
%Get_Subdomain_Face_List
%
%   This extracts the Global Face list for a given 2-D subdomain.
%
%   Global_Faces = obj.Get_Subdomain_Face_List(Subdomain);
%
%   Subdomain = struct representing a subdomain (see 'Create_Subdomain' in
%               'AbstractMesh' for more info).
%
%   Global_Faces = Mx3 matrix representing the 2-D subdomain (indexes into
%                  obj.Points).

% Copyright (c) 04-15-2011,  Shawn W. Walker

if (Subdomain.Dim~=2)
    error('Subdomain must be 2-D!');
end

P_Mask1 = (Subdomain.Data(:,2) == 1);
P_Mask2 = (Subdomain.Data(:,2) == 2);
P_Mask3 = (Subdomain.Data(:,2) == 3);
P_Mask4 = (Subdomain.Data(:,2) == 4);

N_Mask1 = (Subdomain.Data(:,2) == -1);
N_Mask2 = (Subdomain.Data(:,2) == -2);
N_Mask3 = (Subdomain.Data(:,2) == -3);
N_Mask4 = (Subdomain.Data(:,2) == -4);

% get the (oriented) face data
Global_Faces = zeros(size(Subdomain.Data,1),3);
Global_Faces(P_Mask1,:) = obj.ConnectivityList(Subdomain.Data(P_Mask1,1),[2 3 4]);
Global_Faces(P_Mask2,:) = obj.ConnectivityList(Subdomain.Data(P_Mask2,1),[1 4 3]);
Global_Faces(P_Mask3,:) = obj.ConnectivityList(Subdomain.Data(P_Mask3,1),[1 2 4]);
Global_Faces(P_Mask4,:) = obj.ConnectivityList(Subdomain.Data(P_Mask4,1),[1 3 2]);

Global_Faces(N_Mask1,:) = obj.ConnectivityList(Subdomain.Data(N_Mask1,1),[2 4 3]);
Global_Faces(N_Mask2,:) = obj.ConnectivityList(Subdomain.Data(N_Mask2,1),[1 3 4]);
Global_Faces(N_Mask3,:) = obj.ConnectivityList(Subdomain.Data(N_Mask3,1),[1 4 2]);
Global_Faces(N_Mask4,:) = obj.ConnectivityList(Subdomain.Data(N_Mask4,1),[1 2 3]);

end