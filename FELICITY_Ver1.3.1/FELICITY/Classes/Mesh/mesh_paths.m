function mesh_paths()
%mesh_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% classes for mesh manipulation and access
addpath(fullfile(MAIN,'Unit_Test'),'-end');


% addpath(fullfile(MAIN,'Unit_Test', 'Dim_1'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_1', 'Bary_Plot'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_1', 'Curve'),'-end');
% 
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Bary_Plot'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Bisection_2D'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Circle'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Facet'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Mesh_Skeleton'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2', 'Square'),'-end');
% 
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_3'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_3', 'Cube'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_3', 'Facet'),'-end');

end