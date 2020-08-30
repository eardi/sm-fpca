function [obj, Replacement_str] = Get_Eval_String(obj,input_str,domain_choice)
%Get_Eval_String
%
%   This will parse the geom function string.  domain_choice selects either the Subdomain
%   geometry or the Domain of Integration (DoI) geometry.

% Copyright (c) 01-24-2014,  Shawn W. Walker

% SWW: could there be a mistake if the end of input_str matches domain_choice?

MATCH_STR = obj.Get_String_Match_Struct;

% concatenate 'geom' and domain name string
if strcmp(domain_choice,'DoI')
    % we want the Domain of Integration (DoI)
    geom_domain_str = [obj.Func_Name, obj.Domain.Integration_Domain.Name];
else
    % assume we want the subdomain
    geom_domain_str = [obj.Func_Name, obj.Domain.Subdomain.Name];
end

% init
Replacement_str = [];
%Comp = 1;
len_geom_domain_str = length(geom_domain_str);

% get geometric dimension
GeoDim = obj.Domain.Integration_Domain.GeoDim;

% make sure we only make replacement when the given variable name is on the
% same domain
if ~strncmp(input_str,geom_domain_str,len_geom_domain_str)
    % if the domains are different, just exit!
    return;
end

mesh_func_STR  = [obj.CPP.Identifier_Name, '->'];

% check if it is the mesh size
if ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.mesh_size], 'once'))
    
    obj.Opt.Mesh_Size = true;
    % setup the C-code evaluation string
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Mesh_Size');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    Replacement_str = [CPP_Name_w_Mesh, '[0]', '.a'];

% check if it is the derivative of the coordinate function
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.coord_deriv], 'once'))
    
    % parse X, Y, or Z component
    X_Comp_str = input_str(len_geom_domain_str+3);
    % get coord component
    X_Comp     = str2double(X_Comp_str);
    
    % parse derivative component
    Deriv_Comp_str = input_str(len_geom_domain_str+10);
    % get s_1, s_2 derivative component
    Deriv_Comp  = str2double(Deriv_Comp_str);
    
    if (X_Comp > GeoDim)
        error('Coordinate component cannot be larger than geometric dimension.');
    end
    if (Deriv_Comp > obj.Elem.Top_Dim)
        error('Derivative component cannot be larger than topological dimension.');
    end
    
    obj.Opt.Grad  = true;
    % setup the C-code evaluation string
    C_style_X_Comp     = X_Comp-1;
    C_style_Deriv_Comp = Deriv_Comp-1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Grad');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Grad');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.m[', num2str(C_style_X_Comp), '][', num2str(C_style_Deriv_Comp), ']'];

% check if it is the PHYSICAL GRADIENT (e.g. like the surface gradient) of the coordinate function
%       this is just the tangent space projection!
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.tan_space_proj], 'once'))
    
    % parse X, Y, or Z component
    X_Comp_str = input_str(len_geom_domain_str+6);
    % get coord component
    X_Comp     = str2double(X_Comp_str);
    
    % parse grad component
    Grad_Comp_str = input_str(len_geom_domain_str+7);
    % get grad component
    Grad_Comp     = str2double(Grad_Comp_str);
    
    if (X_Comp > GeoDim)
        error('Coordinate component cannot be larger than geometric dimension.');
    end
    if (Grad_Comp > GeoDim)
        error('Physical gradient component cannot be larger than geometric dimension.');
    end
    
    obj.Opt.Tangent_Space_Projection  = true;
    % setup the C-code evaluation string
    C_style_X_Comp     = X_Comp-1;
    C_style_Grad_Comp  = Grad_Comp-1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Tangent_Space_Projection');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Tangent_Space_Projection');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.m[', num2str(C_style_X_Comp), '][', num2str(C_style_Grad_Comp), ']'];

% check if it is the coordinate function
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.coord_val], 'once'))
    
    % parse X, Y, or Z component
    X_Comp_str = input_str(len_geom_domain_str+3);
    % get coord component
    X_Comp     = str2double(X_Comp_str);
    
    if (X_Comp > GeoDim)
        error('Coordinate component cannot be larger than geometric dimension.');
    end
    
    obj.Opt.Val  = true;
    % setup the C-code evaluation string
    C_style_X_Comp  = X_Comp-1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Val');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Val');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.v[', num2str(C_style_X_Comp), ']'];

% check if it is the tangent vector
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.tangent], 'once'))
    
    % parse component
    Comp_str = input_str(len_geom_domain_str+3);
    % set component
    Comp  = str2double(Comp_str);
    
    obj.Opt.Tangent_Vector  = true;
    % setup the C-code evaluation string
    C_style_Comp    = Comp-1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Tangent_Vector');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Tangent_Vector');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.v[', num2str(C_style_Comp), ']'];

% check if it is the normal vector
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.normal], 'once'))
    
    % parse component
    Comp_str = input_str(len_geom_domain_str+3);
    % set component
    Comp  = str2double(Comp_str);
    
    obj.Opt.Normal_Vector  = true;
    % setup the C-code evaluation string
    C_style_Comp    = Comp-1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Normal_Vector');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Normal_Vector');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.v[', num2str(C_style_Comp), ']'];

% check if it is the curvature vector
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.curvvec], 'once'))
    
    % parse component
    Comp_str = input_str(len_geom_domain_str+10);
    % set component
    Comp  = str2double(Comp_str);
    
    obj.Opt.Total_Curvature_Vector  = true;
    % setup the C-code evaluation string
    C_style_Comp    = Comp-1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Total_Curvature_Vector');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Total_Curvature_Vector');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.v[', num2str(C_style_Comp), ']'];

% check if it is the (total) scalar curvature
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.curv], 'once'))
    
    obj.Opt.Total_Curvature  = true;
    % setup the C-code evaluation string
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Total_Curvature');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Total_Curvature');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.a'];
    
% check if it is the gauss curvature
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.gauss_curv], 'once'))
    
    obj.Opt.Gauss_Curvature  = true;
    % setup the C-code evaluation string
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Gauss_Curvature');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Gauss_Curvature');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.a'];
    
% check if it is the shape operator
elseif ~isempty(regexp(input_str,[geom_domain_str, MATCH_STR.shape_op], 'once'))
    
    % parse the components of the shape operator
    Comp_1_str = input_str(len_geom_domain_str+11);
    Comp_2_str = input_str(len_geom_domain_str+12);
    % get component indices
    Comp_1     = str2double(Comp_1_str);
    Comp_2     = str2double(Comp_2_str);
    if or(Comp_1 > GeoDim, Comp_2 > GeoDim)
        error('Component indices (for the shape operator) cannot be larger than the geometric dimension.');
    end
    
    obj.Opt.Shape_Operator  = true;
    % setup the C-code evaluation string
    C_style_Comp_1     = Comp_1 - 1;
    C_style_Comp_2     = Comp_2 - 1;
    CPP_Name        = obj.GeoTrans.Output_CPP_Var_Name('Shape_Operator');
    CPP_Name_w_Mesh = [mesh_func_STR, CPP_Name];
    QP_str = get_quad_pt_str(obj,'Shape_Operator');
    Replacement_str = [CPP_Name_w_Mesh, QP_str, '.m[', num2str(C_style_Comp_1), '][', num2str(C_style_Comp_2), ']'];
else
    disp('There was no match for the geometric function:');
    input_str
    disp('      on this domain:')
    geom_domain_str
end

end

function QP_str = get_quad_pt_str(obj,FIELD_str)

CONST_VAR = obj.GeoTrans.Is_Quantity_Constant(FIELD_str);

if CONST_VAR
    % there is only one quad point
    QP_str = '[0]';
else
    % the map is non-linear, so we have several quad points
    QP_str = '[qp]';
end

end