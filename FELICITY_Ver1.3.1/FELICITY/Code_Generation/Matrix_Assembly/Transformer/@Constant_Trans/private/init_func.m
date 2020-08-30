function obj = init_func(obj)
%init_func
%
%   This initializes the local function form.
%   Note: for constants, all we care about is the scalar case.  For example,
%   if you have a tuple-valued constant, all of the components transform
%   the SAME way (i.e. there is no transformation because it is a constant!).

% Copyright (c) 01-11-2018,  Shawn W. Walker

obj = value_func(obj);

end