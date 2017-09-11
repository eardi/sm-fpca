function FUNC = Get_Mesh_Size(obj)
%Get_Mesh_Size
%
%   This outputs a string representation of the function:
%   h, where h is the mesh size of the current element (simplex); note: this is
%   a constant function over the element.
%
%   FUNC = obj.Get_Mesh_Size;
%
%   FUNC = string representation of function.

% Copyright (c) 04-28-2012,  Shawn W. Walker

FUNC{1} = [obj.Name, '_', 'Mesh_Size'];

end