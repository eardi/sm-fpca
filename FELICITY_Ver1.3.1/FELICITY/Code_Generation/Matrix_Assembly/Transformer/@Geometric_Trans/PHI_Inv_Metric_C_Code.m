function CODE = PHI_Inv_Metric_C_Code(obj)
%PHI_Inv_Metric_C_Code
%
%   Generate C-code for direct evaluation of PHI.Inv_Metric = [PHI.Metric]^{-1}.
%      PHI_Inv_Metric_ij(qp) = ( [PHI_Metric]^{-1} )_{ij}, 1 <= i,j <= GeoDim,
%                             and qp are the coordinates of a quadrature point.
%      Note: PHI.Metric must be a square matrix.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Inv_Metric) % if this concept exists!
    
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Inv_Metric');

    % make a reference for the data evaluated at a quad point
    CPP_REF_Var_str = obj.Get_Quad_Pt_CPP_Ref_Var_Name(CODE.Var_Name(1).line);
    % evaluate at the given matrix entry index
    PHI_Inv_Metric_Matrix_str = [CPP_REF_Var_str];
    
    % need the metric tensor
    Map_PHI_Metric_str = obj.Output_CPP_Var_Name('Metric');
    Map_PHI_Metric_Matrix_str = [Map_PHI_Metric_str, '[qp_i]'];
    % need the inverse det(metric)
    Map_PHI_Inv_Det_Metric_str = obj.Output_CPP_Var_Name('Inv_Det_Metric');
    Map_PHI_Inv_Det_Metric_Eval_str = [Map_PHI_Inv_Det_Metric_str, '[qp_i]'];
    
    % call a function to compute the inverse
    EVAL_STR(1).line = []; % init
    EVAL_STR(1).line = ['Matrix_Inverse(', Map_PHI_Metric_Matrix_str, ', ', Map_PHI_Inv_Det_Metric_Eval_str, ', ', ...
                        PHI_Inv_Metric_Matrix_str, ');'];

    % define the data type
    SIZE = size(obj.PHI.Inv_Metric,1);
    TYPE_str = obj.Get_CPP_Matrix_Data_Type_Name(SIZE,SIZE);
    Defn_Hdr = '// inverse of the Metric tensor';
    Loop_Hdr = '// compute inverse of the Metric tensor';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
    
else
    CODE = [];
end

end