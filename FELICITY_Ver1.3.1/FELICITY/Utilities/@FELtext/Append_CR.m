function obj = Append_CR(obj,New_Line)
%Append_CR
%
%   This appends a text line (with a carriage return!) to the end of an internal
%   structure.
%
%   obj = obj.Append_CR(New_Line);
%
%   New_Line = (string) line of text.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if ~isempty(obj.Text)
    Num_Lines = length(obj.Text);
    obj.Text(Num_Lines+1).line = [New_Line, obj.ENDL];
else
    obj.Text(1).line = [New_Line, obj.ENDL];
end

end