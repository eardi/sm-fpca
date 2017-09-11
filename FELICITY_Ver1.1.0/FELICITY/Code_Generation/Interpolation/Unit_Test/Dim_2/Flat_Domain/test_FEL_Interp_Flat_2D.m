function status = test_FEL_Interp_Flat_2D()
%test_FEL_Interp_Flat_2D
%
%   Test code for FELICITY class.

% Copyright (c) 01-25-2013,  Shawn W. Walker

m_script = 'FEL_Interp_Flat_triangle';
MEX_File = 'UNIT_TEST_mex_FEL_Interp_Flat_triangle';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Interp_script_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Interp_Flat_2D(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end