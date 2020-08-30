function Eval_str = Get_CPP_Vector_Eval_String(obj,Var_Name_str,Comp_Index)
%Get_CPP_Vector_Eval_String
%
%   Output the string for the C++ data type.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% make a reference for the data evaluated at a quad point
CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(Var_Name_str);
% evaluate at the given vector index
Eval_str = [CPP_REF_Var_str, '.v[', num2str(Comp_Index-1), ']']; % C-style indexing

end