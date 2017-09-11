function status = Copy_File(obj,Source_FileName,Destination_Path_and_FileName)
%Copy_File
%
%   This just copies a file from a local skeleton directory.

% Copyright (c) 04-10-2010,  Shawn W. Walker

Skeleton_Dir = Get_Skeleton_Dir();

% copy the source file to the destination
status = FEL_CopyFile(fullfile(Skeleton_Dir, Source_FileName),Destination_Path_and_FileName);

end