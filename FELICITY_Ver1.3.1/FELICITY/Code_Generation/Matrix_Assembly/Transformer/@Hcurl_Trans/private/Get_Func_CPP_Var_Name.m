function CPP_Var_str = Get_Func_CPP_Var_Name(Var_str)
%Get_Func_CPP_Var_Name
%
%   Output the string for the actual C++ variable name.

% Copyright (c) 10-17-2016,  Shawn W. Walker

CPP_Var_str = ['Func_', Var_str]; % just add a prefix

end