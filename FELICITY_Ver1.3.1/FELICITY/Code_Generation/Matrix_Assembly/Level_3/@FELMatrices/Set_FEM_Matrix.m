function [obj, Spaces] = Set_FEM_Matrix(obj,Integration_Index,Spaces,All_Submatrix_Integrals)
%Set_FEM_Matrix
%
%   This sets the parameters and generates code for *all* of the
%   sub-matrices of a particular FEM matrix.
%
%   Note: Spaces and New_Spaces are FELSpaces objects.

% Copyright (c) 06-09-2016,  Shawn W. Walker

if ~isa(Spaces,'FELSpaces')
    error('Spaces must be a FELSpaces object!');
end

% parse Submatrix Integrals
SubMatrices = Parse_L2_Obj_Integral(All_Submatrix_Integrals(1));
for sub_index = 2:length(All_Submatrix_Integrals)
    SubMatrices(sub_index) = Parse_L2_Obj_Integral(All_Submatrix_Integrals(sub_index));
end

% get matrix name (it is the same for all sub-matrices)
Matrix_Name = SubMatrices(1).Matrix_Name;

% create code for all the sub-matrices and record what needs to be computed
% to evaluate it
Specific_Matrix = obj.Integration(Integration_Index).Matrix(Matrix_Name);
[Specific_Matrix, Spaces] = Specific_Matrix.Set_Matrix(SubMatrices,Spaces);

% copy back over
obj.Integration(Integration_Index).Matrix(Matrix_Name) = Specific_Matrix;

end