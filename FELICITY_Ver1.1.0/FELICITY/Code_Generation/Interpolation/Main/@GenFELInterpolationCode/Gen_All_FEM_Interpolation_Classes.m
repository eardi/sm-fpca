function Gen_All_FEM_Interpolation_Classes(obj,FS,FI)
%Gen_All_FEM_Interpolation_Classes
%
%   This generates a class file for evaluating FEM interpolations.

% Copyright (c) 01-30-2013,  Shawn W. Walker

Interp_Names = FI.keys;
Num_Interp = length(Interp_Names);

% get unique lists of all geometry/mesh functions, basis functions, and
% coefficient functions.
GeomFunc  = FS.Get_Unique_Array_Of_GeomFuncs;
BasisFunc = FS.Get_Unique_Array_Of_BasisFuncs;
CoefFunc  = FS.Get_Unique_Array_Of_CoefFuncs;

% generate code for each FEM matrix
for index = 1:Num_Interp
    obj.Gen_FEM_Interpolation_Specific_cc(FS,FI,Interp_Names{index},GeomFunc,BasisFunc,CoefFunc);
end

end