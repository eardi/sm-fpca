function managesim_paths()
%managesim_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 04-09-2014,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% classes for simulation management and access
addpath(fullfile(MAIN,'Unit_Test'),'-end');


% addpath(fullfile(MAIN,'Unit_Test', 'Test_SaveLoad'),'-end');
% addpath(fullfile(MAIN,'Unit_Test', 'Test_Visualize'),'-end');

end