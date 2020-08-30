function CODE = PHI_Gauss_Curvature_C_Code(obj)
%PHI_Gauss_Curvature_C_Code
%
%   Generate C-code for direct evaluation of PHI.Gauss_Curvature.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Gauss_Curvature)
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Gauss_Curvature');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Gauss_Curv_Eval_str = [CODE.Var_Name(1).line, '_qp_i.a'];
end

EVAL_STR(1).line = []; % init

if (obj.GeoDim==1)
    CODE = [];
elseif (obj.GeoDim==2)
    if (obj.TopDim==1)
        % the Gauss curvature is zero for a curve!
        EVAL_STR(1).line = [Map_PHI_Gauss_Curv_Eval_str, ' = 0.0;'];
    elseif (obj.TopDim==2)
        CODE = [];
    else
        error('Not valid!');
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==1)
        % the Gauss curvature is zero for a curve!
        EVAL_STR(1).line = [Map_PHI_Gauss_Curv_Eval_str, ' = 0.0;'];
    elseif (obj.TopDim==2)
        % need the det(2nd Fund Form)
        Map_Det_Form2_str = obj.Output_CPP_Var_Name('Det_Second_Fund_Form');
        Map_Det_Form2_Eval_str = [Map_Det_Form2_str, '[qp_i]', '.a'];
        % need the inverse of det(metric)
        Map_Inv_Det_Metric_str = obj.Output_CPP_Var_Name('Inv_Det_Metric');
        Map_Inv_Det_Metric_Eval_str = [Map_Inv_Det_Metric_str, '[qp_i]', '.a'];
        
        if ~obj.Lin_PHI_TF % map is non-linear
            %Map_Gauss_Curvature = Map_Det_Second_Fund_Form * Map_Inv_Det_Metric;
            EVAL_STR(1).line = [Map_PHI_Gauss_Curv_Eval_str, ' = ', Map_Det_Form2_Eval_str,...
                                ' * ', Map_Inv_Det_Metric_Eval_str, ';'];
        else % the map is linear, so the curvature is ZERO!
            EVAL_STR(1).line = [Map_PHI_Gauss_Curv_Eval_str, ' = 0.0;'];
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
    Defn_Hdr = '// Gauss curvature of the manifold';
    Loop_Hdr = '// compute the Gauss curvature of the local map: det(2nd Fund Form) / det(Metric)';
    Loop_Comment = [];
    CONST_VAR = obj.Lin_PHI_TF;
    CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                                Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
    %
end

end