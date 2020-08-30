function OUT = T(obj,varargin)
%T
%
%   This outputs a symbolic variable representation of the function:
%   T, where T is the oriented tangent vector on the (interval) domain.
%
%   OUT = obj.T(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 08-01-2011,  Shawn W. Walker

if ~strcmp(obj.Domain.Type,'interval')
    disp('You can only access the tangent vector on a (intrinsic) 1-D domain.');
    disp(['The Domain''s topological dimension is ', num2str(obj.Domain.Top_Dim), '; see below.']);
    disp(obj.Domain);
    error('Check your code!');
end

FUNC = obj.Get_T;

FUNC_tilde = obj.Reduce_Components(FUNC,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

end