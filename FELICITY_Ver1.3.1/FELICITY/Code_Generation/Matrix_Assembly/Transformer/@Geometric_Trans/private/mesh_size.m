function obj = mesh_size(obj)
%mesh_size
%
%   Get the mesh size of the local element.

% Copyright (c) 05-19-2016,  Shawn W. Walker

obj.PHI.Mesh_Size = sym('Mesh_Size');

end