function Global_Triangles = Get_Subdomain_Tri_List(obj,Subdomain)
%Get_Subdomain_Tri_List
%
%   This extracts the Global Triangle list for a given 2-D subdomain.
%
%   Global_Triangles = obj.Get_Subdomain_Tri_List(Subdomain);
%
%   Subdomain = struct representing a subdomain (see 'Create_Subdomain' in
%               'AbstractMesh' for more info).
%
%   Global_Triangles = Mx3 matrix representing the 2-D subdomain (indexes into
%                      obj.Points).

% Copyright (c) 09-16-2011,  Shawn W. Walker

if (Subdomain.Dim~=2)
    error('Subdomain must be 2-D!');
end

% get the triangle data
Global_Triangles = obj.ConnectivityList(Subdomain.Data(:,1),:);

end