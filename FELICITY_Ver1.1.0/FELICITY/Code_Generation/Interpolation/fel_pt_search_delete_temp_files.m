function status = fel_pt_search_delete_temp_files()
%fel_pt_search_delete_temp_files
%
%   Delete files.

% Copyright (c) 06-28-2014,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get the main directory that this class is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% list dirs to delete
Dirs_to_Delete( 1).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_1', 'Pt_Search_Code_AutoGen');
Dirs_to_Delete( 2).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_2', 'Pt_Search_Code_AutoGen');
Dirs_to_Delete( 3).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_3', 'Pt_Search_Code_AutoGen');
Dirs_to_Delete( 4).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_2', 'Pt_Search_Code_AutoGen');
Dirs_to_Delete( 5).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_2_GeoDim_3', 'Pt_Search_Code_AutoGen');
Dirs_to_Delete( 6).str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_3', 'Pt_Search_Code_AutoGen');

% delete them!
for ind = 1:length(Dirs_to_Delete)
    stat1 = DDir.Remove_Dir(Dirs_to_Delete(ind).str1);
    %stat2 = DDir.Remove_Dir(Dirs_to_Delete(ind).str2);
    %stat3 = DDir.Remove_Dir(Dirs_to_Delete(ind).str3);
    %if or(or(stat1~=0,stat2~=0),stat3~=0)
    if (stat1~=0)
        disp('Delete directory failed!');
        status = -1;
        return;
    end
end

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