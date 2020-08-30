function OUT = deriv_X(obj,varargin)
%deriv_X
%
%   This outputs a symbolic variable representation of the function:
%   [\partial_{u} X(u,v), \partial_{v} X(u,v)], where X is the parameterization
%   of the domain; (u,v) are reference coordinates.
%
%   OUT = obj.deriv_X(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = obj.Get_deriv_X;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end