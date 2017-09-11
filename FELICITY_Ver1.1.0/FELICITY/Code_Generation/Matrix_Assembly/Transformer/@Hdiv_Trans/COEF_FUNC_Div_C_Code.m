function CODE = COEF_FUNC_Div_C_Code(obj)
%COEF_FUNC_Div_C_Code
%
%   Generate C-code for computing coefficient functions.
%         vv_div_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * div(vphi_k)(qp), where
%                        vphi_k is the kth (vector) mapped basis function,
%                        vv_i is the ith (tensor) component of the (vector)
%                        coef. function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 03-26-2012,  Shawn W. Walker

% make var string
vv_Div_str = obj.Output_CPP_Var_Name('Div');
Basis_Func_Div_str = ['basis_func->', vv_Div_str];
BF  = [Basis_Func_Div_str, '[basis_i][qp_i].a'];
BF0 = [Basis_Func_Div_str, '[0][qp_i].a'];
CF = [vv_Div_str, '[nc_i][qp_i].a'];
TAB = '    ';
TAB2 = [TAB, TAB];

% loop thru all (tensor) components
EVAL_STR( 9).line = []; % init
EVAL_STR( 1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
EVAL_STR( 3).line = [TAB, CF, ' = Node_Value[nc_i][kc[0]] * ', BF0, ';'];
EVAL_STR( 4).line = [TAB, '// sum over basis functions'];
EVAL_STR( 5).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
EVAL_STR( 6).line = [TAB2, '{'];
EVAL_STR( 7).line = [TAB2, CF, ' += Node_Value[nc_i][kc[basis_i]] * ', BF, ';'];
EVAL_STR( 8).line = [TAB2, '}']; % close the basis loop
EVAL_STR( 9).line = [TAB, '}'];

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// divergence of coefficient function evaluated at a quadrature point in reference element';
Loop_Hdr = '// get coefficient (divergence) function values';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Div');
CODE = obj.create_coef_func_declaration_and_eval_code(vv_Div_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end