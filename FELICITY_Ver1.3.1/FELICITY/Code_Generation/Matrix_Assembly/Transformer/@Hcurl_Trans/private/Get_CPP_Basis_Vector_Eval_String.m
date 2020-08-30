function Eval_str = Get_CPP_Basis_Vector_Eval_String(obj,Var_Name_str,basis_index)
%Get_CPP_Basis_Vector_Eval_String
%
%   Output the string for the C++ data type.

% Copyright (c) 10-17-2016,  Shawn W. Walker

error('fix!!!');


Eval_str = [Var_Name_str, '[', num2str(basis_index), ']', '[qp_i]', '.v'];

end