function status = test_Mesh_Smooth()
%test_Mesh_Smooth
%
%   Test code for FELICITY class.

% Copyright (c) 04-23-2013,  Shawn W. Walker

Test_Files(1).FH = @test_FEL_Mesh_Smooth_1D;
Test_Files(2).FH = @test_FEL_Mesh_Smooth_2D;
Test_Files(3).FH = @test_FEL_Mesh_Smooth_3D;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Mesh Smoothing tests passed!');
end

end