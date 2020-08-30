function CODE = FUNC_Val_C_Code(obj)
%FUNC_Val_C_Code
%
%   Generate C-code for direct evaluation of vv.
%         [vv_1, ..., vv_j]_k(qp) = [vv_1, ..., vv_j]_k(qp), where vv_j is
%                                   the jth component and _k denotes the kth
%                                   basis function, and qp are the coordinates
%                                   of a quadrature point.

% Copyright (c) 10-27-2016,  Shawn W. Walker

if (obj.GeoMap.TopDim < 2)
    error('Topological dimension must at least be 2!');
end

% make var string
vv_Val_str = obj.Output_CPP_Var_Name('Val');

TAB = '    ';

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad') % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end
Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
INV_DET = ['Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a'];
Grad_PHI_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad');
G_MAT = ['Mesh->', Grad_PHI_CPP_Name, QP_str];

if obj.INTERPOLATION
    Vector_Basis_CPP = 'phi_Val[basis_i]';
else
    Vector_Basis_CPP = 'phi_Val[qp_i][basis_i]';
end
Basis_Sign_CPP   = 'Basis_Sign[basis_i]';

% loop thru all components of the map
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.TopDim);
% code is dimension independent!
EVAL_STR( 9).line = []; % init
EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
EVAL_STR( 3).line = [TAB, TYPE_str, ' vv_temp;'];
EVAL_STR( 4).line = [TAB, '// pre-multiply by sign change'];
EVAL_STR( 5).line = [TAB, 'const double INV_DET_SIGN_FLIP = ', Basis_Sign_CPP, ' * ', INV_DET, ';'];
EVAL_STR( 6).line = [TAB, '// pre-multiply by 1/det(Jac)'];
EVAL_STR( 7).line = [TAB, 'Scalar_Mult_Vector(', Vector_Basis_CPP, ', INV_DET_SIGN_FLIP, vv_temp', ');'];
EVAL_STR( 8).line = [TAB, 'Mat_Vec(', G_MAT, ', ', 'vv_temp' ', ', vv_Val_str, '[basis_i][qp_i]', ');'];
EVAL_STR( 9).line = [TAB, '}']; % close the basis loop

% define the data type
Defn_Hdr = '// vector valued H(div) basis functions';
Loop_Hdr = '// map basis vectors over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Val');
vv_Val_TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
CODE = obj.create_basis_func_declaration_and_eval_code(vv_Val_str,vv_Val_TYPE_str,EVAL_STR,...
    Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end