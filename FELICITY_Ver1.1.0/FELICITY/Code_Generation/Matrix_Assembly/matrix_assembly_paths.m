function matrix_assembly_paths()
%matrix_assembly_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% code creation for matrix assembly
addpath(fullfile(MAIN,'Main'),'-end');
addpath(fullfile(MAIN,'Function'),'-end');
addpath(fullfile(MAIN,'Level_1'),'-end');
addpath(fullfile(MAIN,'Level_1', 'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Level_3'),'-end');
addpath(fullfile(MAIN,'Transformer'),'-end');
addpath(fullfile(MAIN,'Transformer', 'Unit_Test'),'-end');

% unit tests
addpath(fullfile(MAIN,'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_2'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_3'),'-end');

addpath(fullfile(MAIN,'Unit_Test', 'Codim_1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Codim_1', 'Coarse_Square'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Codim_1', 'Refined_Square'),'-end');

addpath(fullfile(MAIN,'Unit_Test', 'Hdiv'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hdiv', 'RT0'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hdiv', 'RT0_Codim_1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hdiv', 'BDM1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hdiv', 'BDM1_Codim_1'),'-end');

addpath(fullfile(MAIN,'Unit_Test', 'Hessian'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hessian', 'Dim_1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hessian', 'Dim_2'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hessian', 'Dim_3'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_2'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_3'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Hessian', 'TopDim_2_GeoDim_3'),'-end');

addpath(fullfile(MAIN,'Unit_Test', 'Mesh_Size'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Mesh_Size', 'Dim_1'),'-end');

addpath(fullfile(MAIN,'Unit_Test', 'Multiple_Subdomains'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_2'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_3'),'-end');

addpath(fullfile(MAIN,'Unit_Test', 'Multiple_Subdomains', 'Mixed_Geometry_1'),'-end');

end