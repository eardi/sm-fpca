function status = test_FEL_Mixed_Geometry_1()
%test_FEL_Mixed_Geometry_1
%
%   Test code for FELICITY class.

% Copyright (c) 01-24-2014,  Shawn W. Walker

m_handle = @Mixed_Geometry_1;
MEX_File = 'UNIT_TEST_mex_Mixed_Geometry_1';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
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