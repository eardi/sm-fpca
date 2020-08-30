function Opt = set_struct_dependencies(obj,Opt)
%set_struct_dependencies
%
%   This does one pass through the dependency check.
%   Note that Opt is already initialized with some options.  This routine just updates
%   additional options if they are required to compute the initial options.

% Copyright (c) 04-03-2018,  Shawn W. Walker

% if you want the metric, tensor
if ~isempty(obj.PHI.Metric)
    if Opt.Metric
        % then you need the gradient of the map
        Opt.Grad = true;
    end
elseif Opt.Metric
    error('Metric cannot be used in this context!');
end
%etc......
if ~isempty(obj.PHI.Det_Metric)
    if Opt.Det_Metric
        Opt.Metric = true;
    end
elseif Opt.Det_Metric
    error('Det_Metric cannot be used in this context!');
end
if ~isempty(obj.PHI.Inv_Det_Metric)
    if Opt.Inv_Det_Metric
        Opt.Det_Metric = true;
    end
elseif Opt.Inv_Det_Metric
    error('Inv_Det_Metric cannot be used in this context!');
end
if ~isempty(obj.PHI.Inv_Metric)
    if Opt.Inv_Metric
        Opt.Inv_Det_Metric = true;
    end
elseif Opt.Inv_Metric
    error('Inv_Metric cannot be used in this context!');
end
if ~isempty(obj.PHI.Det_Jacobian)
    if Opt.Det_Jacobian
        if (obj.TopDim==obj.GeoDim)
            Opt.Grad = true;
        else
            Opt.Det_Metric = true;
        end
    end
elseif Opt.Det_Jacobian
    error('Det_Jacobian cannot be used in this context!');
end
if ~isempty(obj.PHI.Det_Jacobian_with_quad_weight)
    if Opt.Det_Jacobian_with_quad_weight
        Opt.Det_Jacobian = true;
    end
elseif Opt.Det_Jacobian_with_quad_weight
    error('Det_Jacobian_with_quad_weight cannot be used in this context!');
end

if ~isempty(obj.PHI.Inv_Det_Jacobian)
    if Opt.Inv_Det_Jacobian
        Opt.Det_Jacobian = true;
    end
elseif Opt.Inv_Det_Jacobian
    error('Inv_Det_Jacobian cannot be used in this context!');
end
if ~isempty(obj.PHI.Inv_Grad)
    if Opt.Inv_Grad
        Opt.Inv_Det_Jacobian = true;
    end
elseif Opt.Inv_Grad
    error('Inv_Grad cannot be used in this context!');
end
if ~isempty(obj.PHI.Tangent_Vector)
    if Opt.Tangent_Vector
        Opt.Grad = true;
        Opt.Inv_Det_Jacobian = true;
    end
elseif Opt.Tangent_Vector
    error('Tangent_Vector cannot be used in this context!');
end
if ~isempty(obj.PHI.Normal_Vector)
    if Opt.Normal_Vector
        Opt.Grad = true;
        Opt.Inv_Det_Jacobian = true;
    end
elseif Opt.Normal_Vector
    error('Normal_Vector cannot be used in this context!');
end
if ~isempty(obj.PHI.Tangent_Space_Projection)
    if Opt.Tangent_Space_Projection
        if (obj.TopDim==1)
            if (obj.GeoDim==1)
                % don't need anything!
            elseif (obj.GeoDim >= 2)
                Opt.Tangent_Vector = true;
            else
                error('Invalid!');
            end
        elseif (obj.TopDim==2)
            if (obj.GeoDim==2)
                % don't need anything!
            elseif (obj.GeoDim == 3)
                Opt.Normal_Vector = true;
            else
                error('Invalid!');
            end
        else
            % don't need anything!
        end
    end
elseif Opt.Tangent_Space_Projection
    error('Tangent_Space_Projection cannot be used in this context!');
end
if ~isempty(obj.PHI.Hess)
    if Opt.Hess
        % don't need anything!
    end
elseif Opt.Hess
    error('Hess cannot be used in this context!');
end
if ~isempty(obj.PHI.Hess_Inv_Map)
    if Opt.Hess_Inv_Map
        Opt.Hess = true;
        Opt.Inv_Grad = true;
    end
elseif Opt.Hess_Inv_Map
    error('Hess_Inv_Map cannot be used in this context!');
end
if ~isempty(obj.PHI.Grad_Metric)
    if Opt.Grad_Metric
        Opt.Hess = true;
        Opt.Grad = true;
    end
elseif Opt.Grad_Metric
    error('Grad_Metric cannot be used in this context!');
end
if ~isempty(obj.PHI.Grad_Inv_Metric)
    if Opt.Grad_Inv_Metric
        Opt.Grad_Metric = true;
        Opt.Inv_Metric  = true;
    end
elseif Opt.Grad_Inv_Metric
    error('Grad_Inv_Metric cannot be used in this context!');
end
% christoffel symbols of the 2nd kind (symmetric defn)
if ~isempty(obj.PHI.Christoffel_2nd_Kind)
    if Opt.Christoffel_2nd_Kind
        Opt.Grad_Metric = true;
        Opt.Inv_Metric  = true;
    end
elseif Opt.Christoffel_2nd_Kind
    error('Christoffel_2nd_Kind cannot be used in this context!');
end
if ~isempty(obj.PHI.Second_Fund_Form)
    if Opt.Second_Fund_Form
        if ((obj.GeoDim - obj.TopDim)==1)
            Opt.Hess = true;
            Opt.Normal_Vector = true;
        else
            % don't need anything!
        end
    end
elseif Opt.Second_Fund_Form
    error('Second_Fund_Form cannot be used in this context!');
end
if ~isempty(obj.PHI.Det_Second_Fund_Form)
    if Opt.Det_Second_Fund_Form
        Opt.Second_Fund_Form = true;
    end
elseif Opt.Det_Second_Fund_Form
    error('Det_Second_Fund_Form cannot be used in this context!');
end
if ~isempty(obj.PHI.Inv_Det_Second_Fund_Form)
    if Opt.Inv_Det_Second_Fund_Form
        Opt.Det_Second_Fund_Form = true;
    end
elseif Opt.Inv_Det_Second_Fund_Form
    error('Inv_Det_Second_Fund_Form cannot be used in this context!');
end
if ~isempty(obj.PHI.Total_Curvature_Vector)
    if Opt.Total_Curvature_Vector
        if (obj.TopDim==1)
            if (obj.GeoDim==2)
                Opt.Normal_Vector = true;
                Opt.Total_Curvature = true;
            elseif (obj.GeoDim==3)
                Opt.Hess           = true;
                Opt.Inv_Metric     = true;
                Opt.Tangent_Vector = true;
            else
                error('Invalid!');
            end
        elseif (obj.TopDim==2)
            if (obj.GeoDim==3)
                Opt.Normal_Vector = true;
                Opt.Total_Curvature = true;
            else
                error('Invalid!');
            end
        else
            error('Invalid!');
        end
    end
elseif Opt.Total_Curvature_Vector
    error('Total_Curvature_Vector cannot be used in this context!');
end
if ~isempty(obj.PHI.Total_Curvature)
    if Opt.Total_Curvature
        if (obj.TopDim==1)
            if (obj.GeoDim==2)
                Opt.Second_Fund_Form = true;
                Opt.Inv_Metric       = true;
            elseif (obj.GeoDim==3)
                Opt.Total_Curvature_Vector = true;
            else
                error('Invalid!');
            end
        elseif (obj.TopDim==2)
            if (obj.GeoDim==3)
                Opt.Second_Fund_Form = true;
                Opt.Inv_Metric       = true;
            else
                error('Invalid!');
            end
        else
            error('Invalid!');
        end
    end
elseif Opt.Total_Curvature
    error('Total_Curvature cannot be used in this context!');
end
if ~isempty(obj.PHI.Gauss_Curvature)
    if Opt.Gauss_Curvature
        %Map_Det_Second_Fund_Form * Map_Inv_Det_Metric;
        if and(obj.TopDim==2,obj.GeoDim==3)
            Opt.Det_Second_Fund_Form = true;
            Opt.Inv_Det_Metric       = true;
        else
            % don't need anything!
        end
    end
elseif Opt.Gauss_Curvature
    error('Gauss_Curvature cannot be used in this context!');
end
if ~isempty(obj.PHI.Shape_Operator)
    if Opt.Shape_Operator
        if (obj.TopDim==1)
            Opt.Tangent_Vector  = true;
            Opt.Total_Curvature = true;
        elseif (obj.TopDim==2)
            Opt.Inv_Det_Metric       = true;
            Opt.Inv_Metric           = true;
            Opt.Normal_Vector        = true;
            Opt.Grad_Metric          = true;
            % Grad_Metric will also give you Hess and Grad
        else
            % don't need anything!
        end
    end
elseif Opt.Shape_Operator
    error('Shape_Operator cannot be used in this context!');
end

end