function CODE = PHI_Metric_C_Code(obj)
%PHI_Metric_C_Code
%
%   Generate C-code for direct evaluation of PHI.Metric.
%      PHI_Metric_ij(qp) = SUM^GeoDim_{k=1} PHI_Grad_ki(qp) * PHI_Grad_kj(qp),
%                          1 <= i,j <= TopDim,
%                          and qp are the coordinates of a quadrature point.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Metric) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Metric');
    
    % make a reference for the data evaluated at a quad point
    CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    % evaluate at the given matrix entry index
    PHI_Metric_Matrix_str = [CPP_REF_Var_str];

    % need the gradient of the map!
    Map_PHI_Grad_str = obj.Output_CPP_Var_Name('Grad');
    Map_PHI_Grad_Matrix_str = [Map_PHI_Grad_str, '[qp_i]'];
    % call a function to compute the metric tensor
    EVAL_STR(1).line = []; % init
    EVAL_STR(1).line = ['Mat_Transpose_Mat_Self(', Map_PHI_Grad_Matrix_str, ', ', PHI_Metric_Matrix_str, ');'];
    
    % define the data type
    SIZE = size(obj.PHI.Metric,1);
    TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(SIZE,SIZE);
    Defn_Hdr = '// metric tensor of the map';
    Loop_Hdr = '// compute metric tensor from jacobian matrix';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
else
    CODE = [];
end

end