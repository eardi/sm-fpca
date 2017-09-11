function status = test_GenDoFNumberingCode_2D()
%test_GenDoFNumberingCode_2D
%
%   Test code for FELICITY class.

% Copyright (c) 12-10-2010,  Shawn W. Walker

current_file = mfilename('fullpath');
Test_Dir     = fileparts(current_file);
MEX_FileName = 'UNIT_TEST_mexDoF_Allocator_2D';

% define some elements
Elem    = Elem1_2D_Test();
Elem(2) = Elem2_2D_Test();
Elem(3) = Elem3_2D_Test();
Elem(4) = Elem4_2D_Test();

[status, Path_To_Mex] = FEL_Compile_DoF_Allocate(Test_Dir,MEX_FileName,Elem);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_DoF_Allocate_2D(MEX_FileName);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end