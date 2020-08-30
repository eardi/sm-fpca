function status = test_FEL_Point_Search_Planar_Domain()
%test_FEL_Point_Search_Planar_Domain
%
%   Demo code for FELICITY.

% Copyright (c) 08-01-2014,  Shawn W. Walker

Search_Handle = @Point_Search_Planar_Domain;
MEX_File = 'DEMO_mex_Point_Search_Planar_Domain';

[status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Point_Search_Planar_Domain();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end