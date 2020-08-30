function obj = Append(obj,New_Line)
%Append
%
%   This appends a text line to the end of an internal structure.
%
%   obj = obj.Append(New_Line);
%
%   New_Line = (string) line of text.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if ~isempty(obj.Text)
    Num_Lines = length(obj.Text);
    obj.Text(Num_Lines+1).line = New_Line;
else
    obj.Text(1).line = New_Line;
end

end