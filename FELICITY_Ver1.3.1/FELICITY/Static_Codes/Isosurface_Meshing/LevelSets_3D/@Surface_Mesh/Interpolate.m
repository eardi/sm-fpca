function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.  This defines the object shape.

% Copyright (c) 04-04-2012,  Shawn W. Walker

IN = inpolyhedron(obj.Grid.Tri,obj.Grid.Vtx,X,'FLIPNORMALS',true);

Val = 0*X(:,1);
Val(IN,1) = 1;
Val(~IN,1) = -1;

Grad = [];

end