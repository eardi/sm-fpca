function status = test_Point_Search_Planar_Domain()
%test_Point_Search_Planar_Domain
%
%   Demo code for FELICITY.

% Copyright (c) 08-01-2014,  Shawn W. Walker

m_script = 'Point_Search_Planar_Domain';
MEX_File = 'DEMO_mex_Point_Search_Planar_Domain';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_PtSearch_script_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Point_Search_Planar_Domain();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end