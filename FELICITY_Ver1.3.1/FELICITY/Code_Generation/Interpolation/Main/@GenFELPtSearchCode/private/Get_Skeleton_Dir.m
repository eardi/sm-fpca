function Skeleton_Dir = Get_Skeleton_Dir()
%Get_Skeleton_Dir
%
%   This just retrieves the full directory for the skeleton code repository.

% Copyright (c) 06-28-2014,  Shawn W. Walker

current_file   = mfilename('fullpath');
private_Dir    = fileparts(current_file);
Sub_Dir        = 'Pt_Search_Code_Skeleton';
Skeleton_Dir   = fullfile(private_Dir,Sub_Dir);

end