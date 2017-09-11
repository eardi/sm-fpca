function CODE = PHI_Inv_Det_Jac_C_Code(obj)
%PHI_Inv_Det_Jac_C_Code
%
%   Generate C-code for direct evaluation of PHI.Inv_Det_Jacobian.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Inv_Det_Jacobian');

% make a reference for the data evaluated at a quad point
Map_PHI_Inv_Det_Jac_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);

% need the det(Jac)
Map_PHI_Det_Jacobian_str = obj.Output_CPP_Var_Name('Det_Jacobian');
Map_PHI_Det_Jacobian_Eval_str = [Map_PHI_Det_Jacobian_str, '[qp_i]', '.a'];

% compute 1 / determinant
EVAL_STR(1).line = []; % init
EVAL_STR(1).line = [Map_PHI_Inv_Det_Jac_Eval_str, ' = ', '1.0 / ', Map_PHI_Det_Jacobian_Eval_str, ';'];

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// inverse of determinant of Jacobian';
Loop_Hdr = '// compute 1 / det(Jacobian)';
Loop_Comment = [];
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end