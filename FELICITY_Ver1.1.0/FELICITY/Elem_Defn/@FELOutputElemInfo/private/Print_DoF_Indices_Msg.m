function Print_DoF_Indices_Msg(obj)
%Print_DoF_Indices_Msg
%
%   Prints a standard message.

% Copyright (c) 05-01-2012,  Shawn W. Walker

STR1 = ['Begin output of (ordered) DoF indices attached to topological entities'];
STR2 = ['      for Element:  ', obj.Elem.Element_Name];

HDR_str = '-----------------------------------------------------------------------';
disp(HDR_str);
disp(STR1);
disp(STR2);
disp(HDR_str);
disp(' ');

end