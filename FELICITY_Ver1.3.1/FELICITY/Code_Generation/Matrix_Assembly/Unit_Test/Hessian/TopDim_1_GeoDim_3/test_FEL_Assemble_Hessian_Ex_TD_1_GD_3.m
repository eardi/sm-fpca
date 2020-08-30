function status = test_FEL_Assemble_Hessian_Ex_TD_1_GD_3()
%test_FEL_Assemble_Hessian_Ex_TD_1_GD_3
%
%   Test code for FELICITY class.

% Copyright (c) 08-13-2014,  Shawn W. Walker

m_handle = @MatAssem_Hessian_Ex_TD_1_GD_3;
MEX_File = 'UNIT_TEST_mex_Assemble_Hessian_Ex_TD_1_GD_3';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assemble_Hessian_Ex_TD_1_GD_3(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end