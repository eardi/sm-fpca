function obj = gauss_curvature(obj)
%gauss_curvature
%
%   Get the gauss curvature for a manifold described by PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if (obj.TopDim==1) % a curve
    if (obj.GeoDim > 1)
        obj.PHI.Gauss_Curvature = sym('Gauss_Curvature');
    else
        obj.PHI.Gauss_Curvature = [];
    end
elseif (obj.TopDim==2) % a surface
    if (obj.GeoDim > 2)
        obj.PHI.Gauss_Curvature = sym('Gauss_Curvature');
    else
        obj.PHI.Gauss_Curvature = [];
    end
else
    obj.PHI.Gauss_Curvature = [];
end

end