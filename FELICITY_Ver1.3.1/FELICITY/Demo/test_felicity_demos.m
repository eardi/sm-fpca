function status = test_felicity_demos()
%test_felicity_demos
%
%   Test code for FELICITY class.

% Copyright (c) 05-07-2019,  Shawn W. Walker

% do initial basic tests
%test_

% store the current directory
CURRENT_DIR = pwd;

% get a list of directories with the unit tests
Demo_Test_Dirs = demo_test_dirs();

% change into each one and run test...
for ii = 1:length(Demo_Test_Dirs)
    UT_Dir = Demo_Test_Dirs(ii).str1;
    LF = FEL_Get_List_of_Files(UT_Dir);
    FileNames = FEL_Get_FileName_With_Prefix(LF,'test_FEL_');
    if isempty(FileNames)
        % do nothing
    elseif (length(FileNames)==1)
        Demo_File = FileNames{1};
    else
        error('There should only be one file with the prefix!');
    end
    cd(UT_Dir);
    %Demo_File
    [~, TF_Name] = fileparts(Demo_File);
    Demo_File_FH = str2func(TF_Name);
    %Demo_File_FH
    
    status = Demo_File_FH();
    if (status~=0)
        disp('Test failed!');
        disp(['See ----> ', Demo_File]);
        break;
    end
end

% go back to where we were
cd(CURRENT_DIR);

% Test_Files( 1).FH = @test_Local_FE_Matrix;
% Test_Files( 2).FH = @test_Laplace_1D;
% Test_Files( 3).FH = @test_Laplace_On_Cube_3D;
% Test_Files( 4).FH = @test_Simple_Elasticity_3D;
% Test_Files( 5).FH = @test_Heat_Eqn_On_A_Surface;
% Test_Files( 6).FH = @test_Stokes_2D;
% Test_Files( 7).FH = @test_Image_Proc;
% Test_Files( 8).FH = @test_Example_DoF_Gen_2D;
% Test_Files( 9).FH = @test_Finite_Element_Space_2D;
% Test_Files(10).FH = @test_Finite_Element_Space_On_1D_Subdomain;
% Test_Files(11).FH = @test_Interp_2D;
% Test_Files(12).FH = @test_Curved_Domain_2D;
% Test_Files(13).FH = @test_Mesh_Smooth_Demo_2D;
% Test_Files(14).FH = @test_Mesh_Gen_With_Solving_PDE;
% Test_Files(15).FH = @test_Laplace_Beltrami_Open_Surface;
% Test_Files(16).FH = @test_EWOD_FalkWalker;
% Test_Files(17).FH = @test_Point_Search_Planar_Domain;
% Test_Files(18).FH = @test_Closest_Point_Sphere;
% 
% disp('***Run Demos...');
% for ind = 1:length(Test_Files)
%     status = Test_Files(ind).FH();
%     if (status~=0)
%         disp('Test failed!');
%         disp(['See ----> ', func2str(Test_Files(ind).FH)]);
%         break;
%     end
% end

if (status==0)
    disp('***Demo tests passed!');
end

end