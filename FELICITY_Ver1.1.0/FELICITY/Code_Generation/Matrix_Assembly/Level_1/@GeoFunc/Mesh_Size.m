function OUT = Mesh_Size(obj,varargin)
%Mesh_Size
%
%   This outputs a symbolic variable representation of the function:
%   h, where h is the mesh size of the current element (simplex); note: this is
%   a constant function over the element.
%
%   OUT = obj.Mesh_Size(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 04-28-2012,  Shawn W. Walker

FUNC = obj.Get_Mesh_Size;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end