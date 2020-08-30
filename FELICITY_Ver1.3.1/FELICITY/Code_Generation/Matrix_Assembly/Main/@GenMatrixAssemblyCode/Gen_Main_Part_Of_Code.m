function Gen_Main_Part_Of_Code(obj,GeomFunc,FS,FM,Extra_C_Code)
%Gen_Main_Part_Of_Code
%
%   This generates the main core files for the matrix assembly.

% Copyright (c) 06-04-2012,  Shawn W. Walker

DEFINES = obj.Gen_mexAssemble_FEM_cpp(FS,FM);

obj.Gen_Misc_Stuff_h(GeomFunc);
obj.Gen_ALL_EXT_C_Code_h(Extra_C_Code);
obj.Gen_ALL_BASIS_FUNC_Classes_h(FS);
obj.Gen_ALL_EXT_FUNC_Classes_h(FS);
obj.Gen_ALL_FEM_Classes_h(FM);
obj.Gen_Generic_FEM_Assembly_h(GeomFunc, FS, FM);
obj.Gen_Generic_FEM_Assembly_cc(DEFINES,GeomFunc,FS,FM);

end