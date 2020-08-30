function super_classes_paths()
%super_classes_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 06-12-2014,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% generic DSL and code creation classes
addpath(fullfile(MAIN,'Ghost_Writers'),'-end');
addpath(fullfile(MAIN,'Level_1'),'-end');
addpath(fullfile(MAIN,'Level_3'),'-end');

end