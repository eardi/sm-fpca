function FUNC = Get_CPPdefine_Func_Name(obj,Func_Name)
%Get_CPPdefine_Func_Name
%
%   This returns a struct containing CPP mex name info for the given Coef Func.

% Copyright (c) 06-23-2012,  Shawn W. Walker

FOUND = false;
for ind = 1:length(obj.Integration)
    [TF, LOC] = ismember(Func_Name,obj.Integration(ind).CoefFunc.keys);
    if TF
        FOUND = true;
        break;
    end
end
if ~FOUND
    error('Given Func_Name does not exist!');
end

FUNC.Node_Value     = [Func_Name, '_Values'];
FUNC.MEX_Node_Value = ['PRHS_', FUNC.Node_Value];

end