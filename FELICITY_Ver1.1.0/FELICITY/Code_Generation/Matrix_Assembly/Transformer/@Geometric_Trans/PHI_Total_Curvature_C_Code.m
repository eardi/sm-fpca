function CODE = PHI_Total_Curvature_C_Code(obj)
%PHI_Total_Curvature_C_Code
%
%   Generate C-code for direct evaluation of PHI.Total_Curvature.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Total_Curvature)
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Total_Curvature');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Total_Curv_Eval_str = [CODE.Var_Name(1).line, '_qp_i'];
end

if (obj.GeoDim==1)
    CODE = [];
elseif (obj.GeoDim==2)
    if (obj.TopDim==1)
        % need the 2nd Fund Form
        Map_Form2_str = obj.Output_CPP_Var_Name('Second_Fund_Form');
        Map_Form2_Eval_str = [Map_Form2_str, '[qp_i]'];
        % need the inverse metric
        Map_Inv_Metric_str = obj.Output_CPP_Var_Name('Inv_Metric');
        Map_Inv_Metric_Eval_str = [Map_Inv_Metric_str, '[qp_i]'];
        
        if ~obj.Lin_PHI_TF % map is non-linear
            % call a function to compute the total curvature
            EVAL_STR(1).line = []; % init
            %Compute_Total_Curvature (const MAT_1x1& Form_2nd, const MAT_1x1& Inv_Metric, SCALAR& Total_Curv)
            EVAL_STR(1).line = ['Compute_Total_Curvature(', Map_Form2_Eval_str, ', ',...
                                 Map_Inv_Metric_Eval_str, ', ', Map_PHI_Total_Curv_Eval_str, ');'];
        else % the map is linear, so the curvature is ZERO!
            EVAL_STR(1).line = []; % init
            EVAL_STR(1).line = [Map_PHI_Total_Curv_Eval_str, '.a', ' = 0.0;'];
        end

    elseif (obj.TopDim==2)
        CODE = [];
    else
        error('Not valid!');
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==1)
        % need the curvature vector
        Map_CV_str = obj.Output_CPP_Var_Name('Total_Curvature_Vector');
        Map_CV_Eval_str = [Map_CV_str, '[qp_i]'];

        if ~obj.Lin_PHI_TF % map is non-linear
            % call a function to compute the total curvature
            EVAL_STR(1).line = []; % init
            %Compute_Total_Curvature (const double CV[3], double& Curv)
            EVAL_STR(1).line = ['Compute_Total_Curvature(', Map_CV_Eval_str,...
                                ', ', Map_PHI_Total_Curv_Eval_str, ');'];
        else % the map is linear, so the curvature is ZERO!
            EVAL_STR(1).line = []; % init
            EVAL_STR(1).line = [Map_PHI_Total_Curv_Eval_str, '.a', ' = 0.0;'];
        end

    elseif (obj.TopDim==2)
        % need the 2nd Fund Form
        Map_Form2_str = obj.Output_CPP_Var_Name('Second_Fund_Form');
        Map_Form2_Eval_str = [Map_Form2_str, '[qp_i]'];
        % need the inverse metric
        Map_Inv_Metric_str = obj.Output_CPP_Var_Name('Inv_Metric');
        Map_Inv_Metric_Eval_str = [Map_Inv_Metric_str, '[qp_i]'];
        
        if ~obj.Lin_PHI_TF % map is non-linear
            % call a function to compute the total curvature
            EVAL_STR(1).line = []; % init
            %Compute_Total_Curvature (const double Form_2nd[2][2], const double Inv_Metric[2][2],
            %                         double& Total_Curv)
            EVAL_STR(1).line = ['Compute_Total_Curvature(', Map_Form2_Eval_str, ', ',...
                                 Map_Inv_Metric_Eval_str, ', ', Map_PHI_Total_Curv_Eval_str, ');'];
        else % the map is linear, so the curvature is ZERO!
            EVAL_STR(1).line = []; % init
            EVAL_STR(1).line = [Map_PHI_Total_Curv_Eval_str, '.a', ' = 0.0;'];
        end

    elseif (obj.TopDim==3)
        CODE = [];
    else
        error('Not valid!');
    end
else
    error('Not implemented!');
end

if ~isempty(CODE)
    
    % define the data type
    TYPE_str = obj.Get_CPP_Scalar_Data_Type_Name;
    Defn_Hdr = '// total curvature of the manifold';
    Loop_Hdr = '// compute the total curvature of the manifold';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
end

end