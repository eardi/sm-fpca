function CONST_TF = Is_Quantity_Constant(obj,FIELD_str)
%Is_Quantity_Constant
%
%   This outputs a boolean indicating if the given variable name is a CONSTANT
%   on a single element.

% Copyright (c) 04-03-2018,  Shawn W. Walker

if strcmp(FIELD_str,'Mesh_Size')
    CONST_TF = true; % always constant
elseif strcmp(FIELD_str,'Val')
    CONST_TF = false; % never constant
elseif strcmp(FIELD_str,'Grad')
    CONST_TF = obj.Lin_PHI_TF; % if the map is linear, then this variable is constant
elseif strcmp(FIELD_str,'Metric')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Det_Metric')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Inv_Det_Metric')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Inv_Metric')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Det_Jacobian')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Det_Jacobian_with_quad_weight')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Inv_Det_Jacobian')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Inv_Grad')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Tangent_Vector')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Normal_Vector')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Tangent_Space_Projection')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Hess')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Hess_Inv_Map')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Grad_Metric')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Grad_Inv_Metric')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Christoffel_2nd_Kind')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Second_Fund_Form')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Det_Second_Fund_Form')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Inv_Det_Second_Fund_Form')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Total_Curvature_Vector')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Total_Curvature')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Gauss_Curvature')
    CONST_TF = obj.Lin_PHI_TF;
elseif strcmp(FIELD_str,'Shape_Operator')
    CONST_TF = obj.Lin_PHI_TF;
else
    error('Not valid!');
end

end