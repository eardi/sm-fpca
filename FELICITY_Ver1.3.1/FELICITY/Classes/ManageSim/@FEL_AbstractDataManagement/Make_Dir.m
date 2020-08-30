function status = Make_Dir(obj,Input_Dir)
%Make_Dir
%
%   Create specified directory.
%
%   [status, New_Dir] = obj.Make_Dir(Input_Dir);
%
%   Input_Dir  = (string) full path directory to create.
%
%   status   = indicates success == 0 or failure ~= 0.

% Copyright (c) 01-30-2017,  Shawn W. Walker

Root_Only = obj.Check_Root_Dir(Input_Dir);
if Root_Only
    error('You are NOT allowed to *make* the root directory!');
end

% if that directory already exists
if isdir(Input_Dir)
    disp('Directory already exists.');
    %disp('Use ''XXXX'' instead.');
    status = -1;
    return;
end

% make it
[DIR_SUCCESS, MESSAGE, MESSAGEID] = mkdir(Input_Dir);
if ~and(DIR_SUCCESS,isdir(Input_Dir))
    disp('There was a problem creating this directory: ');
    disp(['      ', Input_Dir]);
    disp('');
    disp(MESSAGE);
    disp(MESSAGEID);
    status = -1;
else
    status = 0;
end

end