function NEW_str = Pad_With_Whitespace(str,total_len)
%Pad_With_Whitespace
%
%   This returns the given string with whitespace added to it so that the
%   total character length matches the specified number.

% Copyright (c) 04-07-2010,  Shawn W. Walker

if ~ischar(str)
    error('Input should be a string!');
end

if (length(str) < total_len)
    WHITE = blanks(total_len - length(str));
    NEW_str = [str, WHITE];
else
    NEW_str = [str, ' ']; % need at least one space
end

% END %