function OUT = grad(obj,varargin)
%grad
%
%   This outputs a symbolic variable representation of the function:
%   \nabla f
%
%   OUT = obj.grad(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 01-20-2018,  Shawn W. Walker

obj.Name = inputname(1); % save the external variable name

FUNC = obj.Get_All_Components;

FUNC_grad = obj.Append_grad(FUNC);

FUNC_tilde = obj.Reduce_Components(FUNC_grad,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

% if we are dealing with a global constant
if strcmp(obj.Element.Elem.Transformation,'Constant_Trans')
    % then just return "0"
    OUT = sym(zeros(size(OUT,1),size(OUT,2)));
end

end