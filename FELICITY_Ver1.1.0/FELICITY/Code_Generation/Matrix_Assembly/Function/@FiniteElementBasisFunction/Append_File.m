function status = Append_File(obj,fid,FileName)
%Append_File
%
%   This just appends a file from a local skeleton directory.

% Copyright (c) 04-10-2010,  Shawn W. Walker

Skeleton_Dir = Get_Skeleton_Dir();

% append the file
Fixed_File = fullfile(Skeleton_Dir, FileName);
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

end