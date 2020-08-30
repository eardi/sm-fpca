function status = test_fem_classes()
%test_fem_classes
%
%   Test code for FELICITY class.

% Copyright (c) 08-31-2016,  Shawn W. Walker

% do initial basic tests
test_fematrix_accessor;

% store the current directory
CURRENT_DIR = pwd;

% get a list of directories with the unit tests
Unit_Test_Dirs = fem_classes_unit_test_dirs();

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

% Test_Files(1).FH = @test_fematrix_accessor;
% Test_Files(2).FH = @test_fespace_P2_lagrange_triangle;
% Test_Files(3).FH = @test_ptsearch_mesh_T2_G2;
% Test_Files(4).FH = @test_ptsearch_mesh_T2_G3;
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
    disp('***FEM Class tests passed!');
end

end