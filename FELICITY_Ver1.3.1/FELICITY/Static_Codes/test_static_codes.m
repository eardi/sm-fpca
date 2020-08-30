function status = test_static_codes()
%test_static_codes
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_lepp_2D;
Test_Files(2).FH = @test_eikonal2D;
Test_Files(3).FH = @test_TIGER_Meshing;
Test_Files(4).FH = @test_Mesh_Smooth;
Test_Files(5).FH = @test_Search_Trees;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Static Code tests passed!');
end

end