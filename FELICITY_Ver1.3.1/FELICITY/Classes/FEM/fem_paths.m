function fem_paths()
%fem_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 08-31-2016,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

addpath(fullfile(MAIN,'Unit_Test'),'-end');

% % classes for finite element spaces (and DoFmaps)
% addpath(fullfile(MAIN,'Unit_Test', 'Dim_2'),'-end');
% 
% % classes for point searching on meshes
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searching', 'TopDim_2_GeoDim_2'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Point_Searching', 'TopDim_2_GeoDim_3'),'-end');

end