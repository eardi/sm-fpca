function obj = Order_Cell_Vertices_For_Hcurl(obj)
%Order_Cell_Vertices_For_Hcurl
%
%   This reorders the vertices of each tetrahedron, i.e.,
%       Let [V_1, V_2, V_3, V_4] be the global vertex indices of the
%       current mesh element.  This routine reorders each tetrahedron so
%       that they satisfy on of these orderings:
%           V_1 < V_2 < V_3 < V_4, (ascending order);
%           V_1 < V_3 < V_2 < V_4, (mirror reflection ascending order),
%       such that each cell has positive volume.
%
%   obj = obj.Order_Cell_Vertices_For_Hcurl();

% Copyright (c) 11-08-2016,  Shawn W. Walker

% create default sorting (ascending)
Tet = sort(obj.ConnectivityList,2);

% find the tets that have negative volume
Vol = tet_volume(obj.Points,Tet);
Neg_Mask = (Vol < 0);

% swap V_2,V_3 to make positive
Tet(Neg_Mask,:) = Tet(Neg_Mask,[1 3 2 4]);

% mention that sub-domain definitions are not preserved under this sorting
% operation
if ~isempty(obj.Subdomain)
    disp('WARNING: you must redefine the sub-domains after sorting the tetrahedra!');
end

% create a NEW object
obj = MeshTetrahedron(Tet,obj.Points,obj.Name);

end

function vol = tet_volume(p,t)

d12 = p(t(:,2),:)-p(t(:,1),:);
d13 = p(t(:,3),:)-p(t(:,1),:);
d14 = p(t(:,4),:)-p(t(:,1),:);
vol = dot(cross(d12,d13,2),d14,2)/6;

end