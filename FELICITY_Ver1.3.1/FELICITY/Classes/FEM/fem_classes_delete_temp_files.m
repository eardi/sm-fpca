function status = fem_classes_delete_temp_files()
%fem_classes_delete_temp_files
%
%   Delete files.

% Copyright (c) 08-31-2016,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get a list of directories with the unit tests
Unit_Test_Dirs = fem_classes_unit_test_dirs();

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
%     stat2 = DDir.Remove_Dir(Dirs_to_Delete(ind).str2);
%     stat3 = DDir.Remove_Dir(Dirs_to_Delete(ind).str3);
%     if or(or(stat1~=0,stat2~=0),stat3~=0)
%         disp('Delete directory failed!');
%         status = -1;
%         return;
%     end
% end
% 
% % list dirs to delete
% Dirs_to_Delete.str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searching', 'TopDim_2_GeoDim_2', 'PtSearch_AutoGen');
% Dirs_to_Delete.str2 = [];
% Dirs_to_Delete.str3 = [];
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searching', 'TopDim_2_GeoDim_3', 'PtSearch_AutoGen');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,[],[]);


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

% function New_Dirs = append_dir(Dirs,str1,str2,str3)
% 
% DS.str1 = str1;
% DS.str2 = str2;
% DS.str3 = str3;
% 
% Num = length(Dirs);
% New_Dirs = Dirs; % init
% New_Dirs(Num+1) = DS;
% 
% end