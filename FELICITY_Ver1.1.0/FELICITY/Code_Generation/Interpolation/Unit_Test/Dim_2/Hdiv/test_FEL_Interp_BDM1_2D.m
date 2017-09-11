function status = test_FEL_Interp_BDM1_2D()
%test_FEL_Interp_BDM1_2D
%
%   Test code for FELICITY class.

% Copyright (c) 02-07-2013,  Shawn W. Walker

m_script = 'FEL_Interp_BDM1_triangle';
MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_BDM1_triangle';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Interp_script_to_MEX(Main_Dir,m_script,MEX_File_Interp);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
MEX_File_DoF = 'UNIT_TEST_mexDoF_BDM1_Allocator_2D_For_Interp';
Elem    = brezzi_douglas_marini_deg1_dim2();
[status, Path_To_Mex_DoF_alloc] = FEL_Compile_DoF_Allocate(Main_Dir,MEX_File_DoF,Elem);
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