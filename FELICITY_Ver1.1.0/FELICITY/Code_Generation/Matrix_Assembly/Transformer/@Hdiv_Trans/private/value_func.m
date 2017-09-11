function obj = value_func(obj)
%value_func
%
%   Get the value function, i.e. direct evaluation of f.

% Copyright (c) 03-12-2012,  Shawn W. Walker

GD = obj.GeoMap.GeoDim;
obj.vv.Val = sym('vv_Value_%d', [GD, 1]);

end