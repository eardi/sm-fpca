function CPP_Name = Output_CPP_Var_Name(obj,FIELD_str)
%Output_CPP_Var_Name
%
%   This outputs a string representing the C++ variable name.

% Copyright (c) 08-15-2014,  Shawn W. Walker

SYM_Var = obj.PHI.(FIELD_str);

if strcmp(FIELD_str,'Mesh_Size')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Val')
    Var_str = char(SYM_Var(1));
    Var_str = Var_str(1:end-2);
elseif strcmp(FIELD_str,'Grad')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
elseif strcmp(FIELD_str,'Metric')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
elseif strcmp(FIELD_str,'Det_Metric')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Inv_Det_Metric')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Inv_Metric')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
elseif strcmp(FIELD_str,'Det_Jacobian')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Det_Jacobian_with_quad_weight')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Inv_Det_Jacobian')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Inv_Grad')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
elseif strcmp(FIELD_str,'Tangent_Vector')
    Var_str = char(SYM_Var(1));
    Var_str = Var_str(1:end-2);
elseif strcmp(FIELD_str,'Normal_Vector')
    Var_str = char(SYM_Var(1));
    Var_str = Var_str(1:end-2);
elseif strcmp(FIELD_str,'Tangent_Space_Projection')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
elseif strcmp(FIELD_str,'Hess')
    Var_str = char(SYM_Var(1,1,1));
    Var_str = Var_str(1:end-5);
elseif strcmp(FIELD_str,'Hess_Inv_Map')
    Var_str = char(SYM_Var(1,1,1));
    Var_str = Var_str(1:end-5); % leave off component indices (same for all)
elseif strcmp(FIELD_str,'Grad_Metric')
    Var_str = char(SYM_Var(1,1,1));
    Var_str = Var_str(1:end-5);
elseif strcmp(FIELD_str,'Grad_Inv_Metric')
    Var_str = char(SYM_Var(1,1,1));
    Var_str = Var_str(1:end-5);
elseif strcmp(FIELD_str,'Christoffel_2nd_Kind')
    Var_str = char(SYM_Var(1,1,1));
    Var_str = Var_str(1:end-5);
elseif strcmp(FIELD_str,'Second_Fund_Form')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
elseif strcmp(FIELD_str,'Det_Second_Fund_Form')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Inv_Det_Second_Fund_Form')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Total_Curvature_Vector')
    Var_str = char(SYM_Var(1));
    Var_str = Var_str(1:end-2);
elseif strcmp(FIELD_str,'Total_Curvature')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Gauss_Curvature')
    Var_str = char(SYM_Var);
    Var_str = Var_str(1:end);
elseif strcmp(FIELD_str,'Shape_Operator')
    Var_str = char(SYM_Var(1,1));
    Var_str = Var_str(1:end-3);
else
    error('Not valid!');
end

CPP_Name = Get_Geo_CPP_Var_Name(Var_str);

end