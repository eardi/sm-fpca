function CODE = FUNC_d_ds_C_Code(obj)
%FUNC_d_ds_C_Code
%
%   Generate C-code for evaluation of d/ds(f).
%        d/ds f_k(qp) = d/dt f_k(qp) / (ds(qp)/dt),
%                             s(t) is the arc-length variable,
%                             t is the local coordinate (parametrization var.),
%                             k is the basis function index,
%                             qp are the coordinates of a quadrature point.
%   Note: this quantity is only used for topological dimension 1.

% Copyright (c) 10-27-2016,  Shawn W. Walker

if ~isempty(obj.f.d_ds)

% make var string
f_d_ds_str = obj.Output_CPP_Var_Name('d_ds');

% is geometric transformation constant?
if obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end

TAB = '    ';
% make (local) basis function derivative eval strings
if obj.INTERPOLATION
    BF_D0 = 'phi_d_ds[basis_i].a';
else
    BF_D0 = 'phi_d_ds[qp_i][basis_i].a';
end

Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');

% loop thru all components of the map
EVAL_STR(4).line = []; % init
EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR(2).line = [TAB, '{'];
EVAL_STR(3).line = [TAB, f_d_ds_str, '[basis_i][qp_i].a', ' = ', BF_D0, ' * ', ...
                        'Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a;'];
EVAL_STR(4).line = [TAB, '}']; % close the basis loop

% define the data type
TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
Defn_Hdr = '// arc-length derivative of the function';
Loop_Hdr = '// compute d/ds of the basis function on the true element in the domain (indexing is in the C style)';
Loop_Comment = '// multiply by 1 / Det(Jacobian)';
CONST_VAR = obj.Is_Quantity_Constant('d_ds');
CODE = obj.create_basis_func_declaration_and_eval_code(f_d_ds_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
else
    CODE = [];
end

end