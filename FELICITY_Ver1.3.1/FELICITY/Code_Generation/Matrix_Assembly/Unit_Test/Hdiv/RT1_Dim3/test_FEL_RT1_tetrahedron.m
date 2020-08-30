function status = test_FEL_RT1_tetrahedron()
%test_FEL_RT1_tetrahedron
%
%   Test code for FELICITY class.

% Copyright (c) 10-17-2016,  Shawn W. Walker

m_handle = @MatAssem_RT1_tetrahedron;
MEX_File_Assembly = 'UNIT_TEST_mex_Assemble_FEL_RT1_tetrahedron';

[status, Path_To_Mex_assembly] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File_Assembly);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
Elem    = raviart_thomas_deg1_dim3();
MEX_File_DoF = 'UNIT_TEST_mexDoF_RT1_Allocator_3D';
Test_Dir = fileparts(mfilename('fullpath'));
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(Elem,MEX_File_DoF,Test_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_RT1_tetrahedron(MEX_File_DoF,MEX_File_Assembly);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex files
delete([Path_To_Mex_assembly, '.*']);
delete([Path_To_Mex_DoF_alloc, '.*']);

end