function status = test_mesh_classes()
%test_mesh_classes
%
%   Test code for FELICITY class.

% Copyright (c) 05-07-2019,  Shawn W. Walker

% do initial basic tests
%test_

% store the current directory
CURRENT_DIR = pwd;

% get a list of directories with the unit tests
Unit_Test_Dirs = mesh_classes_unit_test_dirs();

% change into each one and run test...
for ii = 1:length(Unit_Test_Dirs)
    UT_Dir = Unit_Test_Dirs(ii).str1;
    
    LF = FEL_Get_List_of_Files(UT_Dir);
    FileNames = FEL_Get_FileName_With_Prefix(LF,'test_FEL_');
    
    if isempty(FileNames)
        % do nothing
    elseif (length(FileNames)<=4)
        % do nothing
    else
        error('There should be no more than four files with the prefix!');
    end
    cd(UT_Dir);
    
    for ff = 1:length(FileNames)
        Test_File = FileNames{ff};
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
end

% go back to where we were
cd(CURRENT_DIR);

% Test_Files( 1).FH = @test_Curve_1D_Mesh;
% Test_Files( 2).FH = @test_Interval_1D_BaryPlot;
% Test_Files( 3).FH = @test_Square_2D_Mesh;
% Test_Files( 4).FH = @test_Circle_2D_Mesh;
% Test_Files( 5).FH = @test_Square_2D_BaryPlot;
% Test_Files( 6).FH = @test_Bisection_2D_Square;
% Test_Files( 7).FH = @test_MeshTriangle_Facet_Info_1;
% Test_Files( 8).FH = @test_MeshTriangle_Facet_Info_2;
% 
% Test_Files( 9).FH = @test_Cube_3D_Mesh;
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
    disp('***Mesh Class tests passed!');
end

end