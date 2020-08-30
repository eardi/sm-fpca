function status = test_matrix_assembly()
%test_matrix_assembly
%
%   Test code for FELICITY class.

% Copyright (c) 04-04-2018,  Shawn W. Walker

% do initial basic tests
test_level1_objects();
test_transformer_objects();

% store the current directory
CURRENT_DIR = pwd;

% get a list of directories with the unit tests
Unit_Test_Dirs = matrix_assembly_unit_test_dirs();

% change into each one and run test...
for ii = 1:length(Unit_Test_Dirs)
    UT_Dir = Unit_Test_Dirs(ii).str1;
    LF = FEL_Get_List_of_Files(UT_Dir);
    FileNames = FEL_Get_FileName_With_Prefix(LF,'test_FEL_');
    if isempty(FileNames)
        % do nothing
    elseif (length(FileNames)==1)
        Test_File = FileNames{1};
    else
        error('There should only be one file with the prefix!');
    end
    cd(UT_Dir);
    %Test_File
    [~, TF_Name] = fileparts(Test_File);
    Test_File_FH = str2func(TF_Name);
    %Test_File_FH
    
    status = Test_File_FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', Test_File]);
        break;
    end
end

% go back to where we were
cd(CURRENT_DIR);


% Test_Files( 1).FH = @test_level1_objects;
% Test_Files( 2).FH = @test_transformer_objects;
% Test_Files( 3).FH = @test_FEL_Mesh_Size_1D;
% Test_Files( 4).FH = @test_FEL_Assemble_1D;
% Test_Files( 5).FH = @test_FEL_Assemble_2D;
% Test_Files( 6).FH = @test_FEL_Assemble_3D;
% Test_Files( 7).FH = @test_FEL_Assemble_Coarse_Square_Codim_1;
% Test_Files( 8).FH = @test_FEL_Assemble_Refined_Square_Codim_1;
% Test_Files( 9).FH = @test_FEL_RT0_triangle;
% Test_Files(10).FH = @test_FEL_RT0_triangle_codim_1;
% 
% disp('SWW: put in unit test for Surface H(div)!!!!');
% 
% disp('SWW: put in unit test for HHJ!!!!');
% 
% disp('SWW: put in unit test for Lagrange!!!!!');
% 
% Test_Files(11).FH = @test_FEL_RT1_tetrahedron;
% Test_Files(12).FH = @test_FEL_BDM1_triangle;
% Test_Files(13).FH = @test_FEL_BDM1_triangle_codim_1;
% Test_Files(14).FH = @test_FEL_Nedelec1stKind_Deg1_triangle;
% Test_Files(15).FH = @test_FEL_Nedelec1stKind_Deg2_tetrahedron;
% Test_Files(16).FH = @test_FEL_Multiple_Subdomain_Embed_Dim_1;
% Test_Files(17).FH = @test_FEL_Multiple_Subdomain_Embed_Dim_2;
% Test_Files(18).FH = @test_FEL_Multiple_Subdomain_Embed_Dim_3;
% Test_Files(19).FH = @test_FEL_Mixed_Geometry_1;
% Test_Files(20).FH = @test_FEL_Assemble_Hessian_Ex_1D;
% Test_Files(21).FH = @test_FEL_Assemble_Hessian_Ex_2D;
% Test_Files(22).FH = @test_FEL_Assemble_Hessian_Ex_3D;
% Test_Files(23).FH = @test_FEL_Assemble_Hessian_Ex_TD_1_GD_2;
% Test_Files(24).FH = @test_FEL_Assemble_Hessian_Ex_TD_1_GD_3;
% Test_Files(25).FH = @test_FEL_Assemble_Hessian_Ex_TD_2_GD_3;
% Test_Files(26).FH = @test_FEL_Symbolic_Constants;
% Test_Files(27).FH = @test_FEL_Mixed_Domains_Constants;
% 
% for ind = 1:length(Test_Files)
%     status = Test_Files(ind).FH();
%     if (status~=0)
%         disp('Test failed!');
%         disp(['See ----> ', func2str(Test_Files(ind).FH)]);
%         break;
%     end
% end

if (status==0)
    disp('***Matrix Assembly tests passed!');
end

end