function Matrix_Data = Get_Matrix(obj,Matrix_Type)
%Get_Matrix
%
%   Given the "name of the matrix", this returns the matrix data from the array
%   struct that is stored in this object.
%
%   Matrix_Data = obj.Get_Matrix(Matrix_Type);
%
%   Matrix_Type = (string) the name of the matrix.
%
%   Matrix_Data = MATLAB matrix data for the chosen matrix type.

% Copyright (c) 04-27-2012,  Shawn W. Walker

index = obj.Matrix_Name_Map(Matrix_Type);
Matrix_Data = obj.FEM(index).MAT;

end