function CPP_Name = Output_CPP_Var_Name(obj,FIELD_str)
%Output_CPP_Var_Name
%
%   This outputs a string representing the C++ variable name.

% Copyright (c) 01-19-2018,  Shawn W. Walker

if isfield(obj.C,FIELD_str)
    
    SYM_Var = obj.C.(FIELD_str);
    
    if strcmp(FIELD_str,'Val')
        Var_str = char(SYM_Var);
        Var_str = Var_str(1:end);
    else
        error('Not valid!');
    end
    
else
    disp(['ERROR: this error concerns the function operation ''', FIELD_str, '''.']);
    error('For a *constant*, only ''Val'' is allowed.');
end

CPP_Name = Get_Func_CPP_Var_Name(Var_str);

end