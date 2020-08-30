function CODE = FUNC_Val_special_C_Code(obj)
%FUNC_Val_special_C_Code
%
%   Generate C-code for direct evaluation of global constant basis function
%   C.
%   Note: this is a special case code snippet.

% Copyright (c) 01-11-2018,  Shawn W. Walker

% make var string
C_Val_str = 'BF_V';

BF = ['phi_Val', '.a'];
TAB = '    ';

% loop thru all components of the map
EVAL_STR(2).line = []; % init
EVAL_STR(1).line = ['// only one value: 1!'];
EVAL_STR(2).line = [C_Val_str, '.a', ' = ', BF, ';']; % C-style indexing

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = [];
Loop_Hdr = '// copy constant evaluations over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_basis_func_declaration_and_eval_code(C_Val_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end