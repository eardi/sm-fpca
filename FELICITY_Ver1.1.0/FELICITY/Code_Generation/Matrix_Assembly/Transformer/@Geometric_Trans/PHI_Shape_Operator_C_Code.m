function CODE = PHI_Shape_Operator_C_Code(obj)
%PHI_Shape_Operator_C_Code
%
%   Generate C-code for direct evaluation of
%                   PHI.Shape_Operator = \nabla_\Gamma \vn (surface in 3-D)
%                                      = [\vt \otimes \vt] \kappa (space curve)
%   PHI_Shape_Operator_ij(qp) = (\nabla_{s_1,s_2} \vn_i) g^{-1} (\nabla_{s_1,s_2} \vX_j)\tp,
%                               1 <= i,j <= GeoDim,
%                               and qp are the coordinates of a quadrature point.

% Copyright (c) 08-17-2014,  Shawn W. Walker

if ~isempty(obj.PHI.Shape_Operator) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Shape_Operator');
    % make a reference for the data evaluated at a quad point
    Map_PHI_Shape_Operator_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    
    if and(obj.TopDim==1,obj.GeoDim > 1) % 2-D or 3-D space curve
        
        % need the tangent vector
        Map_Tangent_Vec_str = obj.Output_CPP_Var_Name('Tangent_Vector');
        Map_Tangent_Vec_Eval_str = [Map_Tangent_Vec_str, '[qp_i]'];
        % need the curvature
        Map_Curv_str = obj.Output_CPP_Var_Name('Total_Curvature');
        Map_Curv_Eval_str = [Map_Curv_str, '[qp_i]'];
        
        CONST_Tangent = obj.Lin_PHI_TF;
        if ~CONST_Tangent % tangent vector is not constant, so shape operator is not zero
            
            EVAL_STR(4).line = []; % init
            EVAL_STR(1).line = '// compute kappa * [vt x vt],';
            EVAL_STR(2).line = '//     where kappa is the scalar curvature, and vt is the tangent vector.';
            EVAL_STR(3).line = ['Outer_Product_Vec(', Map_Tangent_Vec_Eval_str, ', ',...
                                                      Map_Tangent_Vec_Eval_str, ', ', Map_PHI_Shape_Operator_str, ');'];
            EVAL_STR(4).line = ['Scalar_Mult_Matrix(', Map_PHI_Shape_Operator_str, ', ', Map_Curv_Eval_str, ', ',...
                                                       Map_PHI_Shape_Operator_str, ');'];
        else
            % map is linear, so curvature is zero
            EVAL_STR(1).line = [Map_PHI_Shape_Operator_str, '.Set_To_Zero(); // curvature is zero, so shape operator is zero'];
        end
    elseif and(obj.TopDim==2,obj.GeoDim==3) % surface in 3-D
        
        % need the gradient of the map
        Map_Grad_str = obj.Output_CPP_Var_Name('Grad');
        Map_Grad_Eval_str = [Map_Grad_str, '[qp_i]'];
        % need the hessian of the map
        Map_Hess_str = obj.Output_CPP_Var_Name('Hess');
        Map_Hess_Eval_str = [Map_Hess_str, '[qp_i]'];
        % need the normal vector
        Map_Normal_Vec_str = obj.Output_CPP_Var_Name('Normal_Vector');
        Map_Normal_Vec_Eval_str = [Map_Normal_Vec_str, '[qp_i]'];
        % need the grad(metric) tensor
        Map_PHI_Grad_Metric_str = obj.Output_CPP_Var_Name('Grad_Metric');
        Map_PHI_Grad_Metric_Eval_str = [Map_PHI_Grad_Metric_str, '[qp_i]'];
        % need the inverse metric
        Map_PHI_Inv_Metric_str = obj.Output_CPP_Var_Name('Inv_Metric');
        Map_PHI_Inv_Metric_Eval_str = [Map_PHI_Inv_Metric_str, '[qp_i]'];
        % need the inverse of the determinant of the Jacobian (i.e. 1/sqrt(det Metric))
        Map_PHI_Inv_Det_Jac_str = obj.Output_CPP_Var_Name('Inv_Det_Jacobian');
        Map_PHI_Inv_Det_Jac_Eval_str = [Map_PHI_Inv_Det_Jac_str, '[qp_i]'];
        
        CONST_Normal = obj.Lin_PHI_TF;
        if ~CONST_Normal % normal vector is not constant, so shape operator is not zero
            
            EVAL_STR(37).line = []; % init
            EVAL_STR( 1).line = '// break up gradient matrix';
            EVAL_STR( 2).line = 'VEC_3x1  ds_0_grad_map, ds_1_grad_map;';
            EVAL_STR( 3).line = ['Split_Matrix(', Map_Grad_Eval_str, ', ds_0_grad_map, ds_1_grad_map);'];
            EVAL_STR( 4).line = '// scale by inverse jacobian';
            EVAL_STR( 5).line = ['Scalar_Mult_Vector(ds_0_grad_map,', Map_PHI_Inv_Det_Jac_Eval_str, ',ds_0_grad_map);'];
            EVAL_STR( 6).line = ['Scalar_Mult_Vector(ds_1_grad_map,', Map_PHI_Inv_Det_Jac_Eval_str, ',ds_1_grad_map);'];
            EVAL_STR( 7).line = '// compute cross-product matrices';
            EVAL_STR( 8).line = 'MAT_3x3  ds_0_ds_0_cross_mat, ds_0_ds_1_cross_mat, ds_1_ds_1_cross_mat;';
            EVAL_STR( 9).line = ['ds_0_ds_0_cross_mat.Set_Cross_Product(', Map_Hess_Eval_str, '.m[0][0][0]',...
                                                                    ', ', Map_Hess_Eval_str, '.m[1][0][0]',...
                                                                    ', ', Map_Hess_Eval_str, '.m[2][0][0]', ');'];
            EVAL_STR(10).line = ['ds_0_ds_1_cross_mat.Set_Cross_Product(', Map_Hess_Eval_str, '.m[0][0][1]',...
                                                                    ', ', Map_Hess_Eval_str, '.m[1][0][1]',...
                                                                    ', ', Map_Hess_Eval_str, '.m[2][0][1]', ');'];
            EVAL_STR(11).line = ['ds_1_ds_1_cross_mat.Set_Cross_Product(', Map_Hess_Eval_str, '.m[0][1][1]',...
                                                                    ', ', Map_Hess_Eval_str, '.m[1][1][1]',...
                                                                    ', ', Map_Hess_Eval_str, '.m[2][1][1]', ');'];
            EVAL_STR(12).line = 'VEC_3x1  SO_vec_A, SO_vec_B;';
            EVAL_STR(13).line = '// compute d/ds_0 of the normal vector';
            EVAL_STR(14).line = 'Mat_Vec(ds_0_ds_0_cross_mat, ds_1_grad_map, SO_vec_A);';
            EVAL_STR(15).line = 'Mat_Vec(ds_0_ds_1_cross_mat, ds_0_grad_map, SO_vec_B);';
            EVAL_STR(16).line = 'VEC_3x1  ds_0_normal_vec;';
            EVAL_STR(17).line = 'Subtract_Vector(SO_vec_A, SO_vec_B, ds_0_normal_vec);';
            EVAL_STR(18).line = 'MAT_2x2  GM_MAT, SO_MAT;';
            EVAL_STR(19).line = [Map_PHI_Grad_Metric_Eval_str, '.Extract_Comp_Matrix(0, GM_MAT);'];
            EVAL_STR(20).line = ['Mat_Mat(', Map_PHI_Inv_Metric_Eval_str, ', GM_MAT, SO_MAT);'];
            EVAL_STR(21).line = 'double  normal_vec_scale = 0.5 * Trace_Mat(SO_MAT);';
            EVAL_STR(22).line = ['Scalar_Mult_Vector(', Map_Normal_Vec_Eval_str, ', normal_vec_scale, SO_vec_B);'];
            EVAL_STR(23).line = 'Subtract_Vector(ds_0_normal_vec, SO_vec_B, ds_0_normal_vec);';
            
            EVAL_STR(24).line = '// compute d/ds_1 of the normal vector';
            EVAL_STR(25).line = 'Mat_Vec(ds_0_ds_1_cross_mat, ds_1_grad_map, SO_vec_A);';
            EVAL_STR(26).line = 'Mat_Vec(ds_1_ds_1_cross_mat, ds_0_grad_map, SO_vec_B);';
            EVAL_STR(27).line = 'VEC_3x1  ds_1_normal_vec;';
            EVAL_STR(28).line = 'Subtract_Vector(SO_vec_A, SO_vec_B, ds_1_normal_vec);';
            EVAL_STR(29).line = [Map_PHI_Grad_Metric_Eval_str, '.Extract_Comp_Matrix(1, GM_MAT);'];
            EVAL_STR(30).line = ['Mat_Mat(', Map_PHI_Inv_Metric_Eval_str, ', GM_MAT, SO_MAT);'];
            EVAL_STR(31).line = 'normal_vec_scale = 0.5 * Trace_Mat(SO_MAT);';
            EVAL_STR(32).line = ['Scalar_Mult_Vector(', Map_Normal_Vec_Eval_str, ', normal_vec_scale, SO_vec_B);'];
            EVAL_STR(33).line = 'Subtract_Vector(ds_1_normal_vec, SO_vec_B, ds_1_normal_vec);';
            EVAL_STR(34).line = 'MAT_3x2  grad_normal_vec, temp_gnv_metric_inv;';
            EVAL_STR(35).line = 'Concatenate_Vectors(ds_0_normal_vec, ds_1_normal_vec, grad_normal_vec);';
            EVAL_STR(36).line = ['Mat_Mat(grad_normal_vec, ', Map_PHI_Inv_Metric_Eval_str, ', temp_gnv_metric_inv);'];
            EVAL_STR(37).line = ['Mat_Mat_Transpose(temp_gnv_metric_inv, ', Map_Grad_Eval_str, ', ', Map_PHI_Shape_Operator_str, ');'];
        else
            % map is linear, so normal vector is constant
            EVAL_STR(1).line = [Map_PHI_Shape_Operator_str, '.Set_To_Zero(); // normal vector is constant, so shape operator is zero'];
        end
    else
        error('Invalid!');
    end
    
    % define the data type
    TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(obj.GeoDim,obj.GeoDim);
    Defn_Hdr = '// the shape operator (in local coordinates)';
    Loop_Hdr = '// compute shape operator';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    CODE = [];
end

end