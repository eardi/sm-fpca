function CODE = FUNC_d2_ds2_C_Code(obj)
%FUNC_d2_ds2_C_Code
%
%   Generate C-code for evaluation of d^2/ds^2 (f).
%        d^2/ds^2 f_k(qp) = (ds(qp)/dt)^{-2} *
%                           [d^2/dt^2 f_k(qp) - (d/ds f_k(qp)) * (vt(qp)' * d^2/dt^2 PHI(qp))]
%                             s(t) is the arc-length variable,
%                             t is the local coordinate (parametrization var.),
%                             vt is the tangent vector on the 1-D curve domain,
%                             k is the basis function index,
%                             qp are the coordinates of a quadrature point.
%   Note: this quantity is only used for topological dimension 1.

% Copyright (c) 10-27-2016,  Shawn W. Walker

if ~isempty(obj.f.d2_ds2)

% make var string
f_d_ds_str   = obj.Output_CPP_Var_Name('d_ds');
f_d2_ds2_str = obj.Output_CPP_Var_Name('d2_ds2');

% is geometric transformation constant?
CONST_JAC = obj.GeoMap.Is_Quantity_Constant('Grad'); % grad(PHI)
if CONST_JAC
    % then jacobian is constant!
    QP_str = '[0]';
else % it is non-linear (varies over the quad points)
    QP_str = '[qp_i]';
end

TAB = '    ';
% make (local) basis function derivative eval strings
%BF_D0 = 'phi_d_ds[qp_i][basis_i].a';
if obj.INTERPOLATION
    BF_DD0 = 'phi_d2_ds2[basis_i].a';
else
    BF_DD0 = 'phi_d2_ds2[qp_i][basis_i].a';
end

Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
Inv_Det_Jac_EVAL_str = ['Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a'];

if CONST_JAC
    % the hessian is ZERO, so the calculation is easier!
    
    % loop thru all basis functions
    EVAL_STR(6).line = []; % init
    EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
    EVAL_STR(2).line = [TAB, '{'];
    EVAL_STR(3).line = [TAB, '// compute square of inverse jacobian determinant'];
    EVAL_STR(4).line = [TAB, 'const double Inv_Det_Jac_Square = ', Inv_Det_Jac_EVAL_str, ' * ', Inv_Det_Jac_EVAL_str, ';'];
    EVAL_STR(5).line = [TAB, f_d2_ds2_str, '[basis_i][qp_i].a', ' = Inv_Det_Jac_Square * ', BF_DD0, ';'];
    EVAL_STR(6).line = [TAB, '}']; % close the basis loop
    
    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr = '// 2nd arc-length derivative of the function (note: hessian of PHI is zero in this case)';
    Loop_Hdr = '// compute d^2/ds^2 of the basis function on the true element in the domain (indexing is in the C style)\n';
    Loop_Comment = '// multiply 1 / Det(Jacobian)^2 by the 2nd derivative of local basis function';
    CONST_VAR = obj.Is_Quantity_Constant('d2_ds2');
    CODE = obj.create_basis_func_declaration_and_eval_code(f_d2_ds2_str,TYPE_str,EVAL_STR,...
                                                           Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    % the hessian is NOT zero, so must be accounted for
    Hess_PHI_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Hess');
    Hess_PHI_EVAL_str = ['Mesh->', Hess_PHI_CPP_Name, QP_str, '.m'];
    
    GD = obj.GeoMap.GeoDim;
    if (GD==1) % calculation is a little simpler here
        % loop thru all basis functions
        EVAL_STR(7).line = []; % init
        EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
        EVAL_STR(2).line = [TAB, '{'];
        EVAL_STR(3).line = [TAB, '// compute square of inverse jacobian determinant'];
        EVAL_STR(4).line = [TAB, 'const double Inv_Det_Jac_Square = ', Inv_Det_Jac_EVAL_str, ' * ', Inv_Det_Jac_EVAL_str, ';'];
        EVAL_STR(5).line = [TAB, 'const double Diff_Hess_Terms = ', BF_DD0, ' - ', ...
            '( ', f_d_ds_str, '[basis_i][qp_i].a', ' * ', Hess_PHI_EVAL_str, '[0][0][0]', ' );'];
        EVAL_STR(6).line = [TAB, f_d2_ds2_str, '[basis_i][qp_i].a', ' = Inv_Det_Jac_Square * Diff_Hess_Terms;'];
        EVAL_STR(7).line = [TAB, '}']; % close the basis loop
    else
        Tangent_Vec_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Tangent_Vector');
        Tangent_Vec_EVAL_str = ['Mesh->', Tangent_Vec_CPP_Name, QP_str, '.v'];
        
        % loop thru all basis functions
        EVAL_STR(9).line = []; % init
        EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
        EVAL_STR(2).line = [TAB, '{'];
        EVAL_STR(3).line = [TAB, '// compute square of inverse jacobian determinant'];
        EVAL_STR(4).line = [TAB, 'const double Inv_Det_Jac_Square = ', Inv_Det_Jac_EVAL_str, ' * ', Inv_Det_Jac_EVAL_str, ';'];
        EVAL_STR(5).line = [TAB, '// compute dot product of tangent vector with Hess(PHI)'];
        TEMP_STR = [Hess_PHI_EVAL_str, '[0][0][0]', ' * ', Tangent_Vec_EVAL_str, '[0]']; % first component
        for gg = 2:GD
            Comp_str = num2str(gg-1); % C-style indexing
            DP_Comp = [Hess_PHI_EVAL_str, '[', Comp_str, '][0][0]', ' * ', Tangent_Vec_EVAL_str, '[', Comp_str, ']'];
            TEMP_STR = [TEMP_STR, ' + ', DP_Comp];
        end
        EVAL_STR(6).line = [TAB, 'const double DP_TV_Hess = ', TEMP_STR, ';'];
        EVAL_STR(7).line = [TAB, 'const double Diff_Hess_Terms = ', BF_DD0, ' - ', ...
            '( ', f_d_ds_str, '[basis_i][qp_i].a', ' * DP_TV_Hess );'];
        EVAL_STR(8).line = [TAB, f_d2_ds2_str, '[basis_i][qp_i].a', ' = Inv_Det_Jac_Square * Diff_Hess_Terms;'];
        EVAL_STR(9).line = [TAB, '}']; % close the basis loop
    end
    
    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr =  '// 2nd arc-length derivative of the function';
    Loop_Hdr = ['// compute d^2/ds^2 of the basis function on the true element in the domain (indexing is in the C style)\n',...
                '    // note: this requires the 1st arc-length derivative of the function'];
    Loop_Comment = '// multiply 1 / Det(Jacobian)^2 by the difference of the hessian terms';
    CONST_VAR = obj.Is_Quantity_Constant('d2_ds2');
    CODE = obj.create_basis_func_declaration_and_eval_code(f_d2_ds2_str,TYPE_str,EVAL_STR,...
                                                           Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
end

else
    CODE = [];
end

end