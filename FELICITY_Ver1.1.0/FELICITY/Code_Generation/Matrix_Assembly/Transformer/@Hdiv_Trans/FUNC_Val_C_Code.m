function CODE = FUNC_Val_C_Code(obj)
%FUNC_Val_C_Code
%
%   Generate C-code for direct evaluation of vv.
%         [vv_1, ..., vv_j]_k(qp) = [vv_1, ..., vv_j]_k(qp), where vv_j is
%                                   the jth component and _k denotes the kth
%                                   basis function, and qp are the coordinates
%                                   of a quadrature point.

% Copyright (c) 03-22-2012,  Shawn W. Walker

if (obj.GeoMap.TopDim < 2)
    error('Topological dimension must at least be 2!');
end
if (obj.GeoMap.TopDim~=obj.GeoMap.GeoDim)
    %disp('Not implemented!');
    CODE = [];
    return;
end

% make var string
vv_Val_str = obj.Output_CPP_Var_Name('Val');

BF_V0 = ['phi_', '0', '_Basis_Val_0_0_0[qp_i]', '[basis_i]'];
BF_V1 = ['phi_', '1', '_Basis_Val_0_0_0[qp_i]', '[basis_i]'];
BF_V2 = ['phi_', '2', '_Basis_Val_0_0_0[qp_i]', '[basis_i]'];
TAB = '    ';

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end
Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
INV_DET = ['Mesh->', Inv_Det_Jac_CPP_Name, QP_str, ''];
Grad_PHI_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad');
G_MAT = ['Mesh->', Grad_PHI_CPP_Name, QP_str];
vv_Orient_Name = obj.Output_CPP_Var_Name('Orientation');
vv_Orient_Eval = [vv_Orient_Name, '[basis_i][0].a'];

% loop thru all components of the map
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoMap.GeoDim);
if (obj.GeoMap.TopDim==2)
    EVAL_STR(10).line = []; % init
    EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
    EVAL_STR( 2).line = [TAB, '{'];
    EVAL_STR( 3).line = [TAB, TYPE_str, ' vv_orient, vv_temp;'];
    EVAL_STR( 4).line = [TAB, '// initialize with orientation adjustment'];
    EVAL_STR( 5).line = [TAB, 'vv_orient.v[0] = ', vv_Orient_Eval, ' * ', BF_V0, ';'];
    EVAL_STR( 6).line = [TAB, 'vv_orient.v[1] = ', vv_Orient_Eval, ' * ', BF_V1, ';'];
    EVAL_STR( 7).line = [TAB, '// pre-multiply by 1/det(Jac)'];
    EVAL_STR( 8).line = [TAB, 'Scalar_Mult_Vector(vv_orient, ', INV_DET, ', vv_temp', ');'];
    EVAL_STR( 9).line = [TAB, 'Mat_Vec(', G_MAT, ', ', 'vv_temp' ', ', vv_Val_str, '[basis_i][qp_i]', ');'];
    EVAL_STR(10).line = [TAB, '}']; % close the basis loop
elseif (obj.GeoMap.TopDim==3)
    EVAL_STR(11).line = []; % init
    EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
    EVAL_STR( 2).line = [TAB, '{'];
    EVAL_STR( 3).line = [TAB, TYPE_str, ' vv_orient, vv_temp;'];
    EVAL_STR( 4).line = [TAB, '// initialize with orientation adjustment'];
    EVAL_STR( 5).line = [TAB, 'vv_orient.v[0] = ', vv_Orient_Eval, ' * ', BF_V0, ';'];
    EVAL_STR( 6).line = [TAB, 'vv_orient.v[1] = ', vv_Orient_Eval, ' * ', BF_V1, ';'];
    EVAL_STR( 7).line = [TAB, 'vv_orient.v[2] = ', vv_Orient_Eval, ' * ', BF_V2, ';'];
    EVAL_STR( 8).line = [TAB, '// pre-multiply by 1/det(Jac)'];
    EVAL_STR( 9).line = [TAB, 'Scalar_Mult_Vector(vv_orient, ', INV_DET, ', vv_temp', ');'];
    EVAL_STR(10).line = [TAB, 'Mat_Vec(', G_MAT, ', ', 'vv_temp' ', ', vv_Val_str, '[basis_i][qp_i]', ');'];
    EVAL_STR(11).line = [TAB, '}']; % close the basis loop
else
    error('Invalid!');
end

% define the data type
Defn_Hdr = '// vector valued H(div) basis functions';
Loop_Hdr = '// map basis vectors over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Val');
CODE = obj.create_basis_func_declaration_and_eval_code(vv_Val_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end