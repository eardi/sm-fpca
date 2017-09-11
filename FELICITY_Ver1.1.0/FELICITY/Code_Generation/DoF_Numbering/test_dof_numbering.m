function status = test_dof_numbering()
%test_dof_numbering
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_GenDoFNumberingCode_1D;
Test_Files(2).FH = @test_GenDoFNumberingCode_2D;
Test_Files(3).FH = @test_GenDoFNumberingCode_3D;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***DoF Numbering tests passed!');
end

end