function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 04-04-2012,  Shawn W. Walker

rad = obj.Param.rad;
cx  = obj.Param.cx;
cy  = obj.Param.cy;

NORM = sqrt((X(:,1) - cx).^2 + (X(:,2) - cy).^2);

Val = rad - NORM;

Grad = zeros(length(Val),2);
Grad(:,1) = - (X(:,1) - cx) ./ (NORM + 1e-12);
Grad(:,2) = - (X(:,2) - cy) ./ (NORM + 1e-12);

end