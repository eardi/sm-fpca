function Skeleton_Dir = Get_Skeleton_Dir()
%Get_Skeleton_Dir
%
%   This just retrieves the full directory for the skeleton code repository.

% Copyright (c) 04-10-2010,  Shawn W. Walker

current_file   = mfilename('fullpath');
private_Dir    = fileparts(current_file);
Sub_Dir        = 'Domain_snippets';
Skeleton_Dir   = fullfile(private_Dir,Sub_Dir);

end