function [Root_Only, Root_Dir] = Check_Root_Dir(obj,Input_Dir)
%Check_Root_Dir
%
%   Check that given directory has a valid root, and is a sub-dir of the
%   root.
%
%   [Root_Only, Root_Dir] = obj.Check_Root_Dir(Input_Dir);
%
%   Input_Dir = (string) full path directory to check.
%
%   Root_Only = true indicates that the given directory is only the root dir.
%   Root_Dir  = string containing the root dir only.

% Copyright (c) 01-30-2017,  Shawn W. Walker

Root_Only = false; % default

% examine the given directory
Dir_Parts = regexp(Input_Dir, filesep, 'split');

% check if this is only a root directory
if (length(Dir_Parts)<=1)
    Root_Only = true;
    Root_Dir = Dir_Parts{1};
else
    if isempty(Dir_Parts{1})
        Root_Dir = Dir_Parts{2};
    else
        Root_Dir = Dir_Parts{1};
    end
end

% make adjustment for different operating systems
if (Input_Dir(1)==filesep)
    % then this is NOT windows!
    Root_Dir = [filesep, Root_Dir]; % linux wants this
end

% make sure the root is valid!
if ~isdir(Root_Dir)
    disp(['Given directory: ' Input_Dir]);
    disp(['The root directory ''', Root_Dir, ''' is not valid!']);
    disp('NOTE: the given directory must be a FULL path.');
    error('Make sure the given directory has a valid root!');
end

end