function fem_paths()
%fem_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% classes for finite element spaces (and DoFmaps)
addpath(fullfile(MAIN,'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'Dim_2'),'-end');

end