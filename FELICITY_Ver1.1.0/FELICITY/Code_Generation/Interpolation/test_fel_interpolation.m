function status = test_fel_interpolation()
%test_fel_interpolation
%
%   Test code for FELICITY class.

% Copyright (c) 08-17-2014,  Shawn W. Walker

Test_Files( 1).FH = @test_interpolation_level1_objects;
Test_Files( 2).FH = @test_FEL_Interp_Flat_2D;
Test_Files( 3).FH = @test_FEL_Interp_BDM1_2D;
Test_Files( 4).FH = @test_FEL_Interp_Mixed_Geometry_2D;
Test_Files( 5).FH = @test_FEL_Interp_Shape_Op_1D;
Test_Files( 6).FH = @test_FEL_Interp_Shape_Op_2D;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Interpolation tests passed!');
end

end