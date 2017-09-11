function obj = init_func(obj)
%init_func
%
%   This initializes the local function form.

% Copyright (c) 03-12-2012,  Shawn W. Walker

obj = orientation_func(obj);
obj = value_func(obj);
obj = div_func(obj);
%obj = grad_func(obj);

end