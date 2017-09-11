function status = demo_delete_temp_files()
%demo_delete_temp_files
%
%   Delete files.

% Copyright (c) 04-08-2013,  Shawn W. Walker

DDir = FELtest('deleting dirs');
status = 0; % init

% get the main directory that this class is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% list dirs to delete
Dirs_to_Delete( 1).str1 = fullfile(Main_Dir, 'Laplace_1D', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 1).str2 = fullfile(Main_Dir, 'Laplace_1D', 'Scratch_Dir');
Dirs_to_Delete( 2).str1 = fullfile(Main_Dir, 'Laplace_On_Cube_3D', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 2).str2 = fullfile(Main_Dir, 'Laplace_On_Cube_3D', 'Scratch_Dir');
Dirs_to_Delete( 3).str1 = fullfile(Main_Dir, 'Simple_Elasticity_3D', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 3).str2 = fullfile(Main_Dir, 'Simple_Elasticity_3D', 'Scratch_Dir');
Dirs_to_Delete( 4).str1 = fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 4).str2 = fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface', 'Scratch_Dir');
Dirs_to_Delete( 5).str1 = fullfile(Main_Dir, 'Stokes_2D', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 5).str2 = fullfile(Main_Dir, 'Stokes_2D', 'Scratch_Dir');
Dirs_to_Delete( 5).str3 = fullfile(Main_Dir, 'Stokes_2D', 'AutoGen_DoFNumbering');
Dirs_to_Delete( 6).str1 = fullfile(Main_Dir, 'Image_Processing', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 6).str2 = fullfile(Main_Dir, 'Image_Processing', 'Scratch_Dir');
Dirs_to_Delete( 7).str1 = fullfile(Main_Dir, 'DoFmap_Generation', 'Dim_2', 'AutoGen_DoFNumbering');
Dirs_to_Delete( 8).str1 = fullfile(Main_Dir, 'Interp_2D', 'Interpolation_Code_AutoGen');
Dirs_to_Delete( 8).str2 = fullfile(Main_Dir, 'Interp_2D', 'Scratch_Dir');
Dirs_to_Delete( 9).str1 = fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE', 'Assembly_Code_AutoGen');
Dirs_to_Delete( 9).str2 = fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE', 'Scratch_Dir');
Dirs_to_Delete(10).str1 = fullfile(Main_Dir, 'Point_Search_Domain_2D', 'Pt_Search_Code_AutoGen');
Dirs_to_Delete(11).str1 = fullfile(Main_Dir, 'Closest_Point_Sphere', 'Pt_Search_Code_AutoGen');

% delete them!
for ind = 1:length(Dirs_to_Delete)
    stat1 = DDir.Remove_Dir(Dirs_to_Delete(ind).str1);
    stat2 = DDir.Remove_Dir(Dirs_to_Delete(ind).str2);
    stat3 = DDir.Remove_Dir(Dirs_to_Delete(ind).str3);
    if or(or(stat1~=0,stat2~=0),stat3~=0)
        disp('Delete directory failed!');
        status = -1;
        return;
    end
end

% delete some mex files
Files_to_Delete( 1).str = fullfile(Main_Dir, 'Laplace_1D', 'DEMO_mex_Laplace_1D');
Files_to_Delete( 2).str = fullfile(Main_Dir, 'Laplace_On_Cube_3D', 'DEMO_mex_Laplace_On_Cube_3D_assemble');
Files_to_Delete( 3).str = fullfile(Main_Dir, 'Simple_Elasticity_3D', 'DEMO_mex_Simple_Elasticity_3D_assemble');
Files_to_Delete( 4).str = fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface', 'DEMO_mex_Heat_Eqn_On_A_Surface');
Files_to_Delete( 5).str = fullfile(Main_Dir, 'Stokes_2D', 'DEMO_mex_Stokes_2D_assemble');
Files_to_Delete( 6).str = fullfile(Main_Dir, 'Stokes_2D', 'DEMO_mex_DoF_Lagrange_P2_Allocator_2D');
Files_to_Delete( 7).str = fullfile(Main_Dir, 'Image_Processing', 'DEMO_mex_Image_Proc_assemble');
Files_to_Delete( 8).str = fullfile(Main_Dir, 'DoFmap_Generation', 'Dim_2', 'mexDoF_Example_2D');
Files_to_Delete( 9).str = fullfile(Main_Dir, 'Interp_2D', 'DEMO_mex_Interp_Grad_P_X_2D');
Files_to_Delete(10).str = fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE', 'DEMO_mex_Mesh_Gen_With_Solving_PDE_assemble');
Files_to_Delete(11).str = fullfile(Main_Dir, 'Point_Search_Domain_2D', 'DEMO_mex_Point_Search_Planar_Domain');
Files_to_Delete(12).str = fullfile(Main_Dir, 'Closest_Point_Sphere', 'DEMO_mex_Point_Search_Sphere');

% delete them!
for ind = 1:length(Files_to_Delete)
    stat1 = DDir.Delete_File_All_Ext(Files_to_Delete(ind).str);
    if (stat1~=0)
        disp('Delete File failed!');
        status = -1;
        return;
    end
end

end