function status = test_fem_classes()
%test_fem_classes
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_fematrix_accessor;
Test_Files(2).FH = @test_fespace_P2_lagrange_triangle;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***FEM Class tests passed!');
end

end