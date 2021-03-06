function status = test_FEL_BDM1_triangle_codim_1()
%test_FEL_BDM1_triangle_codim_1
%
%   Test code for FELICITY class.

% Copyright (c) 05-21-2013,  Shawn W. Walker

m_handle = @MatAssem_BDM1_triangle_codim_1;
MEX_File_assembly = 'UNIT_TEST_mex_Assemble_FEL_BDM1_triangle_codim_1';

[status, Path_To_Mex_assembly] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File_assembly);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
Elem    = brezzi_douglas_marini_deg1_dim2();
MEX_File_DoF = 'UNIT_TEST_mexDoF_BDM1_Allocator_2D_Codim_1';
Test_Dir = fileparts(mfilename('fullpath'));
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(Elem,MEX_File_DoF,Test_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_BDM1_triangle_codim_1(MEX_File_DoF,MEX_File_assembly);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex files
delete([Path_To_Mex_assembly, '.*']);
delete([Path_To_Mex_DoF_alloc, '.*']);

end