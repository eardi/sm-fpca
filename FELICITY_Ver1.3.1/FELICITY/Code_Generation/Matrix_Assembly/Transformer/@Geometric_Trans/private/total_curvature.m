function obj = total_curvature(obj)
%total_curvature
%
%   Get the total curvature for a manifold described by PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if (obj.TopDim==1) % a curve
    if (obj.GeoDim > 1)
        obj.PHI.Total_Curvature = sym('Total_Curvature');
    else
        obj.PHI.Total_Curvature = [];
    end
elseif (obj.TopDim==2) % a surface
    if (obj.GeoDim > 2)
        obj.PHI.Total_Curvature = sym('Total_Curvature');
    else
        obj.PHI.Total_Curvature = [];
    end
else
    obj.PHI.Total_Curvature = [];
end

end