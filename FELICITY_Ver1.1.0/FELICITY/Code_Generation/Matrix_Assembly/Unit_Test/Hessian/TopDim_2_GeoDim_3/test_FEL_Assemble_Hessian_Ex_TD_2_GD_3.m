function status = test_FEL_Assemble_Hessian_Ex_TD_2_GD_3()
%test_FEL_Assemble_Hessian_Ex_TD_2_GD_3
%
%   Test code for FELICITY class.

% Copyright (c) 08-14-2014,  Shawn W. Walker

m_script = 'MatAssem_Hessian_Ex_TD_2_GD_3';
MEX_File = 'UNIT_TEST_mex_Assemble_Hessian_Ex_TD_2_GD_3';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assemble_Hessian_Ex_TD_2_GD_3(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end