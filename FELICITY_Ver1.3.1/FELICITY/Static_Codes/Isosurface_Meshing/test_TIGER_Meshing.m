function status = test_TIGER_Meshing()
%test_TIGER_Meshing
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files(1).FH = @test_Mesh_Ellipse_2D;
Test_Files(2).FH = @test_Mesh_Disk_Holes_2D;
Test_Files(3).FH = @test_Mesh_Plane_3D;
Test_Files(4).FH = @test_Mesh_Cube_3D;
Test_Files(5).FH = @test_Mesh_Sphere_3D;
Test_Files(6).FH = @test_Mesh_Box_Hole_3D;
Test_Files(7).FH = @test_Mesh_Torus_3D;
Test_Files(8).FH = @test_Mesh_Volume_3D;

S = warning('QUERY', 'MATLAB:TriRep:PtsNotInTriWarnId');
OLD_STATE = S.state;
% turn off this warning for the unit tests
warning('off', 'MATLAB:TriRep:PtsNotInTriWarnId');

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end
% put the warning back in its original state
warning(OLD_STATE, 'MATLAB:TriRep:PtsNotInTriWarnId');

if (status==0)
    disp('***Meshing TIGER Algorithm (2D & 3D) tests passed!');
end

end