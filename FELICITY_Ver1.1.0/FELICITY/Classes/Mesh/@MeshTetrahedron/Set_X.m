function obj = Set_X(obj,Vtx)
%Set_X
%
%   This overwrites the object so that you can change the vertex coordinates.
%   Note: the object must get overwritten.
%
%   obj = obj.Set_X(Vtx);
%
%   Vtx = new vertex coordinates to replace obj.X.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if (obj.Num_Vtx ~= size(Vtx,1))
    error('Number of vertices does not match present mesh structure.');
end

% you have to just create a NEW object!
OLD_Subdomain = obj.Subdomain;
obj           = MeshTetrahedron(obj.Triangulation,Vtx,obj.Name);
% keep the same subdomains
obj.Subdomain = OLD_Subdomain;

end