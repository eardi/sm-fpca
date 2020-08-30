function status = static_code_delete_mex_files()
%static_code_delete_mex_files
%
%   Delete files.

% Copyright (c) 01-01-2011,  Shawn W. Walker

DDir = FELtest('deleting files');
status = 0; % init

% get the main directory that this class is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% delete mex files
Files_to_Delete(1).str = fullfile(Main_Dir, 'Lepp_Bisection_2D', 'mexLEPP_Bisection_2D');
Files_to_Delete(2).str = fullfile(Main_Dir, 'Eikonal_2D', 'mexEikonal_2D');
Files_to_Delete(3).str = fullfile(Main_Dir, 'Isosurface_Meshing', 'mexMeshGen_2D');
Files_to_Delete(4).str = fullfile(Main_Dir, 'Isosurface_Meshing', 'mexMeshGen_3D');
Files_to_Delete(5).str = fullfile(Main_Dir, 'Mesh_Smoothing', 'mexFELICITY_Mesh_Smooth');
Files_to_Delete(6).str = fullfile(Main_Dir, 'Search_Trees', 'mexBitree_CPP');
Files_to_Delete(7).str = fullfile(Main_Dir, 'Search_Trees', 'mexQuadtree_CPP');
Files_to_Delete(8).str = fullfile(Main_Dir, 'Search_Trees', 'mexOctree_CPP');

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