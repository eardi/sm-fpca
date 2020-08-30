function CODE = FUNC_Hess_C_Code(obj)
%FUNC_Hess_C_Code
%
%   Generate C-code for evaluation of hessian(f) by transformation.
%   \partial_i \partial_j f_k(qp) =
%                             T(\partial_1 \partial_1 phi_k(qp),...,
%                               \partial_t \partial_t phi_k(qp)),
%                             t is the topological dimension of the domain on
%                             which the local basis function is defined,
%                             k is the basis function index,
%                             i, j is the physical derivative index,
%                             qp are the coordinates of a quadrature point, and
%                             T is some transformation that depends on the local
%                             geometric map.

% Copyright (c) 04-03-2018,  Shawn W. Walker

% make var string
f_Hess_str = obj.Output_CPP_Var_Name('Hess');

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
if obj.INTERPOLATION
    BF_D0 = 'phi_Grad[basis_i].v[0]';
    BF_D1 = 'phi_Grad[basis_i].v[1]';
    BF_D2 = 'phi_Grad[basis_i].v[2]';
    BF_Grad     = 'phi_Grad[basis_i]';
    BF_Hess     = 'phi_Hess[basis_i]';
    BF_Hess_DD0 = 'phi_Hess[basis_i].m[0][0]';
else
    BF_D0 = 'phi_Grad[qp_i][basis_i].v[0]';
    BF_D1 = 'phi_Grad[qp_i][basis_i].v[1]';
    BF_D2 = 'phi_Grad[qp_i][basis_i].v[2]';
    BF_Grad     = 'phi_Grad[qp_i][basis_i]';
    BF_Hess     = 'phi_Hess[qp_i][basis_i]';
    BF_Hess_DD0 = 'phi_Hess[qp_i][basis_i].m[0][0]';
end

% loop thru all components of the map
EVAL_STR(4).line = []; % init
EVAL_STR(1).line = ['for (int basis_i = 0; (basis_i < Num_Basis); basis_i++)'];
EVAL_STR(2).line = [TAB, '{'];
if (obj.GeoMap.TopDim==1) % reference domain is 1-D
    if (obj.GeoMap.GeoDim==1)
        % we can use the Hessian of the inverse map here
        Inv_Det_Jac_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Det_Jacobian');
        Inv_Det_Jac_EVAL_str = ['Mesh->', Inv_Det_Jac_CPP_Name, QP_str, '.a'];
        Hess_Inv_Map_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Hess_Inv_Map');
        Hess_Inv_Map_EVAL_str = ['Mesh->', Hess_Inv_Map_CPP_Name, QP_str, '.m[0][0][0]'];
        
        EVAL_STR(3).line = [TAB, 'const double Inv_Det_Jac_Square = ', Inv_Det_Jac_EVAL_str, ' * ', Inv_Det_Jac_EVAL_str, ';'];
        TEMP_STR = [BF_Hess_DD0, ' * ', 'Inv_Det_Jac_Square']; % first part of formula
        if ~CONST_JAC % map is non-linear, then need the more general formula
            TEMP_STR = [TEMP_STR ' + ', BF_D0, ' * ', Hess_Inv_Map_EVAL_str];
        end
        EVAL_STR(4).line = [TAB, f_Hess_str, '[basis_i][qp_i].m[0][0]', ' = ', TEMP_STR, ';'];
    else % need the 1st and 2nd arc-length derivatives here...
        % formula is: [vt x vt] d^2/ds^2 - [vk x vt] d/ds,
        % vt = unit tangent vector, vk = (signed) curvature vector
        f_d_ds_str   = obj.Output_CPP_Var_Name('d_ds');
        f_d2_ds2_str = obj.Output_CPP_Var_Name('d2_ds2');
        GD = obj.GeoMap.GeoDim;
        MAT_DxD_str = ['MAT_', num2str(GD), 'x', num2str(GD)];
        
        Tangent_Vector_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Tangent_Vector');
        Curv_Vector_CPP_Name    = obj.GeoMap.Output_CPP_Var_Name('Total_Curvature_Vector');
        Tangent_Vector_QP_str = ['Mesh->', Tangent_Vector_CPP_Name, QP_str];
        Curv_Vector_QP_str    = ['Mesh->', Curv_Vector_CPP_Name, QP_str];
        
        EVAL_STR(3).line = [TAB, MAT_DxD_str, '  tan_otimes_tan; // compute tensor product of tangent vector'];
        EVAL_STR(4).line = [TAB, 'Outer_Product_Vec(', Tangent_Vector_QP_str, ', ',...
                                  Tangent_Vector_QP_str, ', tan_otimes_tan', ');'];
        EVAL_STR(5).line = [TAB, '// set the hessian matrix with [vt x vt] d^2/ds^2, where vt is the tangent vector'];
        SYMM_TERM = ['Scalar_Mult_Matrix(', 'tan_otimes_tan', ', ',...
                      f_d2_ds2_str, '[basis_i][qp_i]', ', ', f_Hess_str, '[basis_i][qp_i]', ');'];
        EVAL_STR(6).line = [TAB, SYMM_TERM];
        if ~CONST_JAC % map is non-linear, then need the more general formula
            EVAL_STR( 7).line = [TAB, '// map is non-linear, so substract [vk x vt] d/ds, where vk is the curvature vector'];
            EVAL_STR( 8).line = [TAB, MAT_DxD_str, '  curv_otimes_tan; // compute tensor product of tangent vector with curvature vector'];
            EVAL_STR( 9).line = [TAB, 'Outer_Product_Vec(', Curv_Vector_QP_str, ', ',...
                                      Tangent_Vector_QP_str, ', curv_otimes_tan', ');'];
            EVAL_STR(10).line = [TAB, MAT_DxD_str, '  non_symm_term; // temp variable'];
            NONSYMM_TERM = ['Scalar_Mult_Matrix(', 'curv_otimes_tan', ', ',...
                             f_d_ds_str, '[basis_i][qp_i]', ', ', 'non_symm_term', ');'];
            EVAL_STR(11).line = [TAB, NONSYMM_TERM];
            EVAL_STR(12).line = [TAB, '// compute difference: [vt x vt] d^2/ds^2 - [vk x vt] d/ds'];
            DIFF_TERM = ['Subtract_Matrix(', f_Hess_str, '[basis_i][qp_i]', ', ',...
                'non_symm_term', ', ', f_Hess_str, '[basis_i][qp_i]', ');'];
            EVAL_STR(13).line = [TAB, DIFF_TERM];
        end
    end
elseif (obj.GeoMap.TopDim==2) % reference domain is 2-D
    if (obj.GeoMap.GeoDim==2)
        f_Hess_Basis_Quad_str = [f_Hess_str, '[basis_i][qp_i]']; % output
        
        Inv_Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Grad');
        Inv_Grad_Quad_str = ['Mesh->', Inv_Grad_CPP_Name, QP_str];
        Hess_Inv_Map_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Hess_Inv_Map');
        Hess_Inv_Map_Quad_str = ['Mesh->', Hess_Inv_Map_CPP_Name, QP_str];
        % evaluate!
        EVAL_STR(3).line = [TAB, '// compute main part of formula'];
        EVAL_STR(4).line = [TAB, 'MAT_2x2  Temp_MAT;'];
        EVAL_STR(5).line = [TAB, 'Mat_Mat(', BF_Hess, ', ', Inv_Grad_Quad_str, ', Temp_MAT);'];
        EVAL_STR(6).line = [TAB, 'Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
        if ~CONST_JAC % map is non-linear, then need the more general formula
            EVAL_STR( 7).line = [TAB, '// map is non-linear, so compute other part of formula'];
            EVAL_STR( 8).line = [TAB, '// scale hessian(PHI^{-1}) by d/dx of basis function, and add'];
            EVAL_STR( 9).line = [TAB, Hess_Inv_Map_Quad_str, '.Extract_Comp_Matrix(0, Temp_MAT);'];
            EVAL_STR(10).line = [TAB, 'Scalar_Mult_Matrix(Temp_MAT, ', BF_D0, ', Temp_MAT);'];
            EVAL_STR(11).line = [TAB, 'Add_Matrix(', f_Hess_Basis_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
            
            EVAL_STR(12).line = [TAB, '// scale hessian(PHI^{-1}) by d/dy of basis function, and add'];
            EVAL_STR(13).line = [TAB, Hess_Inv_Map_Quad_str, '.Extract_Comp_Matrix(1, Temp_MAT);'];
            EVAL_STR(14).line = [TAB, 'Scalar_Mult_Matrix(Temp_MAT, ', BF_D1, ', Temp_MAT);'];
            EVAL_STR(15).line = [TAB, 'Add_Matrix(', f_Hess_Basis_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
        end
    elseif (obj.GeoMap.GeoDim==3) % surface in 3-D
        
        f_Hess_Basis_Quad_str = [f_Hess_str, '[basis_i][qp_i]']; % output
        
        Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad');
        Grad_Quad_str = ['Mesh->', Grad_CPP_Name, QP_str];
        Inv_Metric_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Metric');
        Inv_Metric_Quad_str = ['Mesh->', Inv_Metric_CPP_Name, QP_str];
        PHI_Christoffel_2nd_Kind_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Christoffel_2nd_Kind');
        PHI_Christoffel_2nd_Kind_Quad_str = ['Mesh->', PHI_Christoffel_2nd_Kind_CPP_Name, QP_str];
        % evaluate!
        EVAL_STR( 3).line = [TAB, 'MAT_2x2  temp_hess_MAT(', BF_Hess, '); // init to hess(phi)'];
        if ~CONST_JAC % map is non-linear, then need the more general formula
            EVAL_STR( 4).line = [TAB, '// compute the Christoffel correction'];
            EVAL_STR( 5).line = [TAB, 'MAT_2x2  Christoffel_Gamma_k; // \\Gamma^k_{i,j}, k = 0, 1'];
            EVAL_STR( 6).line = [TAB, PHI_Christoffel_2nd_Kind_Quad_str, '.Extract_Comp_Matrix(0, Christoffel_Gamma_k);'];
            EVAL_STR( 7).line = [TAB, '// multiply by basis function derivative'];
            EVAL_STR( 8).line = [TAB, 'Scalar_Mult_Matrix (Christoffel_Gamma_k, ', BF_Grad, '.v[0]', ', Christoffel_Gamma_k);'];
            EVAL_STR( 9).line = [TAB, 'Subtract_Matrix(temp_hess_MAT, Christoffel_Gamma_k, temp_hess_MAT);'];
            EVAL_STR(10).line = [TAB, PHI_Christoffel_2nd_Kind_Quad_str, '.Extract_Comp_Matrix(1, Christoffel_Gamma_k);'];
            EVAL_STR(11).line = [TAB, '// multiply by basis function derivative'];
            EVAL_STR(12).line = [TAB, 'Scalar_Mult_Matrix (Christoffel_Gamma_k, ', BF_Grad, '.v[1]', ', Christoffel_Gamma_k);'];
            EVAL_STR(13).line = [TAB, 'Subtract_Matrix(temp_hess_MAT, Christoffel_Gamma_k, temp_hess_MAT);'];
        end
        Num_line = length(EVAL_STR);
        EVAL_STR(Num_line+1).line = [TAB, 'MAT_3x2  sub_MAT, J_g_inv_MAT;'];
        EVAL_STR(Num_line+2).line = [TAB, '// multiply: (Grad(PHI)) * g^{-1}'];
        EVAL_STR(Num_line+3).line = [TAB, 'Mat_Mat(', Grad_Quad_str, ', ', Inv_Metric_Quad_str, ', J_g_inv_MAT);'];
        EVAL_STR(Num_line+4).line = [TAB, '// multiply: [(Grad(PHI)) * g^{-1}] [local hess(f)] [(Grad(PHI)) * g^{-1}]^T'];
        EVAL_STR(Num_line+5).line = [TAB, 'Mat_Mat(J_g_inv_MAT, temp_hess_MAT, sub_MAT);'];
        EVAL_STR(Num_line+6).line = [TAB, 'Mat_Mat_Transpose(sub_MAT, J_g_inv_MAT, ' , f_Hess_Basis_Quad_str, ');'];
        
        % this code correctly implements the WRONG formula!
%         f_Hess_Basis_Quad_str = [f_Hess_str, '[basis_i][qp_i]']; % output
%         
%         Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad');
%         Grad_Quad_str = ['Mesh->', Grad_CPP_Name, QP_str];
%         Inv_Metric_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Metric');
%         Inv_Metric_Quad_str = ['Mesh->', Inv_Metric_CPP_Name, QP_str];
%         Grad_Inv_Metric_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Grad_Inv_Metric');
%         Grad_Inv_Metric_Quad_str = ['Mesh->', Grad_Inv_Metric_CPP_Name, QP_str];
%         Hess_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Hess');
%         Hess_Quad_str = ['Mesh->', Hess_CPP_Name, QP_str];
%         % evaluate!
%         TAB2 = [TAB, TAB];
%         TAB3 = [TAB, TAB, TAB];
%         EVAL_STR(3).line = [TAB, '// compute: nabla^2 f = {nabla_s [ (nabla_s vX) g^{-1} (nabla_s f)^t ]} g^{-1} (nabla_s vX)^t'];
%         EVAL_STR(4).line = [TAB, 'MAT_3x2  sub_MAT, temp_hess_MAT; // sub-matrix and temporary'];
%         EVAL_STR(5).line = [TAB, 'for (unsigned int kk = 0; (kk < 3); kk++)'];
%         EVAL_STR(6).line = [TAB, 'for (unsigned int rr = 0; (rr < 2); rr++)'];
%         EVAL_STR(7).line = [TAB2, '{'];
%         EVAL_STR(8).line = [TAB2, '// compute entry of sub-matrix'];
%         if ~CONST_JAC % map is non-linear, then need the more general formula
%             EVAL_STR( 9).line = [TAB2, 'double VAL_A = 0.0;'];
%             EVAL_STR(10).line = [TAB2, 'double VAL_B = 0.0;'];
%             EVAL_STR(11).line = [TAB2, 'for (unsigned int ii = 0; (ii < 2); ii++)'];
%             EVAL_STR(12).line = [TAB2, 'for (unsigned int jj = 0; (jj < 2); jj++)'];
%             EVAL_STR(13).line = [TAB3, '{'];
%             EVAL_STR(14).line = [TAB3, 'VAL_A += ', Grad_Quad_str, '.m[kk][ii] * ', Inv_Metric_Quad_str, '.m[ii][jj] * ',...
%                                        BF_Hess, '.m[rr][jj];'];
%             EVAL_STR(15).line = [TAB3, 'VAL_B += ( (', Hess_Quad_str, '.m[kk][rr][ii] * ', Inv_Metric_Quad_str, '.m[ii][jj]) + (',...
%                                        Grad_Quad_str, '.m[kk][ii] * ', Grad_Inv_Metric_Quad_str, '.m[rr][ii][jj]) )',...
%                                        ' * ', BF_Grad, '.v[jj]; // this term needed because map is non-linear'];
%             EVAL_STR(16).line = [TAB3, '}'];
%             EVAL_STR(17).line = [TAB2, 'sub_MAT.m[kk][rr] = VAL_A + VAL_B;'];
%         else
%             % use simpler formula
%             EVAL_STR( 9).line = [TAB2, 'double VAL_entry = 0.0;'];
%             EVAL_STR(10).line = [TAB2, 'for (unsigned int ii = 0; (ii < 2); ii++)'];
%             EVAL_STR(11).line = [TAB2, 'for (unsigned int jj = 0; (jj < 2); jj++)'];
%             EVAL_STR(12).line = [TAB3, '{'];
%             EVAL_STR(13).line = [TAB3, 'VAL_entry += ', Grad_Quad_str, '.m[kk][ii] * ', Inv_Metric_Quad_str, '.m[ii][jj] * ',...
%                                        BF_Hess, '.m[rr][jj];'];
%             EVAL_STR(14).line = [TAB3, '}'];
%             EVAL_STR(15).line = [TAB2, 'sub_MAT.m[kk][rr] = VAL_entry;'];
%         end
%         Num_line = length(EVAL_STR);
%         EVAL_STR(Num_line+1).line = [TAB2, '}'];
%         EVAL_STR(Num_line+2).line = [TAB, '// multiply: (sub-matrix) * g^{-1} * (Grad(PHI))^t'];
%         EVAL_STR(Num_line+3).line = [TAB, 'Mat_Mat(sub_MAT, ', Inv_Metric_Quad_str, ', temp_hess_MAT);'];
%         EVAL_STR(Num_line+4).line = [TAB, 'Mat_Mat_Transpose(temp_hess_MAT, ', Grad_Quad_str, ', ', f_Hess_Basis_Quad_str, ');'];
    else
        error('Invalid!');
    end
elseif (obj.GeoMap.TopDim==3) % reference domain is 3-D
    if (obj.GeoMap.GeoDim==3) % this is the only valid option!
        Inv_Grad_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Inv_Grad');
        Inv_Grad_Quad_str = ['Mesh->', Inv_Grad_CPP_Name, QP_str];
        f_Hess_Basis_Quad_str = [f_Hess_str, '[basis_i][qp_i]'];
        Hess_Inv_Map_CPP_Name = obj.GeoMap.Output_CPP_Var_Name('Hess_Inv_Map');
        Hess_Inv_Map_Quad_str = ['Mesh->', Hess_Inv_Map_CPP_Name, QP_str];
        % evaluate!
        EVAL_STR(3).line = [TAB, '// compute main part of formula'];
        EVAL_STR(4).line = [TAB, 'MAT_3x3  Temp_MAT;'];
        EVAL_STR(5).line = [TAB, 'Mat_Mat(', BF_Hess, ', ', Inv_Grad_Quad_str, ', Temp_MAT);'];
        EVAL_STR(6).line = [TAB, 'Mat_Transpose_Mat(', Inv_Grad_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
        if ~CONST_JAC % map is non-linear, then need the more general formula
            EVAL_STR( 7).line = [TAB, '// map is non-linear, so compute other part of formula'];
            EVAL_STR( 8).line = [TAB, '// scale hessian(PHI^{-1}) by d/dx of basis function, and add'];
            EVAL_STR( 9).line = [TAB, Hess_Inv_Map_Quad_str, '.Extract_Comp_Matrix(0, Temp_MAT);'];
            EVAL_STR(10).line = [TAB, 'Scalar_Mult_Matrix(Temp_MAT, ', BF_D0, ', Temp_MAT);'];
            EVAL_STR(11).line = [TAB, 'Add_Matrix(', f_Hess_Basis_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
            
            EVAL_STR(12).line = [TAB, '// scale hessian(PHI^{-1}) by d/dy of basis function, and add'];
            EVAL_STR(13).line = [TAB, Hess_Inv_Map_Quad_str, '.Extract_Comp_Matrix(1, Temp_MAT);'];
            EVAL_STR(14).line = [TAB, 'Scalar_Mult_Matrix(Temp_MAT, ', BF_D1, ', Temp_MAT);'];
            EVAL_STR(15).line = [TAB, 'Add_Matrix(', f_Hess_Basis_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
            
            EVAL_STR(16).line = [TAB, '// scale hessian(PHI^{-1}) by d/dz of basis function, and add'];
            EVAL_STR(17).line = [TAB, Hess_Inv_Map_Quad_str, '.Extract_Comp_Matrix(2, Temp_MAT);'];
            EVAL_STR(18).line = [TAB, 'Scalar_Mult_Matrix(Temp_MAT, ', BF_D2, ', Temp_MAT);'];
            EVAL_STR(19).line = [TAB, 'Add_Matrix(', f_Hess_Basis_Quad_str, ', Temp_MAT, ', f_Hess_Basis_Quad_str, ');'];
        end
    else
        error('Invalid!');
    end
end
EVAL_STR(length(EVAL_STR)+1).line = [TAB, '}']; % close the basis loop

% define the data type
TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.GeoMap.GeoDim,obj.GeoMap.GeoDim);
Defn_Hdr = '// hessian of basis function';
Loop_Hdr = '// map hessian from local to global coordinates (indexing is in the C style)';
Loop_Comment = '// formula involves factors of the inverse of the jacobian (or metric) of PHI';
CONST_VAR = obj.Is_Quantity_Constant('Hess');
CODE = obj.create_basis_func_declaration_and_eval_code(f_Hess_str,TYPE_str,EVAL_STR,...
                             Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end