function CODE = COEF_FUNC_Val_C_Code(obj)
%COEF_FUNC_Val_C_Code
%
%   Generate C-code for computing coefficient functions.
%            f_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * phi_k(qp), where
%                        phi_k is the kth mapped basis function,
%                        f_i is the ith (tensor) component of the coef.
%                        function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 02-06-2013,  Shawn W. Walker

% make var string
f_Val_str = obj.Output_CPP_Var_Name('Val');
if obj.INTERPOLATION
    CPP_DeRef_str = ['basis_func->', f_Val_str]; % don't use fancy pointer when interpolating
else
    CPP_DeRef_str = ['(*', 'basis_func->', f_Val_str, ')'];
end
BF  = [CPP_DeRef_str, '[basis_i][qp_i]', '.a'];
BF0 = [CPP_DeRef_str, '[0][qp_i]', '.a'];
CF = [f_Val_str, '[nc_i][qp_i]', '.a'];
TAB = '    ';
TAB2 = [TAB, TAB];

% loop thru all (tensor) components
EVAL_STR(9).line = []; % init
EVAL_STR(1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
EVAL_STR(2).line = [TAB, '{'];
EVAL_STR(3).line = [TAB, CF, ' = ', BF0, ' * ', 'Node_Value[nc_i][kc[0]]', '; // first basis function'];
EVAL_STR(4).line = [TAB, '// sum over basis functions'];
EVAL_STR(5).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
EVAL_STR(6).line = [TAB2, '{'];
EVAL_STR(7).line = [TAB2, CF, ' += ', BF, ' * ', 'Node_Value[nc_i][kc[basis_i]]', ';']; % C-style indexing
EVAL_STR(8).line = [TAB2, '}']; % close the basis loop
EVAL_STR(9).line = [TAB, '}'];

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// coefficient function evaluated at a quadrature point in reference element';
Loop_Hdr = '// get coefficient function values';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_coef_func_declaration_and_eval_code(f_Val_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end