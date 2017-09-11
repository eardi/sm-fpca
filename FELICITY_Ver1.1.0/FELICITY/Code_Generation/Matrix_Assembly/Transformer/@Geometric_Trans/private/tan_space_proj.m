function obj = tan_space_proj(obj)
%tan_space_proj
%
%   Get the tangent space projection matrix for a manifold described by PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

if (obj.GeoDim >= obj.TopDim)
    obj.PHI.Tangent_Space_Projection = sym('Tangent_Space_Proj_%d%d',[obj.GeoDim, obj.GeoDim]);
else
    error('Not valid!');
end

end