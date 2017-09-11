function CPP_Name = Output_CPP_Var_Name_Pointer_DeRef(obj,FIELD_str)
%Output_CPP_Var_Name_Pointer_DeRef
%
%   This outputs a string representing the C++ variable name.

% Copyright (c) 02-20-2012,  Shawn W. Walker

TEMP = obj.Output_CPP_Var_Name(FIELD_str);

CPP_Name = ['(*', TEMP,')'];

end