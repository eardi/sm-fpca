function FUNC = Get_Shape_Op(obj)
%Get_Shape_Op
%
%   This outputs a string representation of the shape operator of the domain.
%   See 'Shape_Op.m' for more info.
%
%   FUNC = obj.Get_Shape_Op;
%
%   FUNC = string representation of function.

% Copyright (c) 08-15-2014,  Shawn W. Walker

FUNC = cell(obj.Domain.GeoDim,obj.Domain.GeoDim);

for ri = 1:obj.Domain.GeoDim
for ci = 1:obj.Domain.GeoDim
    FUNC{ri,ci} = [obj.Name, '_', 'Shape_Op_', num2str(ri), num2str(ci)];
end
end

end