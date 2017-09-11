function status = test_managesim_classes()
%test_managesim_classes
%
%   Test code for FELICITY class.

% Copyright (c) 08-20-2015,  Shawn W. Walker

Test_Files( 1).FH = @test_SaveLoad_1;
Test_Files( 2).FH = @test_Visualize_1;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***ManageSim Class tests passed!');
end

end