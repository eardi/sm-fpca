function [obj, New_Spaces] = Set_FEM_Matrix_Submatrix(obj,Integration_Index,Spaces,L2_Obj_Integral)
%Set_FEM_Matrix_Submatrix
%
%   This sets the parameters and generates code for a sub-matrix of a
%   particular FEM matrix.
%
%   Note: Spaces and New_Spaces are FELSpaces objects.

% Copyright (c) 06-03-2012,  Shawn W. Walker

SM = Parse_L2_Obj_Integral(L2_Obj_Integral);

if ~isa(Spaces,'FELSpaces')
    error('Spaces must be a FELSpaces object!');
end

% create code for the sub-matrix and record what needs to be computed to
% evaluate it
Specific_Matrix = obj.Integration(Integration_Index).Matrix(SM.Matrix_Name);
[New_Matrix, New_Spaces] = Specific_Matrix.Set_Sub_Matrix(SM,Spaces);

% copy over
obj.Integration(Integration_Index).Matrix(SM.Matrix_Name) = New_Matrix;

end