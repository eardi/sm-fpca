function obj = d2_ds2_func(obj)
%d2_ds2_func
%
%   Get 2nd arc-length derivative of the function, f.

% Copyright (c) 03-12-2012,  Shawn W. Walker

% this is only allowed for topological dimension 1
TD = obj.GeoMap.TopDim;
if (TD==1)
    obj.f.d2_ds2 = sym('f_d2_ds2');
else
    obj.f.d2_ds2 = [];
end

end