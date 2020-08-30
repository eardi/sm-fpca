function static_code_paths()
%static_code_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% 2-D bisection code
addpath(fullfile(MAIN,'Lepp_Bisection_2D'),'-end');
addpath(fullfile(MAIN,'Lepp_Bisection_2D', 'Unit_Test'),'-end');

% mesh smoothing/optimization code
addpath(fullfile(MAIN,'Mesh_Smoothing'),'-end');
addpath(fullfile(MAIN,'Mesh_Smoothing', 'Unit_Test'),'-end');

% Eikonal equation solver
addpath(fullfile(MAIN,'Eikonal_2D'),'-end');
addpath(fullfile(MAIN,'Eikonal_2D', 'Unit_Test'),'-end');

% TIGER meshing algorithm
addpath(fullfile(MAIN,'Isosurface_Meshing'),'-end');
addpath(fullfile(MAIN,'Isosurface_Meshing', 'LevelSets_2D'),'-end');
addpath(fullfile(MAIN,'Isosurface_Meshing', 'LevelSets_3D'),'-end');
addpath(fullfile(MAIN,'Isosurface_Meshing', 'Unit_Test'),'-end');

% search trees
addpath(fullfile(MAIN,'Search_Trees'),'-end');
addpath(fullfile(MAIN,'Search_Trees', 'Unit_Test'),'-end');

end