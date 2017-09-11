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

% Copyright (c) 02-20-2012,  Shawn W. Walker

CODE = obj.FUNC_Val_C_Code; % init

INDEX = 0; % init
if FUNC_Struct.Val
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.FUNC_Val_C_Code;
end
% this must come before gradient!
if FUNC_Struct.d_ds
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.FUNC_d_ds_C_Code;
end
if FUNC_Struct.Grad
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.FUNC_Grad_C_Code;
end
if FUNC_Struct.d2_ds2
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.FUNC_d2_ds2_C_Code;
end
if FUNC_Struct.Hess
    INDEX = INDEX + 1;
    CODE(INDEX) = obj.FUNC_Hess_C_Code;
end

% if nothing was chosen, then do nothing!
if (INDEX==0)
    CODE = [];
end

%        Val: [1x1 sym]
%       Grad: [1x2 sym]
%       d_ds: [1x1 sym]
%       Hess: [2x2 sym]
%     d2_ds2: [1x1 sym]

end