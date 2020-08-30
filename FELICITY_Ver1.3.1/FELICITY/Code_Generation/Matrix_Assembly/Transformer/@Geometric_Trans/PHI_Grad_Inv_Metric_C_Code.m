function CODE = PHI_Grad_Inv_Metric_C_Code(obj)
%PHI_Grad_Inv_Metric_C_Code
%
%   Generate C-code for direct evaluation of
%                   PHI.Grad_Inv_Metric = \nabla [PHI.Metric]^{-1}.
%   PHI_Grad_Inv_Metric_r_ij(qp) = \partial_r ( [PHI_Metric]^{-1} )_{ij},
%                                  1 <= i,j <= GeoDim,
%                                  and qp are the coordinates of a quadrature point.
%   Note: PHI.Metric must be a square matrix.

% Copyright (c) 08-11-2014,  Shawn W. Walker

if ~isempty(obj.PHI.Grad_Inv_Metric) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Grad_Inv_Metric');

    % make a reference for the data evaluated at a quad point
    CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    % evaluate at the given matrix entry index
    PHI_Grad_Inv_Metric_Tensor_str = [CPP_REF_Var_str];
    
    % need the grad(metric) tensor
    Map_PHI_Grad_Metric_str = obj.Output_CPP_Var_Name('Grad_Metric');
    Map_PHI_Grad_Metric_Eval_str = [Map_PHI_Grad_Metric_str, '[qp_i]'];
    % need the inverse metric
    Map_PHI_Inv_Metric_str = obj.Output_CPP_Var_Name('Inv_Metric');
    Map_PHI_Inv_Metric_Eval_str = [Map_PHI_Inv_Metric_str, '[qp_i]'];
    
    CONST_Metric = obj.Lin_PHI_TF;
    if ~CONST_Metric % metric is not constant
        
        EVAL_STR(7).line = []; % init
        EVAL_STR(1).line = '// compute d/ds_0 (Metric^{-1})';
        EVAL_STR(2).line = 'MAT_2x2  GM_MAT_A, GM_MAT_B;';
        EVAL_STR(3).line = [Map_PHI_Grad_Metric_Eval_str, '.Extract_Comp_Matrix(0, GM_MAT_A);'];
        EVAL_STR(4).line = ['Mat_Mat(GM_MAT_A, ', Map_PHI_Inv_Metric_Eval_str, ', GM_MAT_B);'];
        EVAL_STR(5).line = ['Mat_Transpose_Mat(', Map_PHI_Inv_Metric_Eval_str, ', GM_MAT_B, GM_MAT_A);'];
        EVAL_STR(6).line = ['Scalar_Mult_Matrix(GM_MAT_A, -1.0, GM_MAT_A);'];
        EVAL_STR(7).line = [PHI_Grad_Inv_Metric_Tensor_str, '.Set_Comp_Matrix(0, GM_MAT_A);'];
        
        if (obj.TopDim==2)
            % do next component
            EVAL_STR( 8).line = '// compute d/ds_1 (Metric^{-1})';
            EVAL_STR( 9).line = [Map_PHI_Grad_Metric_Eval_str, '.Extract_Comp_Matrix(1, GM_MAT_A);'];
            EVAL_STR(10).line = ['Mat_Mat(GM_MAT_A, ', Map_PHI_Inv_Metric_Eval_str, ', GM_MAT_B);'];
            EVAL_STR(11).line = ['Mat_Transpose_Mat(', Map_PHI_Inv_Metric_Eval_str, ', GM_MAT_B, GM_MAT_A);'];
            EVAL_STR(12).line = ['Scalar_Mult_Matrix(GM_MAT_A, -1.0, GM_MAT_A);'];
            EVAL_STR(13).line = [PHI_Grad_Inv_Metric_Tensor_str, '.Set_Comp_Matrix(1, GM_MAT_A);'];
        end
    else
        % map is linear, so metric is constant
        EVAL_STR(1).line = [PHI_Grad_Inv_Metric_Tensor_str, '.Set_To_Zero(); // inverse metric is constant, so gradient is zero'];
    end
    
    % define the data type
    SIZE = size(obj.PHI.Grad_Inv_Metric,1);
    TYPE_str = obj.Get_CPP_Tensor_Data_Type_Name(SIZE,SIZE,SIZE);
    Defn_Hdr = '// gradient (in local coordinates) of inverse of the Metric tensor';
    Loop_Hdr = '// compute gradient of inverse of the Metric tensor';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    CODE = [];
end

end