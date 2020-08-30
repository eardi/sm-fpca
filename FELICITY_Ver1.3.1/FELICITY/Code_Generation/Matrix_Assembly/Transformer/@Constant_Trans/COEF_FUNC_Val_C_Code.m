function CODE = COEF_FUNC_Val_C_Code(obj)
%COEF_FUNC_Val_C_Code
%
%   Generate C-code for computing coefficient constants.
%            C_i(qp) = c_{i} * phi, where
%                        phi is the global basis function 1,
%                        C_i is the ith (tuple) component of the coef.
%                        constant.

% Copyright (c) 01-11-2018,  Shawn W. Walker

% make var string
C_Val_str = obj.Output_CPP_Var_Name('Val');
%if true
    CPP_DeRef_str = ['basis_func->', C_Val_str]; % don't use fancy pointer for coefficient
% else
%     CPP_DeRef_str = ['(*', 'basis_func->', C_Val_str, ')'];
%end
BF  = [CPP_DeRef_str, '.a'];
BF0 = [CPP_DeRef_str, '.a'];
CF = [C_Val_str, '[nc_i]', '.a'];
TAB = '    ';
TAB2 = [TAB, TAB];

% loop thru all (tensor) components
EVAL_STR(9).line = []; % init
EVAL_STR(1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
EVAL_STR(2).line = [TAB, '{'];
EVAL_STR(3).line = [TAB, CF, ' = ', BF0, ' * ', 'Node_Value[nc_i][0]', '; // first (and only) basis function'];
EVAL_STR(9).line = [TAB, '}'];

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// coefficient constant evaluated once (i.e. it is "read in" elsewhere)';
Loop_Hdr = '// get coefficient constant values (THIS SHOULD BE DONE ELSEWHERE!)';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_coef_func_declaration_and_eval_code(C_Val_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end