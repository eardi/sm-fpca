function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 01-03-2012,  Shawn W. Walker

x_dim  = obj.Param.x_dim;
y_dim  = obj.Param.y_dim;
z_dim  = obj.Param.z_dim;

Mask = (X(:,1) > x_dim(1)) & (X(:,1) < x_dim(2)) &...
       (X(:,2) > y_dim(1)) & (X(:,2) < y_dim(2)) &...
       (X(:,3) > z_dim(1)) & (X(:,3) < z_dim(2));
%

Val = 0*X(:,1);
Val(Mask,1) = 1;
Val(~Mask,1) = -1;

Grad = [];

end