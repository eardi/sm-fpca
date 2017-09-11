function CODE = PHI_Det_Jac_C_Code(obj)
%PHI_Det_Jac_C_Code
%
%   Generate C-code for direct evaluation of det(Jacobian) or sqrt(det(Metric)).

% Copyright (c) 02-20-2012,  Shawn W. Walker

% make var string
CODE.Var_Name(1).line = []; % init
CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Det_Jacobian');

% make a reference for the data evaluated at a quad point
Map_PHI_Det_Jacobian_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);

num_row = size(obj.PHI.Grad,1);
num_col = size(obj.PHI.Grad,2);
% if the PHI.Grad matrix is square
if (num_row==num_col)
    % need the gradient of the map!
    Map_PHI_Grad_str = obj.Output_CPP_Var_Name('Grad');
    Map_PHI_Grad_Matrix_str = [Map_PHI_Grad_str, '[qp_i]'];
    % call a function to compute the determinant
    EVAL_STR(1).line = []; % init
    EVAL_STR(1).line = [Map_PHI_Det_Jacobian_Eval_str, ' = ', 'Determinant(', Map_PHI_Grad_Matrix_str, ');'];
    
elseif (num_row > num_col) % if the PHI.Grad matrix is NOT square
    if ~isempty(obj.PHI.Det_Metric)
        % need the det(metric)
        Map_PHI_Det_Metric_str = obj.Output_CPP_Var_Name('Det_Metric');
        Map_PHI_Det_Metric_Eval_str = [Map_PHI_Det_Metric_str, '[qp_i]', '.a'];
        EVAL_STR(1).line = [Map_PHI_Det_Jacobian_Eval_str, ' = ', 'sqrt(', Map_PHI_Det_Metric_Eval_str, ');'];
    else
        error('Not valid!');
    end
else
    error('Not valid!');
end

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// determinant of the transformation (Jacobian)';
LH1 = '// compute determinant of Jacobian';
if (num_row==num_col)
    LH2 = '// note: det(Jac) = det(PHI_Grad)';
else
    LH2 = '// note: det(Jac) = sqrt(det(PHI_Metric))';
end
Loop_Hdr = [LH1, '\n', '    ', LH2];
Loop_Comment = [];
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end