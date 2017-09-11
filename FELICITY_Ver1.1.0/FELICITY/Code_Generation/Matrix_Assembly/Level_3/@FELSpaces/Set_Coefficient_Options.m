function obj = Set_Coefficient_Options(obj,CF)
%Set_Coefficient_Options
%
%   This SETS what needs to be computed in the C++ code for each
%   coefficient function.

% Copyright (c) 06-03-2012,  Shawn W. Walker

Num_Funcs = length(CF);
for ind = 1:Num_Funcs
    TEMP_CoefFunc = obj.Integration(CF(ind).Integration_Index).CoefFunc(CF(ind).func.Func_Name);
    TEMP_CoefFunc = TEMP_CoefFunc.OR_Option_Struct(CF(ind).func.Opt);
    obj.Integration(CF(ind).Integration_Index).CoefFunc(CF(ind).func.Func_Name) = TEMP_CoefFunc;
end

end