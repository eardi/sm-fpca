function obj = Reorder(obj)
%Reorder
%
%   This renumbers the mesh vertices to give a tighter adjacency matrix.
%
%   obj = obj.Reorder;

% Copyright (c) 08-19-2009,  Shawn W. Walker

[Cell, Vtx] = obj.Abstract_Reorder;

% you have to just create a NEW object!
OLD_Subdomain = obj.Subdomain;
obj           = MeshTetrahedron(Cell,Vtx,obj.Name);
% keep the same subdomains
obj.Subdomain = OLD_Subdomain;

end