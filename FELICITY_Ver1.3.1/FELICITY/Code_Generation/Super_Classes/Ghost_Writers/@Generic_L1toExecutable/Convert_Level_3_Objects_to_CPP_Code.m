function SUCCESS = Convert_Level_3_Objects_to_CPP_Code(obj,ARG1,ARG2,Extra_C_Code,Type_STR,GenCode_FuncHandle)
%Convert_Level_3_Objects_to_CPP_Code
%
%   This processes higher level data structures and auto generates the C++ code.

% Copyright (c) 06-13-2014,  Shawn W. Walker

% init
disp('---------------------------------------------------------------');
disp(['***Converting Level 3 Objects =====> C++ ', Type_STR, ' Code...']);

% create the code generation object
GenCode = GenCode_FuncHandle(obj.GenCode_Dir,[]);
GenCode.Gen_Complete_Code(ARG1,ARG2,Extra_C_Code);

SUCCESS = true;
disp('***Code Generation Complete...');
disp('---------------------------------------------------------------');

end