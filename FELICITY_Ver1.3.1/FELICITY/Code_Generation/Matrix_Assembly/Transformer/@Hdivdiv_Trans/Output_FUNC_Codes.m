function CODE = Output_FUNC_Codes(obj,FUNC_Struct)
%Output_FUNC_Codes
%
%   This outputs an array of structs, each of which contains the C++ code for
%   implementing that quantity.
%
%   Note: these must be stored in order of dependencies, i.e. the ones that
%   don't depend on anything come first, etc...
%   Note: FUNC_Struct is a struct with the same fields as given by
%         Output_FUNC_Struct.

% Copyright (c) 03-22-2018,  Shawn W. Walker

CODE = obj.FUNC_Val_C_Code; % init

INDEX = 0; % init
% if FUNC_Struct.Orientation
%     INDEX = INDEX + 1;
%     CODE(INDEX) = obj.FUNC_Orientation_C_Code;
% end
if FUNC_Struct.Val
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.FUNC_Val_C_Code;
end
% if FUNC_Struct.Div
%     INDEX = INDEX + 1;
%     CODE(INDEX) = obj.FUNC_Div_C_Code;
% end

% if nothing was chosen, then do nothing!
if (INDEX==0)
    CODE = [];
end

% Orientation: [1x1 sym]
%         Val: [1x1 sym]
%         Div: [1x1 sym]
%        Grad: [1x2 sym]

end