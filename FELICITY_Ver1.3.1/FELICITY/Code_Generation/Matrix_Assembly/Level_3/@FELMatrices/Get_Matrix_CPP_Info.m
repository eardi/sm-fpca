function CPP = Get_Matrix_CPP_Info(obj,Matrix_Name)
%Get_Matrix_CPP_Info
%
%   This returns the CPP data names to use for the local and global FE
%   matrix.

% Copyright (c) 06-15-2016,  Shawn W. Walker

if ~isempty(obj.Matrix(Matrix_Name))
    CPP.Data_Type_Name    = Matrix_Name;
    CPP.Var_Name          = ['Fobj_', Matrix_Name];
    CPP.Sparse_Data_Name  = ['Sparse_Data_', Matrix_Name];
    
    % for splitting local FE matrix computation from sparse matrix assembly
    CPP.Matrix_Name             = Matrix_Name;
    
    CPP.Base_Data_Type_Name    = ['Base_', Matrix_Name, '_Data_Type'];
    CPP.Base_File_Name         = [CPP.Base_Data_Type_Name, '.cc'];
    CPP.Base_Var_Name          = ['Base_Matrix_', Matrix_Name];
    
    CPP.Block_Assemble_Data_Type_Name    = ['Block_Assemble_', Matrix_Name, '_Data_Type'];
    CPP.Block_Assemble_File_Name         = [CPP.Block_Assemble_Data_Type_Name, '.cc'];
    CPP.Block_Assemble_Var_Name          = ['Block_Assemble_Matrix_', Matrix_Name];
else
    CPP = [];
end

end