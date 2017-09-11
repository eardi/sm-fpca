function status = test_mesh_classes()
%test_mesh_classes
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files( 1).FH = @test_Curve_1D_Mesh;
Test_Files( 2).FH = @test_Interval_1D_BaryPlot;
Test_Files( 3).FH = @test_Square_2D_Mesh;
Test_Files( 4).FH = @test_Circle_2D_Mesh;
Test_Files( 5).FH = @test_Square_2D_BaryPlot;
Test_Files( 6).FH = @test_Bisection_2D_Square;
Test_Files( 7).FH = @test_MeshTriangle_Facet_Info_1;
Test_Files( 8).FH = @test_MeshTriangle_Facet_Info_2;

Test_Files( 9).FH = @test_Cube_3D_Mesh;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Mesh Class tests passed!');
end

end