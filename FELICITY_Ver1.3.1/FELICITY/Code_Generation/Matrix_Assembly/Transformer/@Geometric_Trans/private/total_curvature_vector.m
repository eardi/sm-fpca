function obj = total_curvature_vector(obj)
%total_curvature_vector
%
%   Get the total curvature vector for a manifold described by PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if (obj.TopDim==1) % a curve
    if (obj.GeoDim > 1)
        obj.PHI.Total_Curvature_Vector = sym('Total_Curvature_Vector_%d',[obj.GeoDim, 1]);
    else
        obj.PHI.Total_Curvature_Vector = [];
    end
elseif (obj.TopDim==2) % a surface
    if (obj.GeoDim > 2)
        obj.PHI.Total_Curvature_Vector = sym('Total_Curvature_Vector_%d',[obj.GeoDim, 1]);
    else
        obj.PHI.Total_Curvature_Vector = [];
    end
else
    obj.PHI.Total_Curvature_Vector = [];
end

end