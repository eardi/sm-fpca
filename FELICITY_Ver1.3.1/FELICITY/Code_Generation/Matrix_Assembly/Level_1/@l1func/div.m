function OUT = div(obj,varargin)
%div
%
%   This outputs a symbolic variable representation of the function:
%   \nabla \cdot vv
%
%   Note: this is only useful for intrinsic vector-valued functions.
%
%   OUT = obj.div(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 03-26-2012,  Shawn W. Walker

if ~strcmp(obj.Element.Elem.Transformation,'Hdiv_Trans')
    error('You can only use .div with H(div) spaces (i.e. RT, BDM, etc...)!');
end

obj.Name = inputname(1); % save the external variable name

FUNC = obj.Get_Tensor_Components;

FUNC_div = obj.Append_div(FUNC);

FUNC_tilde = obj.Reduce_Components(FUNC_div,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end