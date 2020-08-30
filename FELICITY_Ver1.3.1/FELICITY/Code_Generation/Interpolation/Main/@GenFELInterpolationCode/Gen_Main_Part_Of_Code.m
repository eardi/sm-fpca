function Gen_Main_Part_Of_Code(obj,GeomFunc,FS,FI,Extra_C_Code)
%Gen_Main_Part_Of_Code
%
%   This generates the main core files for the FE interpolation.

% Copyright (c) 01-29-2013,  Shawn W. Walker

DEFINES = obj.Gen_mexInterpolate_FEM_cpp(FS,FI);

obj.Gen_Misc_Stuff_h(GeomFunc);
obj.Gen_ALL_EXT_C_Code_h(Extra_C_Code);
obj.Gen_ALL_BASIS_FUNC_Classes_h(FS);
obj.Gen_ALL_EXT_FUNC_Classes_h(FS);
obj.Gen_ALL_FEM_Interpolation_Classes_h(FI);
obj.Gen_Generic_FEM_Interpolation_h(GeomFunc, FS, FI);
obj.Gen_Generic_FEM_Interpolation_cc(DEFINES,GeomFunc,FS,FI);

end