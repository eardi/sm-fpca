function FileNames = FEL_Get_FileName_With_Prefix(FileList,Prefix)
%FEL_Get_FileName_With_Prefix
%
%   This returns a cell array of filenames (from FileList) that have the
%   given prefix.  Note: FileList is similar to what "dir" outputs.
%
%   FileNames = FEL_Get_FileName_With_Prefix(FileList,Prefix);
%
%   FileList = array of structs containing file/directory information.
%   Prefix   = string that beginning of filename should match.
%   FileNames = cell array of filenames that match the prefix.
%
%   Note: setting Prefix = '' just returns all the filenames in a cell array.

% Copyright (c) 04-05-2018,  Shawn W. Walker

LP = length(Prefix);

% only keep the "important" dir's
FFname = {FileList.name}';
Prefix_Mask = strncmpi(FFname,Prefix,LP);
FileList = FileList(Prefix_Mask);

FileNames = {FileList.name}';

end