function obj = d_ds_func(obj)
%d_ds_func
%
%   Get arc-length derivative of the function, f.

% Copyright (c) 03-12-2012,  Shawn W. Walker

% this is only allowed for topological dimension 1
TD = obj.GeoMap.TopDim;
if (TD==1)
    obj.f.d_ds = sym('f_d_ds');
else
    obj.f.d_ds = [];
end

end