function CPP_Name = Output_CPP_Var_Name(obj,FIELD_str)
%Output_CPP_Var_Name
%
%   This outputs a string representing the C++ variable name.

% Copyright (c) 03-22-2018,  Shawn W. Walker

SYM_Var = obj.TT.(FIELD_str);

% if strcmp(FIELD_str,'Orientation')
%     Var_str = char(SYM_Var);
%     Var_str = Var_str(1:end);
if strcmp(FIELD_str,'Val')
    Var_str = char(SYM_Var(1));
    Var_str = Var_str(1:end-3);
% elseif strcmp(FIELD_str,'Div')
%     Var_str = char(SYM_Var);
%     Var_str = Var_str(1:end);
% elseif strcmp(FIELD_str,'Grad')
%     Var_str = char(SYM_Var(1??));
%     Var_str = Var_str(1:end-2);
% elseif strcmp(FIELD_str,'Hess')
%     Var_str = char(SYM_Var(1,1??));
%     Var_str = Var_str(1:end-3);
else
    error('Not valid!');
end

CPP_Name = Get_Func_CPP_Var_Name(Var_str);

end