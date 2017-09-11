function status = test_FEL_Assemble_1D()
%test_FEL_Assemble_1D
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

m_script = 'MatAssem_interval';
MEX_File = 'UNIT_TEST_mex_Assemble_FEL_interval';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assemble_1D(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end