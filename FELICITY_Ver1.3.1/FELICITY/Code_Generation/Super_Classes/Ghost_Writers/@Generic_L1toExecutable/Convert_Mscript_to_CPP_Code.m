function [SUCCESS, Extra1] = Convert_Mscript_to_CPP_Code(obj,Main_Dir,Defn_Handle,Defn_Args,Type_STR,L1toL3_FuncHandle,GenCode_FuncHandle)
%Convert_Mscript_to_CPP_Code
%
%   This generates the C++ code from the abstract MATLAB-definition file.
%   Note: Func_Handle is a function handle to a matlab function.

% Copyright (c) 03-31-2017,  Shawn W. Walker

% generate level 1 objects
disp('---------------------------------------------------------------');
disp(['***Execute Level 1 ', Type_STR, ' Code:']);
disp('#############################################################################');
disp(['#  FileName:  ', func2str(Defn_Handle), '  #']);
disp('#############################################################################');
OUT1 = Defn_Handle(Defn_Args{:}); % eval with user's input arguments

% convert to level 3 MATLAB objects
disp('-----------------------------------------------------------------------------');
disp('***Converting Level 1 Objects ====> Level 2 Structs ====> Level 3 Objects');
One_to_Three = L1toL3_FuncHandle(OUT1);
[ARG1, ARG2, C_Codes, Extra1] = One_to_Three.Run_Conversion(Main_Dir,obj.Snippet_Dir);

% GENERATE C++ CODE
SUCCESS = obj.Convert_Level_3_Objects_to_CPP_Code(ARG1,ARG2,C_Codes,Type_STR,GenCode_FuncHandle);

end