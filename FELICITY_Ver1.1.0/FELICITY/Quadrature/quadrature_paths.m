function quadrature_paths()
%quadrature_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 10-05-2015,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% this sets the quad rule paths
% MAIN contains path to 'Quadrature'

addpath(fullfile(MAIN,'Generate_Quad_Rules'),'-end');

end