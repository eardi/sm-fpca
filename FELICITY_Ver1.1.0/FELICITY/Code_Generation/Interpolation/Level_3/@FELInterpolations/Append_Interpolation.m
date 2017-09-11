function obj = Append_Interpolation(obj,Interp_Expr)
%Append_Interpolation
%
%   This creates another interpolation and stores it.

% Copyright (c) 01-28-2013,  Shawn W. Walker

Interpolate_Name = Interp_Expr.Name;

% check if this interpolation is already present
[TF, LOC] = ismember(Interpolate_Name,obj.keys);
if TF
    disp(['This interpolate name: ', Interpolate_Name, ' is already used!']);
    error('Interpolation names should be distinct!');
else
    obj.Interp(Interpolate_Name) = FELInterpolate(Interpolate_Name,Interp_Expr.Domain,...
                                                  Interp_Expr.Expression,obj.Snippet_Dir);
end

% reset keys
obj.keys = obj.Interp.keys;

end