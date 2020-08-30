function obj = Append_FEM_Matrix(obj,Row_Space_Name,Col_Space_Name,FEM_Matrix_Name,...
                                 Specific_Matrix_Name,Integration_Index,Integrand_str,...
                                     Num_Sub_Matrices,row_func,col_func,row_func_str,col_func_str)
%Append_FEM_Matrix
%
%   This creates another finite element matrix and stores it under the
%   appropriate integration domain.

% Copyright (c) 06-03-2012,  Shawn W. Walker

% global matrix info
MM = Get_Matrix_Struct();
MM.Name           = FEM_Matrix_Name;
MM.Row_Space_Name = Row_Space_Name;
MM.Col_Space_Name = Col_Space_Name;
obj.Matrix(FEM_Matrix_Name) = MM; % insert

% contribution to matrix from one integral
obj.Integration(Integration_Index).Matrix(FEM_Matrix_Name) = FELMatrix(Specific_Matrix_Name,...
    Integrand_str,Num_Sub_Matrices,row_func,col_func,row_func_str,col_func_str,obj.Snippet_Dir);
%

end