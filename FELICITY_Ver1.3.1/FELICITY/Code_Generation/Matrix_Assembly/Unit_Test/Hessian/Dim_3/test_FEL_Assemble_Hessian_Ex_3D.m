function status = test_FEL_Assemble_Hessian_Ex_3D()
%test_FEL_Assemble_Hessian_Ex_3D
%
%   Test code for FELICITY class.

% Copyright (c) 08-14-2014,  Shawn W. Walker

m_handle = @MatAssem_Hessian_Ex_3D;
MEX_File_assembly = 'UNIT_TEST_mex_Assemble_Hessian_Ex_3D';

[status, Path_To_Mex_assembly] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File_assembly);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
Elem         = lagrange_deg2_dim3();
MEX_File_DoF = 'UNIT_TEST_mexDoF_LagP2_Allocator_3D';
Test_Dir = fileparts(mfilename('fullpath'));
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(Elem,MEX_File_DoF,Test_Dir);
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