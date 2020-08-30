function status = test_FEL_Interp_BDM1_2D()
%test_FEL_Interp_BDM1_2D
%
%   Test code for FELICITY class.

% Copyright (c) 02-07-2013,  Shawn W. Walker

Interp_Handle = @FEL_Interp_BDM1_triangle;
MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_BDM1_triangle';

[status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{},MEX_File_Interp);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
Elem = brezzi_douglas_marini_deg1_dim2();
MEX_File_DoF = 'UNIT_TEST_mexDoF_BDM1_Allocator_2D_For_Interp';
Test_Dir = fileparts(mfilename('fullpath'));
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(Elem,MEX_File_DoF,Test_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Interp_BDM1_2D(MEX_File_DoF,MEX_File_Interp);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);
delete([Path_To_Mex_DoF_alloc, '.*']);

end