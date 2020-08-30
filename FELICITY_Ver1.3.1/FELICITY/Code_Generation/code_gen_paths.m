function code_gen_paths()
%code_gen_paths
%
%   Add sub-directories for FELICITY.

% Copyright (c) 01-25-2013,  Shawn W. Walker

S1 = mfilename('fullpath');
MAIN = fileparts(S1);

% this sets the code generation paths
% MAIN contains path to 'Code_Generation'

addpath(fullfile(MAIN,'Super_Classes'),'-end');
super_classes_paths;

addpath(fullfile(MAIN,'DoF_Numbering'),'-end');
dof_numbering_paths;

addpath(fullfile(MAIN,'Matrix_Assembly'),'-end');
matrix_assembly_paths;

addpath(fullfile(MAIN,'Interpolation'),'-end');
fel_interpolation_paths;

end