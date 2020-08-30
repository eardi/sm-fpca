function obj = Update_Basis_Function_Options(obj,BF,CF)
%Update_Basis_Function_Options
%
%   This updates what needs to be computed in the C++ code for each
%   coefficient function.

% Copyright (c) 03-15-2012,  Shawn W. Walker

if ~isempty(BF.v.Space_Name)
    obj = obj.Update_Basis_Function_Option_In_Given_Space(BF.Integration_Index, BF.v);
end
if ~isempty(BF.u.Space_Name)
    obj = obj.Update_Basis_Function_Option_In_Given_Space(BF.Integration_Index, BF.u);
end

% now do the same for all of the coefficient functions which are defined in
% terms of the function spaces!
Num_Funcs = length(CF);
for ind = 1:Num_Funcs
    obj = obj.Update_Basis_Function_Option_In_Given_Space(CF(ind).Integration_Index,CF(ind).func);
end

end