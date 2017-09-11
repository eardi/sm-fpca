function CODE = PHI_Det_Metric_C_Code(obj)
%PHI_Det_Metric_C_Code
%
%   Generate C-code for direct evaluation of det(Metric).

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Metric) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Det_Metric');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Det_Metric_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);

    % need the metric tensor
    Map_PHI_Metric_str = obj.Output_CPP_Var_Name('Metric');
    Map_PHI_Metric_Matrix_str = [Map_PHI_Metric_str, '[qp_i]'];
    % call a function to compute the determinant
    EVAL_STR(1).line = []; % init
    EVAL_STR(1).line = [Map_PHI_Det_Metric_Eval_str, ' = ', 'Determinant(', Map_PHI_Metric_Matrix_str, ');'];

    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr = '// determinant of the metric matrix';
    Loop_Hdr = '// compute determinant of Metric: det(PHI_Metric)';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
else
    CODE = [];
end

end