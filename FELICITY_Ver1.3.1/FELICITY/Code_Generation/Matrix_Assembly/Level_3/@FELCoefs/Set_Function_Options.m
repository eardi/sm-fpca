function obj = Set_Function_Options(obj,CF)
%Set_Function_Options
%
%   This SETS what needs to be computed in the C++ code for each
%   coefficient function.

% Copyright (c) 03-15-2012,  Shawn W. Walker

if (obj.Num_Funcs~=length(CF))
    error('Number of incoming function options is not correct!');
end

% we only want to return the function options!
% we must OR the options in!!!
for ind = 1:obj.Num_Funcs
    obj.Func(ind).Coef = obj.Func(ind).Coef.OR_Option_Struct(CF(ind).func.Opt);
end

end