function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 01-30-2014,  Shawn W. Walker

rx = obj.Param.rad_x;
ry = obj.Param.rad_y;
cx = obj.Param.cx;
cy = obj.Param.cy;

NORM = sqrt( ( (X(:,1) - cx)/rx ).^2 + ( (X(:,2) - cy)/ry ).^2);
Val = 1 - NORM;

Grad = zeros(length(Val),2);
Grad(:,1) = - ( (X(:,1) - cx)/rx ) ./ (NORM + 1e-12);
Grad(:,2) = - ( (X(:,2) - cy)/ry ) ./ (NORM + 1e-12);

end