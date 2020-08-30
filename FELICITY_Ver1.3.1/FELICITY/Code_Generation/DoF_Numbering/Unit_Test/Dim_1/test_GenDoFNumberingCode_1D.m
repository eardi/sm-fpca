function status = test_GenDoFNumberingCode_1D()
%test_GenDoFNumberingCode_1D
%
%   Test code for FELICITY class.

% Copyright (c) 12-10-2010,  Shawn W. Walker

current_file = mfilename('fullpath');
Test_Dir     = fileparts(current_file);
MEX_FileName = 'UNIT_TEST_mexDoF_Allocator_1D';

% define some elements
Elem    = Elem1_1D_Test();
Elem(2) = Elem2_1D_Test();
Elem(3) = Elem3_1D_Test();
Elem(4) = Elem4_1D_Test();

[status, Path_To_Mex] = Create_DoF_Allocator(Elem,MEX_FileName,Test_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_DoF_Allocate_1D(MEX_FileName);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end