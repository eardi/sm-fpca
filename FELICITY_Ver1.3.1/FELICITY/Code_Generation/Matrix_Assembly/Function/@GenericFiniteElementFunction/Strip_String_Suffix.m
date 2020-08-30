function input_str_stripped = Strip_String_Suffix(obj,input_str,suffixes)
%Strip_String_Suffix
%
%   This removes all suffix information from "input_str" so that what is
%   left should only be the variable name.

% Copyright (c) 12-15-2017,  Shawn W. Walker

input_str_stripped = []; % init

for ii = 1:length(suffixes)
    suff = suffixes{ii};
    % $ is end anchor
    [t, m] = regexp(input_str,['(\w*)', suff, '$'],'tokens','match','once');
    if ~isempty(t)
        input_str_stripped = t{1};
        break;
    end
end

if isempty(input_str_stripped)
    disp('This string was not identified:');
    input_str
end

end