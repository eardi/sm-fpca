function BF = Get_Local_Basis_Functions(obj,Integration_Index)
%Get_Local_Basis_Functions
%
%   This returns a struct containing info about the local (row,col) basis functions.
%   note: basis functions are ``fresh'' everytime (all options off)

% Copyright (c) 01-24-2014,  Shawn W. Walker

BF.Integration_Index = Integration_Index;

% test function
BF.v_str             = obj.row_func_str;
BF.v                 = obj.row_func;
if ~isempty(BF.v.Space_Name)
    BF.v.Reset_Options;
end

% trial function
BF.u_str             = obj.col_func_str;
BF.u                 = obj.col_func;
if ~isempty(BF.u.Space_Name)
    BF.u.Reset_Options;
end

end