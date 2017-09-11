function obj = grad_func(obj)
%grad_func
%
%   Get the intrinsic (manifold) gradient of the function, f.

% Copyright (c) 03-12-2012,  Shawn W. Walker

% represent gradient symbolically
GD = obj.GeoMap.GeoDim;
obj.f.Grad = sym('f_Grad_%d',[1 GD]); % row vector

end