function status = test_FEL_Nedelec1stKind_Deg1_triangle()
%test_FEL_Nedelec1stKind_Deg1_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 10-19-2016,  Shawn W. Walker

m_handle = @MatAssem_Nedelec1stKind_Deg1_triangle;
MEX_File_assembly = 'UNIT_TEST_mex_Assemble_FEL_Nedelec1stKind_Deg1_triangle';

[status, Path_To_Mex_assembly] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File_assembly);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile DoF allocation
Elem    = nedelec_1stkind_deg1_dim2();
MEX_File_DoF = 'UNIT_TEST_mexDoF_Nedelec1stKind_Deg1_Allocator_2D';
Test_Dir = fileparts(mfilename('fullpath'));
[status, Path_To_Mex_DoF_alloc] = Create_DoF_Allocator(Elem,MEX_File_DoF,Test_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

% compile interpolation script
Interp_Handle = @FEL_Interp_Ned1_triangle;
MEX_File_Interp = 'UNIT_TEST_mex_FEL_Interp_Ned1_triangle';
[status, Path_To_Mex_Interp] = Convert_Interp_Definition_to_MEX(Interp_Handle,{},MEX_File_Interp);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Nedelec1stKind_Deg1_triangle(MEX_File_DoF,MEX_File_assembly,MEX_File_Interp);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex files
delete([Path_To_Mex_assembly, '.*']);
delete([Path_To_Mex_DoF_alloc, '.*']);
delete([Path_To_Mex_Interp, '.*']);

end