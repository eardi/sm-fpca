function obj = Set_mex_Dir(obj,Input_Dir,mex_Name)
%Set_mex_Dir
%
%   This sets the directory to hold (potential) mex files for performing
%   interpolations.
%
%   obj = obj.Set_mex_Dir(Input_Dir, mex_Name (optional) );
%
%   Input_Dir = (string) containing the desired directory.
%   mex_Name = (string) sets the desired name for the interpolation mex
%              file.  If omitted, then a default name is used.

% Copyright (c) 04-14-2017,  Shawn W. Walker

if ~isfolder(Input_Dir)
    error('Not valid directory!');
end

onPath = verify_dir_in_path(Input_Dir);
isCurrentDir = is_dir_the_pwd(Input_Dir);
if and(~onPath,~isCurrentDir)
    error('Input_Dir is not in the MATLAB path and it is not the present working directory.');
end

obj.mex_Dir = Input_Dir;

if (nargin==3)
    % re-define the mex file name
    obj.mex_Interpolation = str2func(mex_Name);
end

end

function onPath = verify_dir_in_path(Input_Dir)

pathCell = regexp(path, pathsep, 'split');
if ispc  % Windows is not case-sensitive
  onPath = any(strcmpi(Input_Dir, pathCell));
else
  onPath = any(strcmp(Input_Dir, pathCell));
end

end

function isPWD = is_dir_the_pwd(Input_Dir)

if ispc  % Windows is not case-sensitive
  isPWD = strcmpi(Input_Dir, pwd);
else
  isPWD = strcmp(Input_Dir, pwd);
end

end