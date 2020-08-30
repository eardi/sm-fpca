function BF = Get_Local_Basis_Functions(obj,Spaces,Integration_Index)
%Get_Local_Basis_Functions
%
%   This returns a struct containing info about the local (row,col) basis functions.
%   note: basis functions are ``fresh'' everytime (all options off)

% Copyright (c) 03-24-2017,  Shawn W. Walker

BF.Integration_Index = Integration_Index;

% test function
BF.v_str = obj.row_func_str;
BF.v     = obj.row_func;
if ~isempty(BF.v.Space_Name)
    BF.v = BF.v.Reset_Options;
    v_Space = Spaces.Space(BF.v.Space_Name);
    BF.v_Space_Num_Comp = v_Space.Num_Comp;
else
    BF.v_Space_Num_Comp = [1 1];
end

% trial function
BF.u_str = obj.col_func_str;
BF.u     = obj.col_func;
if ~isempty(BF.u.Space_Name)
    BF.u = BF.u.Reset_Options;
    u_Space = Spaces.Space(BF.u.Space_Name);
    BF.u_Space_Num_Comp = u_Space.Num_Comp;
else
    BF.u_Space_Num_Comp = [1 1];
end

end