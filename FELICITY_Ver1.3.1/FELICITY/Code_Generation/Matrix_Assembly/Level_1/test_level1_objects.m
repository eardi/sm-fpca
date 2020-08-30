function status = test_level1_objects()
%test_level1_objects
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_L1_Domain;
Test_Files(2).FH = @test_L1_Element;
Test_Files(3).FH = @test_L1_Integral;
Test_Files(4).FH = @test_L1_genericform;
Test_Files(5).FH = @test_L1_GeoElement;
Test_Files(6).FH = @test_L1_GeoFunc;
Test_Files(7).FH = @test_L1_l1func;
Test_Files(8).FH = @test_L1_Matrices;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Level 1 Object tests passed!');
end

end