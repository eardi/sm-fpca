function CODE = PHI_Total_Curvature_Vector_C_Code(obj)
%PHI_Total_Curvature_Vector_C_Code
%
%   Generate C-code for direct evaluation of PHI.Total_Curvature_Vector.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if ~isempty(obj.PHI.Total_Curvature_Vector)
    % make var string
    CODE.Var_Name(1).line = []; % init
    CODE.Var_Name(1).line = obj.Output_CPP_Var_Name('Total_Curvature_Vector');
    
    % make a reference for the data evaluated at a quad point
    Map_PHI_Curv_Vec_Eval_str = [CODE.Var_Name(1).line, '_qp_i'];
end

if (obj.TopDim==1) % a curve
    if (obj.GeoDim==1) % curvature vector does not make sense
        CODE = [];
        return;
    elseif (obj.GeoDim==2) % in the plane
        % need the normal vector
        Map_NV_str = obj.Output_CPP_Var_Name('Normal_Vector');
        Map_NV_Eval_str = [Map_NV_str, '[qp_i]'];
        % need the total curvature
        Map_Curv_str = obj.Output_CPP_Var_Name('Total_Curvature');
        Map_Curv_Eval_str = [Map_Curv_str, '[qp_i]'];

        if ~obj.Lin_PHI_TF % map is non-linear
            % call a function to compute the determinant
            EVAL_STR(1).line = []; % init
            %Compute_Total_Curvature_Vector (const VEC_2x1& NV, const SCALAR& Curv, VEC_2x1& CV)
            EVAL_STR(1).line = ['Compute_Total_Curvature_Vector(', Map_NV_Eval_str, ', ',...
                                 Map_Curv_Eval_str, ', ', Map_PHI_Curv_Vec_Eval_str, ');'];
        else % the map is linear, so the curvature is ZERO!
            EVAL_STR(2).line = []; % init
            EVAL_STR(1).line = [Map_PHI_Curv_Vec_Eval_str, '.v[0]', ' = 0.0;'];
            EVAL_STR(2).line = [Map_PHI_Curv_Vec_Eval_str, '.v[1]', ' = 0.0;'];
        end
    elseif (obj.GeoDim==3) % in \R^3
        % need the Hessian
        Map_Hess_str = obj.Output_CPP_Var_Name('Hess');
        Map_Hess_Eval_str = [Map_Hess_str, '[qp_i]'];
        % need the inverse metric
        Map_Inv_Metric_str = obj.Output_CPP_Var_Name('Inv_Metric');
        Map_Inv_Metric_Eval_str = [Map_Inv_Metric_str, '[qp_i]'];
        % need the tangent vector
        Map_TV_str = obj.Output_CPP_Var_Name('Tangent_Vector');
        Map_TV_Eval_str = [Map_TV_str, '[qp_i]'];

        if ~obj.Lin_PHI_TF % map is non-linear
            % call a function to compute the determinant
            EVAL_STR(1).line = []; % init
            %Compute_Total_Curvature_Vector (const MAT_3x1x1& Hess, const MAT_1x1& Inv_Metric,
            %                                const VEC_3x1& TV, VEC_3x1& CV)
            EVAL_STR(1).line = ['Compute_Total_Curvature_Vector(', Map_Hess_Eval_str, ', ',...
                                 Map_Inv_Metric_Eval_str, ', ', Map_TV_Eval_str, ', ', Map_PHI_Curv_Vec_Eval_str, ');'];
        else % the map is linear, so the curvature is ZERO!
            EVAL_STR(3).line = []; % init
            EVAL_STR(1).line = [Map_PHI_Curv_Vec_Eval_str, '.v[0]', ' = 0.0;'];
            EVAL_STR(2).line = [Map_PHI_Curv_Vec_Eval_str, '.v[1]', ' = 0.0;'];
            EVAL_STR(3).line = [Map_PHI_Curv_Vec_Eval_str, '.v[2]', ' = 0.0;'];
        end
    else
        error('Not implemented!');
    end

elseif and((obj.TopDim==2),(obj.GeoDim==3)) % a surface in \R^3
    
    % need the normal vector
    Map_NV_str = obj.Output_CPP_Var_Name('Normal_Vector');
    Map_NV_Eval_str = [Map_NV_str, '[qp_i]'];
    % need the total curvature
    Map_Curv_str = obj.Output_CPP_Var_Name('Total_Curvature');
    Map_Curv_Eval_str = [Map_Curv_str, '[qp_i]'];
    
    if ~obj.Lin_PHI_TF % map is non-linear
        % call a function to compute the determinant
        EVAL_STR(1).line = []; % init
        %Compute_Total_Curvature_Vector (const VEC_3x1& NV, const SCALAR& Curv, VEC_3x1& CV)
        EVAL_STR(1).line = ['Compute_Total_Curvature_Vector(', Map_NV_Eval_str, ', ',...
                             Map_Curv_Eval_str, ', ', Map_PHI_Curv_Vec_Eval_str, ');'];
    else % the map is linear, so the curvature is ZERO!
        EVAL_STR(3).line = []; % init
        EVAL_STR(1).line = [Map_PHI_Curv_Vec_Eval_str, '.v[0]', ' = 0.0;'];
        EVAL_STR(2).line = [Map_PHI_Curv_Vec_Eval_str, '.v[1]', ' = 0.0;'];
        EVAL_STR(3).line = [Map_PHI_Curv_Vec_Eval_str, '.v[2]', ' = 0.0;'];
    end
    
else % curvature vector does not make sense
    CODE = [];
    return;
end

% define the data type
TYPE_str = obj.Get_CPP_Vector_Data_Type_Name(obj.GeoDim);
Defn_Hdr = '// the total curvature vector of the manifold';
Loop_Hdr = '// compute total curvature vector';
Loop_Comment = [];
CONST_VAR = obj.Lin_PHI_TF;
CODE = obj.create_declaration_and_eval_code(CODE.Var_Name,TYPE_str,EVAL_STR,...
                                            Defn_Hdr,Loop_Hdr,Loop_Comment,CONST_VAR);
%
end