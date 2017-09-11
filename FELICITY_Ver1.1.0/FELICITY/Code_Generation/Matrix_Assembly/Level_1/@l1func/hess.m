function OUT = hess(obj,varargin)
%hess
%
%   This outputs a symbolic variable representation of the function:
%   \nabla^2 f
%
%   OUT = obj.hess(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-07-2014,  Shawn W. Walker

obj.Name = inputname(1); % save the external variable name

FUNC = obj.Get_All_Components;

FUNC_hess = obj.Append_hess(FUNC);

FUNC_tilde = obj.Reduce_Components(FUNC_hess,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end