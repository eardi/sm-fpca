function obj = Append_C_Code_Info(obj,CC_struct)
%Append_C_Code_Info
%
%   This saves info for including external user created C code.

% Copyright (c) 06-12-2014,  Shawn W. Walker

Num_CC = length(obj.C_Codes);

if Num_CC < 1
    obj.C_Codes = CC_struct;
else
    obj.C_Codes(Num_CC+1) = CC_struct;
end

end