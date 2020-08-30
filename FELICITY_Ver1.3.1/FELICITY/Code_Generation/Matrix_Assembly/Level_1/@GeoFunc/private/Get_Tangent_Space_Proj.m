function FUNC = Get_Tangent_Space_Proj(obj)
%Get_Tangent_Space_Proj
%
%   This outputs a string representation of the function:
%   \nabla X, where X is the identity map on the domain, i.e. the tangent
%   space projection matrix.
%   Note: this is a symmetric matrix!
%
%   FUNC = obj.Get_Tangent_Space_Proj;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC = cell(obj.Domain.GeoDim,obj.Domain.GeoDim);

for ri = 1:obj.Domain.GeoDim
for ci = 1:obj.Domain.GeoDim
    FUNC{ri,ci} = [obj.Name, '_', 'TSP_', num2str(ri), num2str(ci)];
end
end

end