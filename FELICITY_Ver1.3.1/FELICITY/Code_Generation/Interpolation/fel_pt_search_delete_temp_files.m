function status = fel_pt_search_delete_temp_files()
%fel_pt_search_delete_temp_files
%
%   Delete files.

% Copyright (c) 05-07-2019,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get a list of directories with the unit tests
Unit_Test_Dirs = pt_search_unit_test_dirs();

% delete any sub-dirs of those directories
% also delete any mex files
for ii = 1:length(Unit_Test_Dirs)
    UT_Dir = Unit_Test_Dirs(ii).str1;
    %UT_Dir
    
    % remove all mex files
    ME = mexext;
    DEL_Path_To_Mex = fullfile(UT_Dir, ['*.', ME]);
    delete(DEL_Path_To_Mex);
    
    % get all sub-dirs
    SubDir = FEL_Get_List_of_Dirs(UT_Dir);
    
    for kk = 1:length(SubDir)
        Current_SubDir = fullfile(SubDir(kk).folder, SubDir(kk).name);
        %Current_SubDir
        stat1 = DDir.Remove_Dir(Current_SubDir);
        if (stat1~=0)
            disp('Delete directory failed!');
            status = -1;
            return;
        end
    end
end

% % delete them!
% for ind = 1:length(Dirs_to_Delete)
%     stat1 = DDir.Remove_Dir(Dirs_to_Delete(ind).str1);
%     %stat2 = DDir.Remove_Dir(Dirs_to_Delete(ind).str2);
%     %stat3 = DDir.Remove_Dir(Dirs_to_Delete(ind).str3);
%     %if or(or(stat1~=0,stat2~=0),stat3~=0)
%     if (stat1~=0)
%         disp('Delete directory failed!');
%         status = -1;
%         return;
%     end
% end
% 
% 
% % list dirs to delete
% Dirs_to_Delete( 1).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_1', 'Pt_Search_Code_AutoGen');
% Dirs_to_Delete( 2).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_2', 'Pt_Search_Code_AutoGen');
% Dirs_to_Delete( 3).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_3', 'Pt_Search_Code_AutoGen');
% Dirs_to_Delete( 4).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_2', 'Pt_Search_Code_AutoGen');
% Dirs_to_Delete( 5).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_2_GeoDim_3', 'Pt_Search_Code_AutoGen');
% Dirs_to_Delete( 6).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_3', 'Pt_Search_Code_AutoGen');


% % delete some remaining files
% Files_to_Delete(1).str = fullfile(Main_Dir, 'Samples', 'mex_Assemble_Example_1D');
% 
% % delete them!
% for ind = 1:length(Files_to_Delete)
%     stat1 = DDir.Delete_File_All_Ext(Files_to_Delete(ind).str);
%     if (stat1~=0)
%         disp('Delete File failed!');
%         status = -1;
%         return;
%     end
% end

end