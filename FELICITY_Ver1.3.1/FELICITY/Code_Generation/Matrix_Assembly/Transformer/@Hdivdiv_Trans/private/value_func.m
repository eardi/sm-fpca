function obj = value_func(obj)
%value_func
%
%   Get the value function, i.e. direct evaluation of f.

% Copyright (c) 03-22-2018,  Shawn W. Walker

GD = obj.GeoMap.GeoDim;
if (GD==1)
    error('H(div div) functions do not exist in 1-D!');
end

obj.TT.Val = sym('TT_Value_%d%d', [GD, GD]);

end