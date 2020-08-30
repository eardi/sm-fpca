function status = test_GenDoFNumberingCode_3D()
%test_GenDoFNumberingCode_3D
%
%   Test code for FELICITY class.

% Copyright (c) 12-10-2010,  Shawn W. Walker

current_file = mfilename('fullpath');
Test_Dir     = fileparts(current_file);
MEX_FileName = 'UNIT_TEST_mexDoF_Allocator_3D';

% define some elements
Elem    = Elem1_3D_Test();
Elem(2) = Elem2_3D_Test();
Elem(3) = Elem3_3D_Test();
Elem(4) = Elem4_3D_Test();
Elem(5) = Elem5_3D_Test();

[status, Path_To_Mex] = Create_DoF_Allocator(Elem,MEX_FileName,Test_Dir);
if status~=0
    disp('Compile did not succeed.');
    return;
end

status = FEL_Execute_DoF_Allocate_3D(MEX_FileName);
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

% remove the mex file
delete([Path_To_Mex, '.*']);

end