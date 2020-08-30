function status = test_fel_interpolation()
%test_fel_interpolation
%
%   Test code for FELICITY class.

% Copyright (c) 05-07-2019,  Shawn W. Walker

% do initial basic tests
test_interpolation_level1_objects();

% store the current directory
CURRENT_DIR = pwd;

% get a list of directories with the unit tests
Unit_Test_Dirs = interpolation_unit_test_dirs();

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

% Test_Files( 1).FH = @test_interpolation_level1_objects;
% Test_Files( 2).FH = @test_FEL_Interp_Flat_2D;
% Test_Files( 3).FH = @test_FEL_Interp_with_Symbolic_Constant;
% Test_Files( 4).FH = @test_FEL_Interp_BDM1_2D;
% Test_Files( 5).FH = @test_FEL_Interp_Mixed_Geometry_2D;
% Test_Files( 6).FH = @test_FEL_Interp_Shape_Op_1D;
% Test_Files( 7).FH = @test_FEL_Interp_Shape_Op_2D;
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
    disp('***Interpolation tests passed!');
end

end