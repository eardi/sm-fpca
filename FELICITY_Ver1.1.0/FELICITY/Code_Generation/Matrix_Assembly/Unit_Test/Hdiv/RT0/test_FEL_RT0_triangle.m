function status = test_FEL_RT0_triangle()
%test_FEL_RT0_triangle
%
%   Test code for FELICITY class.

% Copyright (c) 03-22-2012,  Shawn W. Walker

m_script = 'MatAssem_RT0_triangle';
MEX_File = 'UNIT_TEST_mex_Assemble_FEL_RT0_triangle';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_RT0_triangle(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end