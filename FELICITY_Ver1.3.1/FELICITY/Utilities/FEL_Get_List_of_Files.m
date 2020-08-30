function LF = FEL_Get_List_of_Files(Given_Dir)
%FEL_Get_List_of_Files
%
%   This returns a list of files in Given_Dir.  I.e. it ignores directories.
%
%   LF = FEL_Get_List_of_Files(Given_Dir)
%
%   Given_Dir = directory to look in.
%   LF = list of files under Dir.

% Copyright (c) 04-05-2018,  Shawn W. Walker

LF = dir(Given_Dir);

% only keep the ones that are NOT directories
ID = {LF.isdir};
ID = cell2mat(ID)';
LF = LF(~ID);

end