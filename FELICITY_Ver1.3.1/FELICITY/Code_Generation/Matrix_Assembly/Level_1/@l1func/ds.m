function OUT = ds(obj,varargin)
%ds
%
%   This outputs a symbolic variable representation of the function:
%   d/ds f, (arc-length derivative)
%
%   OUT = obj.ds(ARG_Indices);
%
%   ARG_Indices = (optional) component indices.
%
%   OUT = sym (symbolic) variable.

% Copyright (c) 01-19-2018,  Shawn W. Walker

obj.Name = inputname(1); % save the external variable name

if ~strcmp(obj.Element.Domain.Type,'interval')
    disp('Can only take the arc-length derivative on a (topologically) 1-D domain.');
    disp(['The Domain''s topological dimension is ', num2str(obj.Element.Domain.Top_Dim), '; see below.']);
    disp(obj.Element.Domain);
    error('Check your code!');
end

FUNC = obj.Get_All_Components;

FUNC_ds = obj.Append_ds(FUNC);

FUNC_tilde = obj.Reduce_Components(FUNC_ds,varargin);

OUT = obj.Make_Symbolic(FUNC_tilde);

% if we are dealing with a global constant
if strcmp(obj.Element.Elem.Transformation,'Constant_Trans')
    % then just return "0"
    OUT = sym(zeros(size(OUT,1),size(OUT,2)));
end

end