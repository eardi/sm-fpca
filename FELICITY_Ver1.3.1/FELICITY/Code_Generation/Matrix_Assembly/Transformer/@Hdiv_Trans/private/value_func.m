function obj = value_func(obj)
%value_func
%
%   Get the value function, i.e. direct evaluation of f.

% Copyright (c) 03-12-2012,  Shawn W. Walker

GD = obj.GeoMap.GeoDim;
if (GD==1)
    error('H(div) functions do not exist in 1-D!');
end

obj.vv.Val = sym('vv_Value_%d', [GD, 1]);

end