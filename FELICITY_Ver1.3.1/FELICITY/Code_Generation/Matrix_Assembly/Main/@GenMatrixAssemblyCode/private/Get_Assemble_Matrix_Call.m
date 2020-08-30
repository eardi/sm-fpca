function [Function_Call_Defn_str, Function_Call_Std_str, Block_Matrix_Arg_0] = Get_Assemble_Matrix_Call(Num_Blocks,MAT_CPP_Info,GeoFunc)
%Get_Assemble_Matrix_Call
%
%   This returns strings representing the matrix assembly call *definition*
%   and actually calling it in the code.

% Copyright (c) 06-15-2016,  Shawn W. Walker

Block_Matrix_Arg_0 = [];
Block_Matrix_Arg = [];
Block_Matrix_Arg_Std = [];
for ind = 1:Num_Blocks
    if (ind==Num_Blocks)
        T1 = ['const ', MAT_CPP_Info.Base_Data_Type_Name, '*'];
        Block_Matrix_Arg_0 = [Block_Matrix_Arg_0, T1];
        Block_Matrix_Arg = [Block_Matrix_Arg, T1, ' Block_00'];
        Block_Matrix_Arg_Std = [Block_Matrix_Arg_Std, MAT_CPP_Info.Base_Var_Name];
    else
        T1 = ['const ', MAT_CPP_Info.Base_Data_Type_Name, '*'];
        Block_Matrix_Arg_0 = [Block_Matrix_Arg_0, T1, ', '];
        Block_Matrix_Arg = [Block_Matrix_Arg, T1, ' Block_00', ', '];
        Block_Matrix_Arg_Std = [Block_Matrix_Arg_Std, MAT_CPP_Info.Base_Var_Name, ', '];
    end
end

if isempty(GeoFunc)
    Function_Call_Defn_str = [];
    Function_Call_Std_str  = [];
else
    DoI = GeoFunc.Domain.Integration_Domain.Name;
    ARG_DEFN = ['(', Block_Matrix_Arg, ')'];
    Function_Call_Defn_str = ['Add_Entries_To_Global_Matrix_', DoI, ARG_DEFN];
    
    ARG_STD = ['(', Block_Matrix_Arg_Std, ')'];
    Function_Call_Std_str = ['Add_Entries_To_Global_Matrix_', DoI, ARG_STD];
end

end