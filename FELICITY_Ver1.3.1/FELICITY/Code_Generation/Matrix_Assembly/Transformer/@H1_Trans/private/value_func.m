function obj = value_func(obj)
%value_func
%
%   Get the value function, i.e. direct evaluation of f.

% Copyright (c) 05-19-2016,  Shawn W. Walker

obj.f.Val = sym('f_Value');

end