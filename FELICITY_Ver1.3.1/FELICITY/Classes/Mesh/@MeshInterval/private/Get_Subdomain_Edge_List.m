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

% get the edge data
Global_Edges = obj.ConnectivityList(Subdomain.Data(:,1),:);

end