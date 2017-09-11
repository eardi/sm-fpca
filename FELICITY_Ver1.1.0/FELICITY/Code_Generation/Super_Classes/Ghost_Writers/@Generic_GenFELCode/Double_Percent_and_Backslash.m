function NEW_str = Double_Percent_and_Backslash(obj,str)
%Double_Percent_and_Backslash
%
%   This takes a text string and inserts an extra percent sign or backslash
%   wherever there is already one.

% Copyright (c) 04-07-2010,  Shawn W. Walker

str_2 = strrep(str,'%','%%');

NEW_str = strrep(str_2,'\','\\');

end