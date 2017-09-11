function [status, New_Dir] = Create_SubDir(obj,Main_Dir,Sub_Dir)
%Create_SubDir
%
%   Create specified directory.
%
%   [status, New_Dir] = obj.Create_SubDir(Main_Dir,Sub_Dir);
%
%   Main_Dir = (string) main directory.
%   Sub_Dir  = (string) directory to create under Main_Dir.
%
%   status   = indicates success == 0 or failure ~= 0.
%   New_Dir  = (string) full path to newly created sub-directory.

% Copyright (c) 12-10-2010,  Shawn W. Walker

New_Dir = fullfile(Main_Dir,Sub_Dir);

% if that directory already exists
if isdir(New_Dir)
    disp('Directory already exists.');
    disp('Use ''Recreate_SubDir'' instead.');
    status = -1;
    New_Dir = '';
    return;
end

% make it
[DIR_SUCCESS, MESSAGE, MESSAGEID] = mkdir(Main_Dir,Sub_Dir);
if ~and(DIR_SUCCESS,isdir(New_Dir))
    disp('There was a problem creating the sub-directory: ');
    disp(['      ', New_Dir]);
    disp('');
    disp(MESSAGE);
    disp(MESSAGEID);
    status = -1;
    New_Dir = '';
else
    status = 0;
end

end