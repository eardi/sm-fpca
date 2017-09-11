function CODE = COEF_FUNC_Val_C_Code(obj)
%COEF_FUNC_Val_C_Code
%
%   Generate C-code for computing coefficient functions.
%             vv_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * vphi_k(qp), where
%                        vphi_k is the kth (vector) mapped basis function,
%                        vv_i is the ith (tensor) component of the (vector)
%                        coef. function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 03-26-2012,  Shawn W. Walker

% make var string
vv_Val_str = obj.Output_CPP_Var_Name('Val');
Basis_Func_Val_str = ['basis_func->', vv_Val_str];
BF  = [Basis_Func_Val_str, '[basis_i][qp_i]'];
BF0 = [Basis_Func_Val_str, '[0][qp_i]'];
CF = [vv_Val_str, '[nc_i][qp_i]'];
TAB = '    ';
TAB2 = [TAB, TAB];

% loop thru all (tensor) components
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
EVAL_STR(14).line = []; % init
EVAL_STR( 1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
EVAL_STR( 3).line = [TAB, 'SCALAR NodeV;'];
EVAL_STR( 4).line = [TAB, 'NodeV.a = Node_Value[nc_i][kc[0]];'];
EVAL_STR( 5).line = [TAB, 'Scalar_Mult_Vector(', BF0, ', NodeV, ', CF, '); // first basis function'];
EVAL_STR( 6).line = [TAB, '// sum over basis functions'];
EVAL_STR( 7).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
EVAL_STR( 8).line = [TAB2, '{'];
EVAL_STR( 9).line = [TAB2, 'NodeV.a = Node_Value[nc_i][kc[basis_i]];'];
EVAL_STR(10).line = [TAB2, TYPE_str, '  temp_vec;'];
EVAL_STR(11).line = [TAB2, 'Scalar_Mult_Vector(', BF, ', NodeV, ', 'temp_vec', ');'];
EVAL_STR(12).line = [TAB2, 'Add_Vector_Self(', 'temp_vec', ', ', CF, ');'];
EVAL_STR(13).line = [TAB2, '}']; % close the basis loop
EVAL_STR(14).line = [TAB, '}'];

% define the data type
Defn_Hdr = '// coefficient function evaluated at a quadrature point in reference element';
Loop_Hdr = '// get coefficient function values';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_coef_func_declaration_and_eval_code(vv_Val_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end