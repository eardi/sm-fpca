function CPP = Get_Matrix_CPP_Info(obj,Matrix_Name)
%Get_Matrix_CPP_Info
%
%   This returns the CPP data names to use for the global FEM matrix.

% Copyright (c) 06-03-2012,  Shawn W. Walker

if ~isempty(obj.Matrix(Matrix_Name))
    CPP.Data_Type_Name    = Matrix_Name;
    CPP.Var_Name          = ['Fobj_', Matrix_Name];
    CPP.Sparse_Data_Name  = ['Sparse_Data_', Matrix_Name];
else
    CPP = [];
end

end