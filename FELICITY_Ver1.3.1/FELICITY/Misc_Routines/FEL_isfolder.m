function OUT = FEL_isfolder(Input_Dir)
%FEL_isfolder
%
%   This calls either isdir or isfolder depending on MATLAB version.
%
%   OUT = FEL_isfolder(Input_Dir);
%
%   type "help isdir" for more info.

% Copyright (c) 04-19-2018,  Shawn W. Walker

isfolder_exists = exist('isfolder','builtin')==5;

if isfolder_exists
    % *new* version
    OUT = isfolder(Input_Dir);
else
    % old version
    OUT = isdir(Input_Dir);
end

end