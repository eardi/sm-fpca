function STR = Get_Partial_Deriv_String(obj,Num_Deriv)
%Get_Partial_Deriv_String
%
%   This returns a string that looks like: '1_3_2', where the:
%   FIRST  number is the number of derivatives with respect to the FIRST  arg,
%   SECOND number is the number of derivatives with respect to the SECOND arg,
%   etc...
%   Num_Deriv are 1x3 row vectors.

% Copyright (c) 02-20-2012,  Shawn W. Walker

STR = [num2str(Num_Deriv(1)), '_', num2str(Num_Deriv(2)), '_', num2str(Num_Deriv(3))];

end