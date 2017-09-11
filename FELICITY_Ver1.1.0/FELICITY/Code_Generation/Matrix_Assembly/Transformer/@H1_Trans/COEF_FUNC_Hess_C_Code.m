function CODE = COEF_FUNC_Hess_C_Code(obj)
%COEF_FUNC_Hess_C_Code
%
%   Generate C-code for computing coefficient functions.
%     \nabla^2 f_i(qp) = SUM^{NUM_BASIS}_{k=1} c_{ik} * \nabla^2 phi_k(qp), where
%                        phi_k is the kth mapped basis function,
%                        f_i is the ith component of the coef. function, and
%                        qp are the coordinates of a quadrature point.

% Copyright (c) 08-11-2014,  Shawn W. Walker

TAB = '    ';
TAB2 = [TAB, TAB];

% make var string
f_Hess_str = obj.Output_CPP_Var_Name('Hess');

% make var string
BF  = ['basis_func->', f_Hess_str, '[basis_i][qp_i]'];
BF0 = ['basis_func->', f_Hess_str, '[0][qp_i]'];
CF  = [f_Hess_str, '[nc_i][qp_i]'];
MAT_Dx1_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.GeoMap.GeoDim,obj.GeoMap.GeoDim);

% loop thru all components of the coefficient function
EVAL_STR(11).line = []; % init
EVAL_STR( 1).line = ['for (int nc_i = 0; (nc_i < Num_Comp); nc_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
EVAL_STR( 3).line = ['Scalar_Mult_Matrix(', BF0, ', ', 'Node_Value[nc_i][kc[0]]', ', ', CF, ');'];
EVAL_STR( 4).line = [TAB, '// sum over basis functions'];
EVAL_STR( 5).line = [TAB, 'for (int basis_i = 1; (basis_i < NB); basis_i++)'];
EVAL_STR( 6).line = [TAB2, '{'];
EVAL_STR( 7).line = [TAB2, MAT_Dx1_str, '  Temp_MAT;'];
EVAL_STR( 8).line = [TAB2, 'Scalar_Mult_Matrix(', BF, ', ', 'Node_Value[nc_i][kc[basis_i]]', ', Temp_MAT);'];
EVAL_STR( 9).line = [TAB2, 'Add_Matrix(', CF, ', Temp_MAT, ', CF, ');'];
EVAL_STR(10).line = [TAB2, '}'];
EVAL_STR(11).line = [TAB, '}'];

% define the data type
TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.GeoMap.GeoDim,obj.GeoMap.GeoDim);
Defn_Hdr = '// (intrinsic) hessian of coefficient function';
Loop_Hdr = '// get hessian of coefficient function';
Loop_Comment = '// loop through all components (indexing is in the C style)';
CONST_VAR = obj.Is_Quantity_Constant('Hess');
CODE = obj.create_coef_func_declaration_and_eval_code(f_Hess_str,TYPE_str,EVAL_STR,...
                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end