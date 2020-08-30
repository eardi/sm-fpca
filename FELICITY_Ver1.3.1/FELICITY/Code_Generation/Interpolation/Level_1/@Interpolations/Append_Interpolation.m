function obj = Append_Interpolation(obj,Interpolate_Obj)
%Append_Interpolation
%
%   This appends a single Interpolate object (which contains an expression to interpolate)
%   to the internal data struct.
%
%   obj    = obj.Append_Interpolation(Interpolate_Obj);
%
%   Interpolate_Obj = is an object of class Interpolate.

% Copyright (c) 01-25-2013,  Shawn W. Walker

Check_For_Valid_Interpolation(Interpolate_Obj);

% make sure the interpolation KNOWS its name!
Interp_NAME = inputname(2);
Interpolate_Obj.Name = Interp_NAME;

Num_Interp = length(obj.Interp_Expr);
if (Num_Interp==0)
    obj.Interp_Expr{1} = Interpolate_Obj;
else
    obj.Interp_Expr{Num_Interp+1} = Interpolate_Obj;
end

end