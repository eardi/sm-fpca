function utilities_paths()
%utilities_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-01-2011,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% basic utilities
addpath(fullfile(MAIN,'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Unit_Test', 'FELLog'),'-end');

end