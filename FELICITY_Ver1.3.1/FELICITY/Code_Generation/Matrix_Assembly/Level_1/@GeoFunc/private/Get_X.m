function FUNC = Get_X(obj)
%Get_X
%
%   This outputs a string representation of the function:
%   X, where X is the identity map on the domain.
%
%   FUNC = obj.Get_X;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = cell(obj.Domain.GeoDim,1);
for ind = 1:obj.Domain.GeoDim
    FUNC{ind} = [obj.Name, '_', 'X', num2str(ind)];
end

end