function status = demo_delete_temp_files()
%demo_delete_temp_files
%
%   Delete files.

% Copyright (c) 05-07-2019,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get a list of directories with the unit tests
Demo_Test_Dirs = demo_test_dirs();

% delete any sub-dirs of those directories
% also delete any mex files
for ii = 1:length(Demo_Test_Dirs)
    UT_Dir = Demo_Test_Dirs(ii).str1;
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
%     for kk = 1:length(Dirs_to_Delete(ind).str1)
%         stat1 = DDir.Remove_Dir(Dirs_to_Delete(ind).str1{kk});
%         if (stat1~=0)
%             disp('Delete directory failed!');
%             status = -1;
%             return;
%         end
%     end
% end
% 
% % list dirs to delete
% Dirs_to_Delete( 1).str1 = {fullfile(Main_Dir, 'Local_FE_Matrix', 'MatAssem_Local_FE_Matrix_CodeGen_interval');
%                            fullfile(Main_Dir, 'Local_FE_Matrix', 'MatAssem_Local_FE_Matrix_CodeGen_triangle');
%                            fullfile(Main_Dir, 'Local_FE_Matrix', 'MatAssem_Local_FE_Matrix_CodeGen_tetrahedron');
%                            fullfile(Main_Dir, 'Local_FE_Matrix', 'Scratch_Dir')};
% Dirs_to_Delete( 2).str1 = {fullfile(Main_Dir, 'Laplace_1D', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Laplace_1D', 'Scratch_Dir')};
% Dirs_to_Delete( 3).str1 = {fullfile(Main_Dir, 'Laplace_On_Cube_3D', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Laplace_On_Cube_3D', 'Scratch_Dir')};
% Dirs_to_Delete( 4).str1 = {fullfile(Main_Dir, 'Simple_Elasticity_3D', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Simple_Elasticity_3D', 'Scratch_Dir')};
% Dirs_to_Delete( 5).str1 = {fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface', 'Scratch_Dir')};
% Dirs_to_Delete( 6).str1 = {fullfile(Main_Dir, 'Stokes_2D', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Stokes_2D', 'Scratch_Dir');
%                            fullfile(Main_Dir, 'Stokes_2D', 'AutoGen_DoFNumbering')};
% Dirs_to_Delete( 7).str1 = {fullfile(Main_Dir, 'Image_Processing', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Image_Processing', 'Scratch_Dir')};
% Dirs_to_Delete( 8).str1 = {fullfile(Main_Dir, 'DoFmap_Generation', 'Dim_2', 'AutoGen_DoFNumbering')};
% Dirs_to_Delete( 9).str1 = {fullfile(Main_Dir, 'Curved_Domain_2D', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Curved_Domain_2D', 'Scratch_Dir');
%                            fullfile(Main_Dir, 'Curved_Domain_2D', 'AutoGen_DoFNumbering');
%                            fullfile(Main_Dir, 'Curved_Domain_2D', 'Interpolation_Code_AutoGen')};
% Dirs_to_Delete(10).str1 = {fullfile(Main_Dir, 'Laplace_Beltrami_Open_Surface', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Laplace_Beltrami_Open_Surface', 'Scratch_Dir');
%                            fullfile(Main_Dir, 'Laplace_Beltrami_Open_Surface', 'AutoGen_DoFNumbering');
%                            fullfile(Main_Dir, 'Laplace_Beltrami_Open_Surface', 'Interpolation_Code_AutoGen')};
% Dirs_to_Delete(11).str1 = {fullfile(Main_Dir, 'EWOD', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'EWOD', 'Scratch_Dir');
%                            fullfile(Main_Dir, 'EWOD', 'AutoGen_DoFNumbering')};
% Dirs_to_Delete(12).str1 = {fullfile(Main_Dir, 'Interp_2D', 'Interpolation_Code_AutoGen');
%                            fullfile(Main_Dir, 'Interp_2D', 'Scratch_Dir')};
% Dirs_to_Delete(13).str1 = {fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE', 'Assembly_Code_AutoGen');
%                            fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE', 'Scratch_Dir')};
% Dirs_to_Delete(14).str1 = {fullfile(Main_Dir, 'Point_Search_Domain_2D', 'Pt_Search_Code_AutoGen')};
% Dirs_to_Delete(15).str1 = {fullfile(Main_Dir, 'Closest_Point_Sphere', 'Pt_Search_Code_AutoGen')};
% 
% % can make this more efficient by using data above??
% % delete some mex files
% Files_to_Delete( 1).str = fullfile(Main_Dir, 'Local_FE_Matrix');
% Files_to_Delete( 2).str = fullfile(Main_Dir, 'Laplace_1D');
% Files_to_Delete( 3).str = fullfile(Main_Dir, 'Laplace_On_Cube_3D');
% Files_to_Delete( 4).str = fullfile(Main_Dir, 'Simple_Elasticity_3D');
% Files_to_Delete( 5).str = fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface');
% Files_to_Delete( 6).str = fullfile(Main_Dir, 'Stokes_2D');
% Files_to_Delete( 7).str = fullfile(Main_Dir, 'Image_Processing');
% Files_to_Delete( 8).str = fullfile(Main_Dir, 'DoFmap_Generation');
% Files_to_Delete( 9).str = fullfile(Main_Dir, 'Curved_Domain_2D');
% Files_to_Delete(10).str = fullfile(Main_Dir, 'Laplace_Beltrami_Open_Surface');
% Files_to_Delete(11).str = fullfile(Main_Dir, 'EWOD');
% Files_to_Delete(12).str = fullfile(Main_Dir, 'Interp_2D');
% Files_to_Delete(13).str = fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE');
% Files_to_Delete(14).str = fullfile(Main_Dir, 'Point_Search_Domain_2D');
% Files_to_Delete(15).str = fullfile(Main_Dir, 'Closest_Point_Sphere');
% 
% % delete them!
% FileExt = mexext;
% for ind = 1:length(Files_to_Delete)
%     stat1 = DDir.Delete_Files_With_Ext(Files_to_Delete(ind).str,FileExt);
%     if (stat1~=0)
%         disp('Delete File failed!');
%         status = -1;
%         return;
%     end
% end

end