function [status, New_Dir] = Recreate_SubDir(obj,Main_Dir,Sub_Dir)
%Recreate_SubDir
%
%   Remake the specified directory.
%
%   [status, New_Dir] = obj.Recreate_SubDir(Main_Dir,Sub_Dir);
%
%   Main_Dir = (string) main directory.
%   Sub_Dir  = (string) directory to recreate under Main_Dir.
%
%   status   = indicates success == 0 or failure ~= 0.
%   New_Dir  = (string) full path to newly recreated sub-directory.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if or(isempty(Main_Dir),isempty(Sub_Dir))
    error('Given directories cannot be empty!');
end
if ~and(ischar(Main_Dir),ischar(Sub_Dir))
    error('Given directories must be strings!');
end

DIR = fullfile(Main_Dir,Sub_Dir);

status = obj.Remove_Dir(DIR);
if (status~=0)
    New_Dir = '';
    return;
end

[status, New_Dir] = obj.Create_SubDir(Main_Dir,Sub_Dir);

end