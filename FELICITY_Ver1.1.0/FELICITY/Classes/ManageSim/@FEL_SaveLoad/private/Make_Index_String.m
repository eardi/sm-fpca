function Index_str = Make_Index_String(Index, Pad_Length)
%Make_Index_String
%
%   Make a string from the given index and pad with extra zeros.

% Copyright (c) 04-09-2014,  Shawn W. Walker

ZERO_str = repmat('0', 1, Pad_Length);
TEMP_str = num2str(Index);

Index_str = ZERO_str; % init
Index_str(end-length(TEMP_str)+1:end) = TEMP_str;

end