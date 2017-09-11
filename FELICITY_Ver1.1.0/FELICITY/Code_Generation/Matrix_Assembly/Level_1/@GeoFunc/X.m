function OUT = X(obj,varargin)
%X
%
%   This outputs a symbolic variable representation of the function:
%   X, where X is the identity map on the domain.
%
%   OUT = obj.X(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = obj.Get_X;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end