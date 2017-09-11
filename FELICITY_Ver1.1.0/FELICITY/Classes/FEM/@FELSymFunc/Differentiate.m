function obj_diff = Differentiate(obj,alpha)
%Differentiate
%
%   This returns a FELSymFunc object that comes from differentiating the
%   internal sym function.
%
%   obj_diff = obj.Differentiate(alpha);
%
%   alpha = 1xN vector that contains the derivatives to compute in multi-index
%           notation.  N = number of independent variables of the function.

% Copyright (c) 02-28-2013,  Shawn W. Walker

if (nargin==1)
    alpha = zeros(1,obj.input_dim); % no derivatives
end
if (length(alpha)~=obj.input_dim)
    error('The alpha multi-index (i.e. the input) does not have the correct number of indices.');
end

TEMP = obj.Func; % init
for ind = 1:obj.input_dim
    TEMP = diff(TEMP,obj.Vars{ind},alpha(ind));
end
if ~isa(TEMP,'sym')
    TEMP = sym(TEMP);
end

obj_diff = obj; % init
obj_diff.Func = TEMP; % overwrite the symbolic (sym) function

end