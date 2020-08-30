function Geo_Opt = Update_Geometric_Options(obj,Func_Opt,Geo_Opt)
%Update_Geometric_Options
%
%   This updates the given geometric function based on what the function options are for
%   this type of transformation.

% Copyright (c) 04-03-2018,  Shawn W. Walker

if (length(obj) > 1)
    error('This only operates on a *single* object.');
end

TD = obj.GeoMap.TopDim;
GD = obj.GeoMap.GeoDim;

if Func_Opt.Hess
    if (TD==1)
        if (GD==1)
            Geo_Opt.Hess_Inv_Map = true;
            Geo_Opt.Inv_Det_Jacobian = true;
        else
            Geo_Opt.Tangent_Vector = true;
            Geo_Opt.Total_Curvature_Vector = true;
        end
    elseif (TD==2)
        if (GD==2)
            Geo_Opt.Inv_Grad = true;
            Geo_Opt.Hess_Inv_Map = true;
        elseif (GD==3)
            % 2-D surface in 3-D
            % this will flag some other geometric options as dependencies...
            Geo_Opt.Christoffel_2nd_Kind = true;
        else
            error('Invalid!');
        end
    else %(TD==3)
        Geo_Opt.Inv_Grad = true;
        Geo_Opt.Hess_Inv_Map = true;
    end
end

if Func_Opt.d2_ds2
    if (TD ~= 1)
        error('Can only use .d2_ds2 on domains with topological dimension 1!');
    end
    Geo_Opt.Inv_Det_Jacobian = true;
    Geo_Opt.Hess = true;
    if (GD > 1)
        Geo_Opt.Tangent_Vector = true;
    end
end

if Func_Opt.Grad
    if (TD==1)
        Geo_Opt.Inv_Det_Jacobian = true;
        if (GD > 1)
            Geo_Opt.Tangent_Vector = true;
        end
    elseif (TD==2)
        if (GD==2)
            Geo_Opt.Inv_Grad = true;
        elseif (GD==3)
            Geo_Opt.Inv_Metric = true;
        else
            error('Invalid!');
        end
    else
        Geo_Opt.Inv_Grad = true;
    end
end

if Func_Opt.d_ds
    if (TD ~= 1)
        error('Can only use .d_ds on domains with topological dimension 1!');
    end
    Geo_Opt.Inv_Det_Jacobian = true;
end

end