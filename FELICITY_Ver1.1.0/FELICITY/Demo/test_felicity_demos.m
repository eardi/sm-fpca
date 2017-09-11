function status = test_felicity_demos()
%test_felicity_demos
%
%   Test code for FELICITY class.

% Copyright (c) 04-08-2013,  Shawn W. Walker

Test_Files( 1).FH = @test_Laplace_1D;
Test_Files( 2).FH = @test_Laplace_On_Cube_3D;
Test_Files( 3).FH = @test_Simple_Elasticity_3D;
Test_Files( 4).FH = @test_Heat_Eqn_On_A_Surface;
Test_Files( 5).FH = @test_Stokes_2D;
Test_Files( 6).FH = @test_Image_Proc;
Test_Files( 7).FH = @test_Example_DoF_Gen_2D;
Test_Files( 8).FH = @test_Finite_Element_Space_2D;
Test_Files( 9).FH = @test_Finite_Element_Space_On_1D_Subdomain;
Test_Files(10).FH = @test_Interp_2D;
Test_Files(11).FH = @test_Mesh_Smooth_Demo_2D;
Test_Files(12).FH = @test_Mesh_Gen_With_Solving_PDE;
Test_Files(13).FH = @test_Point_Search_Planar_Domain;
Test_Files(14).FH = @test_Closest_Point_Sphere;

disp('***Run Demos...');
for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Demo tests passed!');
end

end