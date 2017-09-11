function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 01-03-2012,  Shawn W. Walker

s = obj.Grid.s_vec;
% GX = obj.Grid.X;
% GY = obj.Grid.Y;
% GZ = obj.Grid.Z;

Val = interp3(s,s,s,obj.Grid.V,X(:,1),X(:,2),X(:,3),'linear*');

% if we interpolate outside the domain of the data, then just say it is
% outside!
bad_mask = isnan(Val);
Val(bad_mask) = -1; % outside!

Grad = [];

end