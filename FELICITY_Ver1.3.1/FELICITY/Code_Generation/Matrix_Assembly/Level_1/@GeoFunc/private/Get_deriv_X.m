function FUNC = Get_deriv_X(obj)
%Get_deriv_X
%
%   This outputs a string representation of the function:
%   [\partial_{u} X(u,v), \partial_{v} X(u,v)], where X is the parameterization
%   of the domain; (u,v) are reference coordinates.
%
%   FUNC = obj.Get_deriv_X;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

if strcmp(obj.Domain.Type,'interval')
    TopDim = 1;
elseif strcmp(obj.Domain.Type,'triangle')
    TopDim = 2;
elseif strcmp(obj.Domain.Type,'tetrahedron')
    TopDim = 3;
else
    error('Not implemented!');
end

FUNC = cell(obj.Domain.GeoDim,TopDim);

for ri = 1:obj.Domain.GeoDim
for ci = 1:TopDim
    FUNC{ri,ci} = [obj.Name, '_', 'X', num2str(ri), '_deriv', num2str(ci)];
end
end

end