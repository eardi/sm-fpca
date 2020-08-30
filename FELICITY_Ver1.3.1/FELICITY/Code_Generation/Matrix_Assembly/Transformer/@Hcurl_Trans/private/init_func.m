function obj = init_func(obj)
%init_func
%
%   This initializes the local function form.

% Copyright (c) 10-17-2016,  Shawn W. Walker

obj = orientation_func(obj);
obj = value_func(obj);
obj = curl_func(obj);
%obj = grad_func(obj);

end