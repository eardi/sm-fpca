function status = test_FEL_Pt_Search_3D()
%test_FEL_Pt_Search_3D
%
%   Test code for FELICITY class.

% Copyright (c) 07-25-2014,  Shawn W. Walker

Search_Handle = @FEL_Pt_Search_tetrahedron;
MEX_File = 'UNIT_TEST_mex_FEL_Pt_Search_tetrahedron';

[status, Path_To_Mex] = Convert_PtSearch_Definition_to_MEX(Search_Handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Pt_Search_3D(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end