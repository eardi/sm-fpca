function CODE = PHI_Det_Jac_w_Weight_C_Code(obj)
%PHI_Det_Jac_w_Weight_C_Code
%
%   Generate C-code for direct evaluation of PHI.Det_Jacobian_with_quad_weight.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Det_Jacobian_with_quad_weight');

% make a reference for the data evaluated at a quad point
Map_PHI_Det_Jac_w_Weight_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);

% need the det(Jac)
Map_PHI_Det_Jacobian_str = obj.Output_CPP_Var_Name('Det_Jacobian');
% evaluate!
if (obj.Lin_PHI_TF) % constant determinant
    QP_str = '[0]';
else
    QP_str = '[qp_i]';
end
Map_PHI_Det_Jacobian_Eval_str = [Map_PHI_Det_Jacobian_str, QP_str, '.a'];
EVAL_STR(1).line = [Map_PHI_Det_Jac_w_Weight_Eval_str, ' = ', Map_PHI_Det_Jacobian_Eval_str, '',...
                                     ' * ', 'Quad_Weights[qp_i];'];
%

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// determinant of Jacobian multiplied by quadrature weight';
Loop_Hdr = '// multiply det(jacobian) by quadrature weight';
Loop_Comment = [];
CONST_VAR = false; % this variable depends on the quadrature points
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end