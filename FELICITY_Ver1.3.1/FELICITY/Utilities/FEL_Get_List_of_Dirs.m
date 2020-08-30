function LD = FEL_Get_List_of_Dirs(Given_Dir)
%FEL_Get_List_of_Dirs
%
%   This returns a list of sub-directories of Given_Dir.  I.e. it
%   ignores file contents and only returns directory names.
%
%   LD = FEL_Get_List_of_Dirs(Given_Dir);
%
%   Given_Dir = directory to look in.
%   LD = list of directories under Dir.

% Copyright (c) 04-05-2018,  Shawn W. Walker

LD_temp = dir(Given_Dir);

% only keep the ones that are directories
ID = {LD_temp.isdir};
ID = cell2mat(ID)';
LD_temp = LD_temp(ID);

% only keep the "important" dir's
DDname = {LD_temp.name}';
DotDir = strcmpi(DDname,'.');
DotDotDir = strcmpi(DDname,'..');
NeitherDir = ~(DotDir | DotDotDir);
LD = LD_temp(NeitherDir);

end