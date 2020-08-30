function CODE = PHI_Inv_Det_2nd_Fund_Form_C_Code(obj)
%PHI_Inv_Det_2nd_Fund_Form_C_Code
%
%   Generate C-code for direct evaluation of PHI.Inv_Det_Second_Fund_Form.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% init (part of) output struct
EVAL_STR(4).line = []; % init
TAB = '    ';

if ~isempty(obj.PHI.Inv_Det_Second_Fund_Form)
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Inv_Det_Second_Fund_Form');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Inv_Det_2Form_Eval_str = obj.Get_CPP_Scalar_Eval_String(CODE.Var_Name(1).line);
    
    % need the determinant of second fundamental form tensor
    Map_PHI_Det_Second_Fund_Form_str = obj.Output_CPP_Var_Name('Det_Second_Fund_Form');
    Map_PHI_Det_Second_Fund_Form_Eval_str = [Map_PHI_Det_Second_Fund_Form_str, '[qp_i]', '.a'];

    if ~obj.Lin_PHI_TF % map is non-linear
        EVAL_STR(1).line = ['if (abs(', Map_PHI_Det_Second_Fund_Form_Eval_str, ') < 1E-15)'];
        EVAL_STR(2).line = [TAB, Map_PHI_Inv_Det_2Form_Eval_str, ' = 1E15; // this is an INFINITE value!'];
        EVAL_STR(3).line = ['else'];
        EVAL_STR(4).line = [TAB, Map_PHI_Inv_Det_2Form_Eval_str, ' = 1.0 / ', Map_PHI_Det_Second_Fund_Form_Eval_str, ';'];
        
    else % the map is linear, so the second fund form is ZERO!
        EVAL_STR(1).line = [Map_PHI_Inv_Det_2Form_Eval_str, ' = 1E15; // this is an INFINITE value!'];
    end
    
    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr = '// inverse of determinant of the 2nd fundamental form matrix';
    Loop_Hdr = '// compute 1 / det(2nd_Fund_Form)';
    if ~obj.Lin_PHI_TF % map is non-linear
        Loop_Comment = '// check for zero value:';
    else % the map is linear, so the second fund form is ZERO!
        Loop_Comment = '// set to an "infinite value":';
    end
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    CODE = [];
end

end