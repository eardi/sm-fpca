function CODE = Output_COEF_FUNC_Codes(obj,FUNC_Struct)
%Output_COEF_FUNC_Codes
%
%   This outputs an array of structs, each of which contains the C++ code for
%   implementing that quantity.
%
%   Since this is only for constants, only need the value.
%   Note: FUNC_Struct is a struct with the same fields as given by
%         Output_FUNC_Struct.

% Copyright (c) 01-11-2018,  Shawn W. Walker

CODE = obj.COEF_FUNC_Val_C_Code; % init

INDEX = 0; % init
if FUNC_Struct.Val
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.COEF_FUNC_Val_C_Code;
end

% if nothing was chosen, then do nothing!
if (INDEX==0)
    CODE = [];
end

%        Val: [1x1 sym]

end