function status = test_FEL_Assem_Subset_2D()
%test_FEL_Assem_Subset_2D
%
%   Test code for FELICITY class.

% Copyright (c) 05-07-2019,  Shawn W. Walker

m_handle = @MatAssem_Subset_2D;
MEX_File = 'UNIT_TEST_mex_Assemble_Subset_2D';

[status, Path_To_Mex] = Convert_Form_Definition_to_MEX(m_handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Assem_Subset_2D();
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% % remove the mex file
% delete([Path_To_Mex, '.*']);

end