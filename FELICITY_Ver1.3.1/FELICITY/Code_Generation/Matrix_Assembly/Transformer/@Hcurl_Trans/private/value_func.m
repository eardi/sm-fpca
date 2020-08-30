function obj = value_func(obj)
%value_func
%
%   Get the value function, i.e. direct evaluation of vv.

% Copyright (c) 10-17-2016,  Shawn W. Walker

GD = obj.GeoMap.GeoDim;
if (GD==1)
    error('H(curl) functions do not exist in 1-D!');
end

obj.vv.Val = sym('vv_Value_%d', [GD, 1]);

end