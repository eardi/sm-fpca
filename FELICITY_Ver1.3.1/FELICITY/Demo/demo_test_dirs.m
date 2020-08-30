function Unit_Test_Dirs = demo_test_dirs()
%demo_test_dirs
%
%   This outputs a list of directories containing the demos.

% Copyright (c) 05-07-2019,  Shawn W. Walker

% get the main directory that this function is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% define demo dirs

% init
Unit_Test_Dirs.str1 = fullfile(Main_Dir, 'Closest_Point_Sphere');
Unit_Test_Dirs.str2 = [];
Unit_Test_Dirs.str3 = [];

% next!
str1 = fullfile(Main_Dir, 'Curved_Domain_2D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

% str1 = fullfile(Main_Dir, 'CiarletRaviart');
% Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'DoFmap_Generation', 'Dim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'EWOD');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Finite_Element_Space_2D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Finite_Element_Space_On_1D_Subdomain');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Heat_Eqn_On_A_Surface');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Image_Processing');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Interp_2D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Laplace_1D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Laplace_Beltrami_Open_Surface');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Laplace_On_Cube_3D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Local_FE_Matrix');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Mesh_Gen_With_Solving_PDE');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Mesh_Smoothing_2D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Point_Search_Domain_2D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Simple_Elasticity_3D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Stokes_2D');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

end

function New_Dirs = append_dir(Dirs,str1,str2,str3)

DS.str1 = str1;
DS.str2 = str2;
DS.str3 = str3;

Num = length(Dirs);
New_Dirs = Dirs; % init
New_Dirs(Num+1) = DS;

end