function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 01-03-2012,  Shawn W. Walker

phi_x = X(:,1) - obj.Param.X0(1);
phi_y = X(:,2) - obj.Param.X0(2);
phi_z = X(:,3) - obj.Param.X0(3);

Val = obj.Param.N0(1) * phi_x + obj.Param.N0(2) * phi_y + obj.Param.N0(3) * phi_z;

Grad = 0*X;
Grad(:,1) = obj.Param.N0(1);
Grad(:,2) = obj.Param.N0(2);
Grad(:,3) = obj.Param.N0(3);

end