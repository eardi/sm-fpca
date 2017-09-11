function CODE = FUNC_Div_C_Code(obj)
%FUNC_Div_C_Code
%
%   Generate C-code for direct evaluation of \nabla \cdot vv.
%         vv_div_k(qp) = SUM^{DIM}_{j=1} \partial_j [vv_j]_k(qp), where vv_j is
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
vv_Div_str = obj.Output_CPP_Var_Name('Div');

BF_V0_D0 = ['phi_', '0', '_Basis_Val_1_0_0[qp_i]', '[basis_i]'];
BF_V1_D1 = ['phi_', '1', '_Basis_Val_0_1_0[qp_i]', '[basis_i]'];
BF_V2_D2 = ['phi_', '2', '_Basis_Val_0_0_1[qp_i]', '[basis_i]'];
TAB = '    ';

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end
Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
INV_DET = ['Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a'];
vv_Orient_Name = obj.Output_CPP_Var_Name('Orientation');
vv_Orient_Eval = [vv_Orient_Name, '[basis_i][0].a'];

% loop thru all components of the map
if (obj.GeoMap.TopDim==2)
    EVAL_STR( 8).line = []; % init
    EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
    EVAL_STR( 2).line = [TAB, '{'];
    EVAL_STR( 3).line = [TAB, '// initialize with orientation adjustment'];
    EVAL_STR( 4).line = [TAB, 'const double dv0_dx0 = ', vv_Orient_Eval, ' * ', BF_V0_D0, ';'];
    EVAL_STR( 5).line = [TAB, 'const double dv1_dx1 = ', vv_Orient_Eval, ' * ', BF_V1_D1, ';'];
    EVAL_STR( 6).line = [TAB, '// pre-multiply by 1/det(Jac)'];
    EVAL_STR( 7).line = [TAB, vv_Div_str, '[basis_i][qp_i]', '.a', ' = (dv0_dx0 + dv1_dx1) * ', INV_DET, ';'];
    EVAL_STR( 8).line = [TAB, '}']; % close the basis loop
elseif (obj.GeoMap.TopDim==3)
    EVAL_STR( 9).line = []; % init
    EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
    EVAL_STR( 2).line = [TAB, '{'];
    EVAL_STR( 3).line = [TAB, '// initialize with orientation adjustment'];
    EVAL_STR( 4).line = [TAB, 'const double dv0_dx0 = ', vv_Orient_Eval, ' * ', BF_V0_D0, ';'];
    EVAL_STR( 5).line = [TAB, 'const double dv1_dx1 = ', vv_Orient_Eval, ' * ', BF_V1_D1, ';'];
    EVAL_STR( 6).line = [TAB, 'const double dv2_dx2 = ', vv_Orient_Eval, ' * ', BF_V2_D2, ';'];
    EVAL_STR( 7).line = [TAB, '// pre-multiply by 1/det(Jac)'];
    EVAL_STR( 8).line = [TAB, vv_Div_str, '[basis_i][qp_i]', '.a', ' = (dv0_dx0 + dv1_dx1 + dv2_dx2) * ', INV_DET, ';'];
    EVAL_STR( 9).line = [TAB, '}']; % close the basis loop
else
    error('Invalid!');
end

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// divergence of vector valued H(div) basis functions';
Loop_Hdr = '// map divergence of basis vectors over (indexing is in the C style)';
Loop_Comment = '// evaluate for each basis function';
CONST_VAR = obj.Is_Quantity_Constant('Div');
CODE = obj.create_basis_func_declaration_and_eval_code(vv_Div_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%

end