function CODE = PHI_Det_2nd_Fund_Form_C_Code(obj)
%PHI_Det_2nd_Fund_Form_C_Code
%
%   Generate C-code for direct evaluation of det(2nd Fund. Form).

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Det_Second_Fund_Form) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Det_Second_Fund_Form');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Det_2Form_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);

    % need the second fundamental form tensor
    Map_PHI_Second_Fund_Form_str = obj.Output_CPP_Var_Name('Second_Fund_Form');
    
    Map_PHI_Second_Fund_Form_Eval_str = [Map_PHI_Second_Fund_Form_str, '[qp_i]'];
    % call a function to compute the determinant
    EVAL_STR(1).line = []; % init
    EVAL_STR(1).line = [Map_PHI_Det_2Form_Eval_str, ' = ', 'Determinant(', Map_PHI_Second_Fund_Form_Eval_str, ');'];

    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr = '// determinant of the 2nd fundamental form matrix';
    Loop_Hdr = '// compute determinant of 2nd Fundamental Form: det(2nd_Fund_Form)';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    CODE = [];
end

end