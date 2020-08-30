function Global_Tets = Get_Subdomain_Tet_List(obj,Subdomain)
%Get_Subdomain_Tet_List
%
%   This extracts the Global Tetrahedron list for a given 3-D subdomain.
%
%   Global_Tets = obj.Get_Subdomain_Tet_List(Subdomain);
%
%   Subdomain = struct representing a subdomain (see 'Create_Subdomain' in
%               'AbstractMesh' for more info).
%
%   Global_Tets = Mx4 matrix representing the 3-D subdomain (indexes into
%                  obj.Points).

% Copyright (c) 09-16-2011,  Shawn W. Walker

if (Subdomain.Dim~=3)
    error('Subdomain must be 3-D!');
end

% get the tet data
Global_Tets = obj.ConnectivityList(Subdomain.Data(:,1),:);

end