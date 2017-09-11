function Gen_Main_Part_Of_Code(obj,FPS,Extra_C_Code)
%Gen_Main_Part_Of_Code
%
%   This generates the main core files for the point searching.

% Copyright (c) 06-15-2014,  Shawn W. Walker

DEFINES = obj.Gen_mexPoint_Search_cpp(FPS);

GeomFunc = FPS.GeomFuncs.values;
obj.Gen_Misc_Stuff_h(GeomFunc);
obj.Gen_ALL_EXT_C_Code_h(Extra_C_Code);

obj.Gen_ALL_Point_Search_Classes_h(FPS);
obj.Gen_Generic_Point_Search_h(FPS);
obj.Gen_Generic_Point_Search_cc(DEFINES,FPS);

end