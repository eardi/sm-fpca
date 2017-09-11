function FUNC = Get_VecKappa(obj)
%Get_VecKappa
%
%   This outputs a string representation of the function:
%   K, where K is the oriented vector (total) curvature on the domain.
%
%   FUNC = obj.Get_VecKappa;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = cell(obj.Domain.GeoDim,1);
for ind = 1:obj.Domain.GeoDim
    FUNC{ind} = [obj.Name, '_', 'VecKappa', num2str(ind)];
end

end