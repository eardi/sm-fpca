function status = test_matrix_assembly()
%test_matrix_assembly
%
%   Test code for FELICITY class.

% Copyright (c) 01-01-2011,  Shawn W. Walker

Test_Files( 1).FH = @test_level1_objects;
Test_Files( 2).FH = @test_transformer_objects;
Test_Files( 3).FH = @test_FEL_Mesh_Size_1D;
Test_Files( 4).FH = @test_FEL_Assemble_1D;
Test_Files( 5).FH = @test_FEL_Assemble_2D;
Test_Files( 6).FH = @test_FEL_Assemble_3D;
Test_Files( 7).FH = @test_FEL_Assemble_Coarse_Square_Codim_1;
Test_Files( 8).FH = @test_FEL_Assemble_Refined_Square_Codim_1;
Test_Files( 9).FH = @test_FEL_RT0_triangle;
Test_Files(10).FH = @test_FEL_RT0_triangle_codim_1;
Test_Files(11).FH = @test_FEL_BDM1_triangle;
Test_Files(12).FH = @test_FEL_BDM1_triangle_codim_1;
Test_Files(13).FH = @test_FEL_Multiple_Subdomain_Embed_Dim_1;
Test_Files(14).FH = @test_FEL_Multiple_Subdomain_Embed_Dim_2;
Test_Files(15).FH = @test_FEL_Multiple_Subdomain_Embed_Dim_3;
Test_Files(16).FH = @test_FEL_Mixed_Geometry_1;
Test_Files(17).FH = @test_FEL_Assemble_Hessian_Ex_1D;
Test_Files(18).FH = @test_FEL_Assemble_Hessian_Ex_2D;
Test_Files(19).FH = @test_FEL_Assemble_Hessian_Ex_3D;
Test_Files(20).FH = @test_FEL_Assemble_Hessian_Ex_TD_1_GD_2;
Test_Files(21).FH = @test_FEL_Assemble_Hessian_Ex_TD_1_GD_3;
Test_Files(22).FH = @test_FEL_Assemble_Hessian_Ex_TD_2_GD_3;

for ind = 1:length(Test_Files)
    status = Test_Files(ind).FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', func2str(Test_Files(ind).FH)]);
        break;
    end
end

if (status==0)
    disp('***Matrix Assembly tests passed!');
end

end