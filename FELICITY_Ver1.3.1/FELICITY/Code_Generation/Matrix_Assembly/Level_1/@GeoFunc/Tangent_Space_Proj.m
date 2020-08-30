function OUT = Tangent_Space_Proj(obj,varargin)
%Tangent_Space_Proj
%
%   This outputs a symbolic variable representation of the function:
%   \nabla X, where X is the identity map on the domain, i.e. \nabla X is the
%   tangent space projection (matrix), where \nabla is the gradient with respect
%   to the manifold.
%
%   OUT = obj.Tangent_Space_Proj(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = obj.Get_Tangent_Space_Proj;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end