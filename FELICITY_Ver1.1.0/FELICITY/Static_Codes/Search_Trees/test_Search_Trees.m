function status = test_Search_Trees()
%test_Search_Trees
%
%   Test code for FELICITY class.

% Copyright (c) 01-14-2014,  Shawn W. Walker

Test_Files(1).FH = @test_Bitree_Random_Points;
Test_Files(2).FH = @test_Bitree_Moving_Points;
Test_Files(3).FH = @test_Quadtree_Random_Points;
Test_Files(4).FH = @test_Quadtree_Moving_Points;
Test_Files(5).FH = @test_Octree_Random_Points;
Test_Files(6).FH = @test_Octree_Moving_Points;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Search Tree (1D, 2D, and 3D) tests passed!');
end

end