function CODE = FUNC_Div_C_Code(obj)
%FUNC_Div_C_Code
%
%   Generate C-code for direct evaluation of \nabla \cdot vv.
%         vv_div_k(qp) = SUM^{DIM}_{j=1} \partial_j [vv_j]_k(qp), where vv_j is
%                                   the jth component and _k denotes the kth
%                                   basis function, and qp are the coordinates
%                                   of a quadrature point.

% Copyright (c) 10-27-2016,  Shawn W. Walker

if (obj.GeoMap.TopDim < 2)
    error('Topological dimension must at least be 2!');
end

% make var string
vv_Div_str = obj.Output_CPP_Var_Name('Div');

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

if obj.INTERPOLATION
    Div_Basis_CPP = 'phi_Div[basis_i].a';
else
    Div_Basis_CPP = 'phi_Div[qp_i][basis_i].a';
end
Basis_Sign_CPP = 'Basis_Sign[basis_i]';

EVAL_STR( 5).line = []; % init
EVAL_STR( 1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR( 2).line = [TAB, '{'];
EVAL_STR( 3).line = [TAB, '// pre-multiply by 1/det(Jac) (and flip sign if necessary)'];
EVAL_STR( 4).line = [TAB, vv_Div_str, '[basis_i][qp_i]', '.a', ' = ', Basis_Sign_CPP, ' * (', Div_Basis_CPP, ') * ', INV_DET, ';'];
EVAL_STR( 5).line = [TAB, '}']; % close the basis loop

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