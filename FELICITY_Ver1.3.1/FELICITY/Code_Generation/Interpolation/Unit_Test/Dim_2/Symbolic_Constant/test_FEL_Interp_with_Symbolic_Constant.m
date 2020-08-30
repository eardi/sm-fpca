function status = test_FEL_Interp_with_Symbolic_Constant()
%test_FEL_Interp_with_Symbolic_Constant
%
%   Test code for FELICITY class.

% Copyright (c) 01-20-2018,  Shawn W. Walker

Interp_Handle = @FEL_Interp_with_Symbolic_Constant;
MEX_File = 'UNIT_TEST_mex_FEL_Interp_with_Symbolic_Constant';

[status, Path_To_Mex] = Convert_Interp_Definition_to_MEX(Interp_Handle,{},MEX_File);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_Interp_with_Symbolic_Constant(MEX_File);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end