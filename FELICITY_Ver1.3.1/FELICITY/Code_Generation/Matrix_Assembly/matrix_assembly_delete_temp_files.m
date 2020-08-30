function status = matrix_assembly_delete_temp_files()
%matrix_assembly_delete_temp_files
%
%   Delete files.

% Copyright (c) 01-18-2018,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get a list of directories with the unit tests
Unit_Test_Dirs = matrix_assembly_unit_test_dirs();

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

% 
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
% 
% 
% 
% % list dirs to delete
% Dirs_to_Delete.str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_1', 'Assembly_Code_AutoGen');
% Dirs_to_Delete.str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_1', 'Scratch_Dir');
% Dirs_to_Delete.str3 = [];
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Dim_3', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Coarse_Square', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Coarse_Square', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Refined_Square', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Refined_Square', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0_Codim_1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0_Codim_1', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT1_Surface', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT1_Surface', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT1_Dim3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT1_Dim3', 'Scratch_Dir');
% str3 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT1_Dim3', 'AutoGen_DoFNumbering');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,str3);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1', 'Scratch_Dir');
% str3 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1', 'AutoGen_DoFNumbering');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,str3);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1', 'Scratch_Dir');
% str3 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1', 'AutoGen_DoFNumbering');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,str3);
% %
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdivdiv', 'HHJk', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hdivdiv', 'HHJk', 'Scratch_Dir');
% 
% disp('SWW: delete DoF allocator for HHJ!');
% 
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% %
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg1_Dim2', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg1_Dim2', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg1_Dim2', 'AutoGen_DoFNumbering');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg1_Dim2', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% %
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg2_Dim3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg2_Dim3', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg2_Dim3', 'AutoGen_DoFNumbering');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg2_Dim3', 'Interpolation_Code_AutoGen');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% %
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_1', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_2', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_2', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_3', 'Scratch_Dir');
% str3 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_3', 'AutoGen_DoFNumbering');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,str3);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_2', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_2', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_3', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_2_GeoDim_3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_2_GeoDim_3', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Mesh_Size', 'Dim_1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Mesh_Size', 'Dim_1', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_1', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_2', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_2', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_3', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_3', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Mixed_Geometry_1', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Mixed_Geometry_1', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Symbolic_Constants', 'Dim_2', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Symbolic_Constants', 'Dim_2', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% str1 = fullfile(Main_Dir, 'Unit_Test', 'Symbolic_Constants', 'Mixed_Domains', 'Assembly_Code_AutoGen');
% str2 = fullfile(Main_Dir, 'Unit_Test', 'Symbolic_Constants', 'Mixed_Domains', 'Scratch_Dir');
% Dirs_to_Delete = append_dir(Dirs_to_Delete,str1,str2,[]);
% 
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
% 
% end
% 
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