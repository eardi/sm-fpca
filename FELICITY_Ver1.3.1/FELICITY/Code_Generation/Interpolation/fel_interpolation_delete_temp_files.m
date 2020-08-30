function status = fel_interpolation_delete_temp_files()
%fel_interpolation_delete_temp_files
%
%   Delete files.

% Copyright (c) 01-20-2018,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get a list of directories with the unit tests
Unit_Test_Dirs = interpolation_unit_test_dirs();

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


% % list dirs to delete
% Dirs_to_Delete( 1).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Flat_Domain', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete( 1).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Flat_Domain', 'Scratch_Dir');
% Dirs_to_Delete( 2).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Symbolic_Constant', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete( 2).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Symbolic_Constant', 'Scratch_Dir');
% Dirs_to_Delete( 3).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Hdiv', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete( 3).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Hdiv', 'Scratch_Dir');
% Dirs_to_Delete( 3).str3 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Hdiv', 'AutoGen_DoFNumbering');
% Dirs_to_Delete( 4).str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Mixed_Geometry', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete( 4).str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Mixed_Geometry', 'Scratch_Dir');
% Dirs_to_Delete( 5).str1 = fullfile(Main_Dir, 'Unit_Test', 'TopDim_1_GeoDim_3', 'Shape_Operator', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete( 5).str2 = fullfile(Main_Dir, 'Unit_Test', 'TopDim_1_GeoDim_3', 'Shape_Operator', 'Scratch_Dir');
% Dirs_to_Delete( 6).str1 = fullfile(Main_Dir, 'Unit_Test', 'TopDim_2_GeoDim_3', 'Shape_Operator', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete( 6).str2 = fullfile(Main_Dir, 'Unit_Test', 'TopDim_2_GeoDim_3', 'Shape_Operator', 'Scratch_Dir');



% % % delete some remaining files
% % Files_to_Delete(1).str = fullfile(Main_Dir, 'Samples', 'mex_Assemble_Example_1D');
% % 
% % % delete them!
% % for ind = 1:length(Files_to_Delete)
% %     stat1 = DDir.Delete_File_All_Ext(Files_to_Delete(ind).str);
% %     if (stat1~=0)
% %         disp('Delete File failed!');
% %         status = -1;
% %         return;
% %     end
% % end

end