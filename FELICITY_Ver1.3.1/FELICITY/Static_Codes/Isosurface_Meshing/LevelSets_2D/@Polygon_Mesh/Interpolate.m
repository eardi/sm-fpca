function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.  This defines the object shape.

% Copyright (c) 04-30-2013,  Shawn W. Walker

IN = inpoly(X,obj.Grid.Vtx,obj.Grid.Edge);

Val = 0*X(:,1);
Val(IN,1) = 1;
Val(~IN,1) = -1;

Grad = [];

end