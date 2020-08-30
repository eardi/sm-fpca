function obj = hess_func(obj)
%hess_func
%
%   Get the intrinsic (manifold) hessian of the function, f.

% Copyright (c) 03-12-2012,  Shawn W. Walker

% represent gradient symbolically
GD = obj.GeoMap.GeoDim;
obj.f.Hess = sym('f_Hess_%d%d',[GD GD]); % matrix

end