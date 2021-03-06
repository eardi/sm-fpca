function status = test_FEL_Symbolic_Constants()
%test_FEL_Symbolic_Constants
%
%   Test code for FELICITY.

% Copyright (c) 01-18-2018,  Shawn W. Walker

m_handle = @MatAssem_Symbolic_Constants;
MEX_File = 'UNIT_TEST_mex_Assemble_Symbolic_Constants';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assemble_Symbolic_Constants(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end