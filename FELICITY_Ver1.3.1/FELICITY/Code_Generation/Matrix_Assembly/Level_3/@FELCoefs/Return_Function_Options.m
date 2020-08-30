function OUTPUT_Func = Return_Function_Options(obj)
%Return_Function_Options
%
%   This RETURNS what needs to be computed in the C++ code for each
%   coefficient function.

% Copyright (c) 04-10-2010,  Shawn W. Walker

error('WHO??');

% we only want to return the function options!
for ind = 1:obj.Num_Funcs
    OUTPUT_Func(ind).Coef.Opt = obj.Func(ind).Coef.Opt;
end

end