function status = test_FEL_BDM1_triangle()
%test_FEL_BDM1_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 04-03-2012,  Shawn W. Walker

m_script = 'MatAssem_BDM1_triangle';
MEX_File_assembly = 'UNIT_TEST_mex_Assemble_FEL_BDM1_triangle';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

% compile matrix assembly
[status, Path_To_Mex_assembly] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File_assembly);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
MEX_File_DoF = 'UNIT_TEST_mexDoF_BDM1_Allocator_2D';
Elem    = brezzi_douglas_marini_deg1_dim2();
[status, Path_To_Mex_DoF_alloc] = FEL_Compile_DoF_Allocate(Main_Dir,MEX_File_DoF,Elem);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_BDM1_triangle(MEX_File_DoF,MEX_File_assembly);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex files
delete([Path_To_Mex_assembly, '.*']);
delete([Path_To_Mex_DoF_alloc, '.*']);

end