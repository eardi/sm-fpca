function obj = grad_func(obj)
%grad_func
%
%   Get the intrinsic (manifold) gradient of the function, f.

% Copyright (c) 05-19-2016,  Shawn W. Walker

% represent gradient symbolically
GD = obj.GeoMap.GeoDim;
if (GD==1)
    obj.f.Grad = sym('f_Grad_1');
else
    obj.f.Grad = sym('f_Grad_%d',[1 GD]); % row vector
end

end