function CODE = FUNC_Val_special_C_Code(obj)
%FUNC_Val_special_C_Code
%
%   Generate C-code for direct evaluation of f.
%            f_k(qp) = phi_k(qp), where f_k is the kth basis function, and
%                        qp are the coordinates of a quadrature point.
%   Note: this is a special case code snippet.

% Copyright (c) 10-27-2016,  Shawn W. Walker

% make var string
f_Val_str = 'BF_V';

BF = ['phi_Val[qp_i]', '[basis_i]', '.a'];
TAB = '    ';

% loop thru all components of the map
EVAL_STR(4).line = []; % init
EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR(2).line = [TAB, '{'];
EVAL_STR(3).line = [TAB, f_Val_str, '[basis_i][qp_i].a', ' = ', BF, ';']; % C-style indexing
EVAL_STR(4).line = [TAB, '}']; % close the basis loop

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = [];
Loop_Hdr = '// copy function evaluations over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_basis_func_declaration_and_eval_code(f_Val_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end