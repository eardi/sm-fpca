function SUCCESS = Convert_Mscript_to_CPP_Code(obj,Main_Dir,Mscript,Type_STR,L1toL3_FuncHandle,GenCode_FuncHandle)
%Convert_Mscript_to_CPP_Code
%
%   This generates the C++ code from the M-script file.

% Copyright (c) 06-12-2014,  Shawn W. Walker

% generate level 1 objects
disp('---------------------------------------------------------------');
disp(['***Execute Level 1 ', Type_STR, ' Code...']);
M_Handle = str2func(Mscript);
OUT1 = M_Handle(); %eval([Mscript, '();']);

% convert to level 3 MATLAB objects
disp('-----------------------------------------------------------------------------');
disp('***Converting Level 1 Objects ====> Level 2 Structs ====> Level 3 Objects');
One_to_Three = L1toL3_FuncHandle(OUT1);
[ARG1, ARG2, C_Codes] = One_to_Three.Run_Conversion(Main_Dir,obj.Snippet_Dir);

% GENERATE C++ CODE
SUCCESS = obj.Convert_Level_3_Objects_to_CPP_Code(ARG1,ARG2,C_Codes,Type_STR,GenCode_FuncHandle);

end