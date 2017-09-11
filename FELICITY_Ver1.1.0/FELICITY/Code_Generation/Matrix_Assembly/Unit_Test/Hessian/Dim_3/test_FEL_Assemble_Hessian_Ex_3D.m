function status = test_FEL_Assemble_Hessian_Ex_3D()
%test_FEL_Assemble_Hessian_Ex_3D
%
%   Test code for FELICITY class.

% Copyright (c) 08-14-2014,  Shawn W. Walker

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

% compile matrix assembly
m_script          = 'MatAssem_Hessian_Ex_3D';
MEX_File_assembly = 'UNIT_TEST_mex_Assemble_Hessian_Ex_3D';
[status, Path_To_Mex_assembly] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File_assembly);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
MEX_File_DoF = 'UNIT_TEST_mexDoF_LagP2_Allocator_3D';
Elem         = lagrange_deg2_dim3();
[status, Path_To_Mex_DoF_alloc] = FEL_Compile_DoF_Allocate(Main_Dir,MEX_File_DoF,Elem);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assemble_Hessian_Ex_3D(MEX_File_DoF,MEX_File_assembly);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex files
delete([Path_To_Mex_assembly, '.*']);
delete([Path_To_Mex_DoF_alloc, '.*']);

end