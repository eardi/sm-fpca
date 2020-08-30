function CODE = PHI_Grad_Metric_C_Code(obj)
%PHI_Grad_Metric_C_Code
%
%   Generate C-code for direct evaluation of PHI.Grad_Metric.
%      PHI_Grad_Metric_r_ij(qp) =
%                      \partial_r  SUM^GeoDim_{k=1} PHI_Grad_ki(qp) * PHI_Grad_kj(qp),
%                      1 <= i,j <= TopDim,
%                      and qp are the coordinates of a quadrature point.

% Copyright (c) 08-11-2014,  Shawn W. Walker

if ~isempty(obj.PHI.Grad_Metric) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Grad_Metric');
    
    % make a reference for the data evaluated at a quad point
    CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    % evaluate at the given tensor entry index
    PHI_Grad_Metric_Tensor_str = [CPP_REF_Var_str];
    
    % need the gradient of the map!
    Map_PHI_Grad_str = obj.Output_CPP_Var_Name('Grad');
    Map_PHI_Grad_Matrix_str = [Map_PHI_Grad_str, '[qp_i]'];
    % need the hessian of the map!
    Map_PHI_Hess_str = obj.Output_CPP_Var_Name('Hess');
    Map_PHI_Hess_Tensor_str = [Map_PHI_Hess_str, '[qp_i]'];
    
    GD = obj.GeoDim;
    CONST_Metric = obj.Lin_PHI_TF;
    if ~CONST_Metric % metric is not constant
        % evaluate!
        if (obj.TopDim==1)
            EVAL_STR(3).line = []; % init
            EVAL_STR(1).line = '// compute 2 * d^2/ds^2 vX DOT d/ds vX';
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,1,1,1);
            EVAL_STR(2).line = ['const double HG_DP = ', DP_str, ';'];
            LHS = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,1,1,1);
            EVAL_STR(3).line = [LHS, ' = 2.0 * HG_DP;'];
        elseif (obj.TopDim==2)
            EVAL_STR(16).line = []; % init
            EVAL_STR(1).line = '// compute d/ds_r d/ds_i vX DOT d/ds_j vX + d/ds_r d/ds_j vX DOT d/ds_i vX';
            EVAL_STR(2).line = 'double HG_DP_A;';
            % component: 1,1,1
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,1,1,1);
            EVAL_STR(3).line = ['HG_DP_A = ', DP_str, ';'];
            LHS_111 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,1,1,1);
            EVAL_STR(4).line = [LHS_111, ' = 2.0 * HG_DP_A;'];
            % component: 1,2,2
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,1,2,2);
            EVAL_STR(5).line = ['HG_DP_A = ', DP_str, ';'];
            LHS_122 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,1,2,2);
            EVAL_STR(6).line = [LHS_122, ' = 2.0 * HG_DP_A;'];
            % component: 2,1,1
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,2,1,1);
            EVAL_STR(7).line = ['HG_DP_A = ', DP_str, ';'];
            LHS_211 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,2,1,1);
            EVAL_STR(8).line = [LHS_211, ' = 2.0 * HG_DP_A;'];
            % component: 2,2,2
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,2,2,2);
            EVAL_STR(9).line = ['HG_DP_A = ', DP_str, ';'];
            LHS_222 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,2,2,2);
            EVAL_STR(10).line = [LHS_222, ' = 2.0 * HG_DP_A;'];
            
            % component: 1,1,2
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,1,1,2);
            EVAL_STR(11).line = ['HG_DP_A = ', DP_str, ';'];
            LHS_112 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,1,1,2);
            EVAL_STR(12).line = [LHS_112, ' = HG_DP_A + ', '0.5*', LHS_211, '; // reuse!'];
            % component: 1,2,1
            LHS_121 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,1,2,1);
            EVAL_STR(13).line = [LHS_121, ' = ', LHS_112, '; // symmetric'];
            % component: 2,2,1
            DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,2,2,1);
            EVAL_STR(14).line = ['HG_DP_A = ', DP_str, ';'];
            LHS_221 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,2,2,1);
            EVAL_STR(15).line = [LHS_221, ' = HG_DP_A + ', '0.5*', LHS_122, '; // reuse!'];
            % component: 2,1,2
            LHS_212 = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,2,1,2);
            EVAL_STR(16).line = [LHS_212, ' = ', LHS_221, '; // symmetric'];
        else
            error('Invalid!');
        end
    else
        % map is linear, so metric is constant
        EVAL_STR(1).line = [PHI_Grad_Metric_Tensor_str, '.Set_To_Zero(); // metric is constant, so gradient is zero'];
    end
    
    % define the data type
    SIZE = size(obj.PHI.Grad_Metric,1);
    TYPE_str = obj.Get_CPP_Tensor_Data_Type_Name(SIZE,SIZE,SIZE);
    Defn_Hdr = '// gradient (in local coordinates) of the metric tensor of the map';
    Loop_Hdr = '// compute gradient of metric tensor';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
else
    CODE = [];
end

end

function DP_str = get_dot_product_str(GD,Map_PHI_Hess_Tensor_str,Map_PHI_Grad_Matrix_str,r,i,j)

r_str = ['[', num2str(r-1), ']'];
i_str = ['[', num2str(i-1), ']'];
j_str = ['[', num2str(j-1), ']'];
DP0_str = [Map_PHI_Hess_Tensor_str, '.m[0]', r_str, i_str, ' * ', Map_PHI_Grad_Matrix_str, '.m[0]', j_str];
DP1_str = [Map_PHI_Hess_Tensor_str, '.m[1]', r_str, i_str, ' * ', Map_PHI_Grad_Matrix_str, '.m[1]', j_str];
DP2_str = [Map_PHI_Hess_Tensor_str, '.m[2]', r_str, i_str, ' * ', Map_PHI_Grad_Matrix_str, '.m[2]', j_str];
if (GD==1)
    DP_str = DP0_str;
elseif (GD==2)
    DP_str = [DP0_str, ' + ', DP1_str];
elseif (GD==3)
    DP_str = [DP0_str, ' + ', DP1_str, ' + ', DP2_str];
else
    error('Invalid!');
end

end

function STR = get_grad_metric_eval_str(PHI_Grad_Metric_Tensor_str,r,i,j)

r_str = ['[', num2str(r-1), ']'];
i_str = ['[', num2str(i-1), ']'];
j_str = ['[', num2str(j-1), ']'];

STR = [PHI_Grad_Metric_Tensor_str, '.m', r_str, i_str, j_str];

end