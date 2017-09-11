function Gen_All_FEM_Matrix_Classes(obj,FS,FM)
%Gen_All_FEM_Matrix_Classes
%
%   This generates a class file for computing FEM matrices.

% Copyright (c) 06-06-2012,  Shawn W. Walker

Matrix_Names = FM.Matrix.keys;
Num_Matrices = length(Matrix_Names);

% get unique lists of all geometry/mesh functions, basis functions, and
% coefficient functions.
GeomFunc  = FS.Get_Unique_Array_Of_GeomFuncs;
BasisFunc = FS.Get_Unique_Array_Of_BasisFuncs;
CoefFunc  = FS.Get_Unique_Array_Of_CoefFuncs;

% generate code for each FEM matrix
for index = 1:Num_Matrices
    obj.Gen_FEM_Matrix_Specific_cc(FS,FM,Matrix_Names{index},GeomFunc,BasisFunc,CoefFunc);
end

end