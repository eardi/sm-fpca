function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 01-03-2012,  Shawn W. Walker

rad = obj.Param.rad;
cx  = obj.Param.cx;
cy  = obj.Param.cy;
cz  = obj.Param.cz;
sn  = obj.Param.sign;

NORM = sqrt((X(:,1) - cx).^2 + (X(:,2) - cy).^2 + (X(:,3) - cz).^2);

Val = sn*(rad - NORM);

Grad = zeros(length(Val),3);
Grad(:,1) = - (X(:,1) - cx) ./ (NORM + 1e-14);
Grad(:,2) = - (X(:,2) - cy) ./ (NORM + 1e-14);
Grad(:,3) = - (X(:,3) - cz) ./ (NORM + 1e-14);

Grad = sn * Grad;

end