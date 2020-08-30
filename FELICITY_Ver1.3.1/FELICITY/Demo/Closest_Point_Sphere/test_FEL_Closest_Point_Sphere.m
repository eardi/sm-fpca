function status = test_FEL_Closest_Point_Sphere()
%test_FEL_Closest_Point_Sphere
%
%   Demo code for FELICITY.

% Copyright (c) 07-24-2014,  Shawn W. Walker

Search_Handle = @Point_Search_Sphere;
MEX_File = 'DEMO_mex_Point_Search_Sphere';

[status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = Execute_Closest_Point_Sphere();

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end