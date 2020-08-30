function status = test_interpolation_level1_objects()
%test_interpolation_level1_objects
%
%   Test code for FELICITY class.

% Copyright (c) 01-25-2013,  Shawn W. Walker

Test_Files(1).FH = @test_L1_Interpolate;
Test_Files(2).FH = @test_L1_FEL_Interpolations;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Level 1 Interpolation Object tests passed!');
end

end