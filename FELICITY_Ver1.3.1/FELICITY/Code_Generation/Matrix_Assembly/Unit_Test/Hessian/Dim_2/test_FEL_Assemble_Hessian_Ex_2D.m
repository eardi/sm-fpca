function status = test_FEL_Assemble_Hessian_Ex_2D()
%test_FEL_Assemble_Hessian_Ex_2D
%
%   Test code for FELICITY class.

% Copyright (c) 08-14-2014,  Shawn W. Walker

m_handle = @MatAssem_Hessian_Ex_2D;
MEX_File = 'UNIT_TEST_mex_Assemble_Hessian_Ex_2D';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assemble_Hessian_Ex_2D(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end