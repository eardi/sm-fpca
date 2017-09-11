function FUNC = Get_T(obj)
%Get_T
%
%   This outputs a string representation of the function:
%   T, where T is the tangent vector on the (interval) domain.
%
%   FUNC = obj.Get_T;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = cell(obj.Domain.GeoDim,1);
for ind = 1:obj.Domain.GeoDim
    FUNC{ind} = [obj.Name, '_', 'T', num2str(ind)];
end

end