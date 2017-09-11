function FUNC = Get_N(obj)
%Get_N
%
%   This outputs a string representation of the function:
%   N, where N is the normal vector on the domain.
%
%   FUNC = obj.Get_N;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = cell(obj.Domain.GeoDim,1);
for ind = 1:obj.Domain.GeoDim
    FUNC{ind} = [obj.Name, '_', 'N', num2str(ind)];
end

end