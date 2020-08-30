function fel_interpolation_paths()
%fel_interpolation_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-20-2018,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% code creation for finite element interpolation and mesh point searching
addpath(fullfile(MAIN,'Main'),'-end');
addpath(fullfile(MAIN,'Level_1'),'-end');
addpath(fullfile(MAIN,'Level_1', 'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Level_3'),'-end');

% unit tests for interpolation
addpath(fullfile(MAIN,'Unit_Test'),'-end');

% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Flat_Domain'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Symbolic_Constant'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Hdiv'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Mixed_Geometry'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'TopDim_1_GeoDim_3', 'Shape_Operator'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'TopDim_2_GeoDim_3', 'Shape_Operator'),'-end');

% % unit tests for point searching
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'Dim_1'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_2'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_3'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'Dim_2'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'TopDim_2_GeoDim_3'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'Dim_3'),'-end');
% 
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searches', 'Dim_2_Codim_1'),'-end');

end