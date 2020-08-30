function classes_paths()
%classes_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 04-05-2018,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% this sets the classes paths
% MAIN contains path to 'Classes'

addpath(fullfile(MAIN,'Mesh'),'-end');
mesh_paths;

addpath(fullfile(MAIN,'FEM'),'-end');
fem_paths;

addpath(fullfile(MAIN,'ManageSim'),'-end');
managesim_paths;

% addpath(fullfile(MAIN,'MeshDeform'),'-end');
% addpath(fullfile(MAIN,'MeshDeform','Unit_Test'),'-end');
% %meshdeform_paths;

% more classes...

end