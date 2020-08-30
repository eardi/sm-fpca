function Print_Basis_Function_Msg(obj)
%Print_Basis_Function_Msg
%
%   Prints a standard message.

% Copyright (c) 05-02-2012,  Shawn W. Walker

STR1 = ['Begin output of (ordered) Basis Functions'];
STR2 = ['      for Element:  ', obj.Elem.Element_Name];

HDR_str = '-----------------------------------------------------------------------';
disp(HDR_str);
disp(STR1);
disp(STR2);
disp(HDR_str);
disp(' ');

end