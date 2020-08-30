function CODE = PHI_Inv_Det_Metric_C_Code(obj)
%PHI_Inv_Det_Metric_C_Code
%
%   Generate C-code for direct evaluation of PHI.Inv_Det_Metric.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% init (part of) output struct
CODE.Var_Name(1).line = [];
EVAL_STR(1).line = []; % init

if ~isempty(obj.PHI.Inv_Det_Metric)
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Inv_Det_Metric');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Inv_Det_Metric_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);

    % need the det(metric)
    Map_PHI_Det_Metric_str = obj.Output_CPP_Var_Name('Det_Metric');
    Map_PHI_Det_Metric_Eval_str = [Map_PHI_Det_Metric_str, '[qp_i]', '.a'];
    % compute 1 / determinant
    EVAL_STR(1).line = []; % init
    EVAL_STR(1).line = [Map_PHI_Inv_Det_Metric_Eval_str, ' = ', '1.0 / ', Map_PHI_Det_Metric_Eval_str, ';'];

    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr = '// inverse of determinant of Metric';
    Loop_Hdr = '// compute 1 / det(Metric)';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
else
    CODE = [];
end

end