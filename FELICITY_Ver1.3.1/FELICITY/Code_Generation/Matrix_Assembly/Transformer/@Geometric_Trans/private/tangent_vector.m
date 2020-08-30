function obj = tangent_vector(obj)
%tangent_vector
%
%   Get the tangent vector for a 1-D curve described by PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if (obj.TopDim==1) % a curve
    if (obj.GeoDim > 1)
        obj.PHI.Tangent_Vector = sym('Tangent_Vector_%d',[obj.GeoDim, 1]);
    else
        obj.PHI.Tangent_Vector = [];
    end
else
    obj.PHI.Tangent_Vector = [];
end

end