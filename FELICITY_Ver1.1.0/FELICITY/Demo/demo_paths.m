function demo_paths()
%demo_paths
%
%   Add sub-directories for demos of FELICITY.

% Copyright (c) 02-11-2013,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% this sets the demo paths
% MAIN contains path to 'Demo'
addpath(fullfile(MAIN,'Laplace_1D'),'-end');
addpath(fullfile(MAIN,'Laplace_On_Cube_3D'),'-end');
addpath(fullfile(MAIN,'Simple_Elasticity_3D'),'-end');
addpath(fullfile(MAIN,'Heat_Eqn_On_A_Surface'),'-end');
addpath(fullfile(MAIN,'Stokes_2D'),'-end');
addpath(fullfile(MAIN,'Image_Processing'),'-end');

addpath(fullfile(MAIN,'DoFmap_Generation'),'-end');
addpath(fullfile(MAIN,'DoFmap_Generation', 'Dim_2'),'-end');
addpath(fullfile(MAIN,'Finite_Element_Space_2D'),'-end');
addpath(fullfile(MAIN,'Finite_Element_Space_On_1D_Subdomain'),'-end');

addpath(fullfile(MAIN,'Interp_2D'),'-end');

addpath(fullfile(MAIN,'Mesh_Smoothing_2D'),'-end');

addpath(fullfile(MAIN,'Mesh_Gen_With_Solving_PDE'),'-end');

addpath(fullfile(MAIN,'Point_Search_Domain_2D'),'-end');
addpath(fullfile(MAIN,'Closest_Point_Sphere'),'-end');

end