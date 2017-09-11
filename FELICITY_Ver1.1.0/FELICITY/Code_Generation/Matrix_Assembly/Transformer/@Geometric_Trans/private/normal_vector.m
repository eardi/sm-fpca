function obj = normal_vector(obj)
%normal_vector
%
%   Get the normal vector for a manifold described by PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if (obj.TopDim==1) % a curve
    if (obj.GeoDim==2) % in the plane
        obj.PHI.Normal_Vector = sym('Normal_Vector_%d',[obj.GeoDim, 1]);
    else % unique consistent normal vector is not defined
        obj.PHI.Normal_Vector = [];
    end
elseif (obj.TopDim==2) % a surface
    if (obj.GeoDim==3) % in \R^3
        obj.PHI.Normal_Vector = sym('Normal_Vector_%d',[obj.GeoDim, 1]);
    else % unique consistent normal vector is not defined
        obj.PHI.Normal_Vector = [];
    end
else
    obj.PHI.Normal_Vector = [];
end

end