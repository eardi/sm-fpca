function [obj, status] = Set_Main_Dir(obj,Input_Dir)
%Set_Main_Dir
%
%   Set the desired data directory.
%
%   [obj, status] = obj.Set_Main_Dir(Input_Dir);
%
%   Input_Dir = (string) full path directory to use for storing data.
%
%   status   = indicates success == 0 or failure ~= 0.

% Copyright (c) 01-30-2017,  Shawn W. Walker

Is_Valid = obj.Is_Valid_Dir(Input_Dir);
if ~Is_Valid
    disp(['Given directory:  ', Input_Dir]);
    error('The given directory is not a valid data directory!');
end

obj.Main_Dir = Input_Dir;

% if the directory does not exist, then make it!
if ~FEL_isfolder(obj.Main_Dir)
    status = obj.Make_Dir(obj.Main_Dir);
end

end