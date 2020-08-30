function Eval_str = Get_CPP_Basis_Vector_Eval_String(obj,Var_Name_str,basis_index)
%Get_CPP_Basis_Vector_Eval_String
%
%   Output the string for the C++ data type.

% Copyright (c) 02-20-2012,  Shawn W. Walker

Eval_str = [Var_Name_str, '[', num2str(basis_index), ']', '[qp_i]', '.v'];

end