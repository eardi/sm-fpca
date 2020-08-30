function obj = init_func(obj)
%init_func
%
%   This initializes the local function form.
%   Note: for H^1 functions, all we care about is the scalar case.  For example,
%   if you have a vector valued H^1 basis function, all of the vector components
%   transform the SAME way.

% Copyright (c) 03-12-2012,  Shawn W. Walker

obj = value_func(obj);
obj = grad_func(obj);
obj = d_ds_func(obj);
obj = hess_func(obj);
obj = d2_ds2_func(obj);

end