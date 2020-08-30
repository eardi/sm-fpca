function status = test_fel_pt_search()
%test_fel_pt_search
%
%   Test code for FELICITY class.

% Copyright (c) 07-24-2014,  Shawn W. Walker

% do initial basic tests
%%%test_

% store the current directory
CURRENT_DIR = pwd;

% get a list of directories with the unit tests
Unit_Test_Dirs = pt_search_unit_test_dirs();

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

% Test_Files( 1).FH = @test_FEL_Pt_Search_1D;
% Test_Files( 2).FH = @test_FEL_Pt_Search_Curve_In_2D;
% Test_Files( 3).FH = @test_FEL_Pt_Search_Curve_In_3D;
% Test_Files( 4).FH = @test_FEL_Pt_Search_2D;
% Test_Files( 5).FH = @test_FEL_Pt_Search_Surface_In_3D;
% Test_Files( 6).FH = @test_FEL_Pt_Search_3D;
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
    disp('***Point Search tests passed!');
end

end