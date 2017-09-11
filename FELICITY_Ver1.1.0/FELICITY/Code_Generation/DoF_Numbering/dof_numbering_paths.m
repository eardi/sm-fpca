function dof_numbering_paths()
%dof_numbering_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% code creation for DoF numbering
addpath(fullfile(MAIN,'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_1'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_2'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_3'),'-end');

end