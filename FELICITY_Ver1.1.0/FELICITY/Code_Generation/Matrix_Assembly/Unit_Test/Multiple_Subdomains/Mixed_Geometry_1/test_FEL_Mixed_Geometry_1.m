function status = test_FEL_Mixed_Geometry_1()
%test_FEL_Mixed_Geometry_1
%
%   Test code for FELICITY class.

% Copyright (c) 01-24-2014,  Shawn W. Walker

m_script = 'Mixed_Geometry_1';
MEX_File = 'UNIT_TEST_mex_Mixed_Geometry_1';

% get directory that this mfile lives in
Main_Dir = fileparts(mfilename('fullpath'));

[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,m_script,MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Mixed_Geometry_1(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end