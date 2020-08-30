% this sets the FELICITY path vars

S1 = mfilename('fullpath');
MAIN = fileparts(S1); % this is the ``FELICITY'' directory
clear S1;

% do this first!
addpath(MAIN,'-end');

% general auto generated code directory
addpath(fullfile(MAIN,'Code_Generation'),'-end');
code_gen_paths;

% general classes for using the finite element method (FEM)
addpath(fullfile(MAIN,'Classes'),'-end');
classes_paths;

% demos
addpath(fullfile(MAIN,'Demo'),'-end');
demo_paths;

% misc
addpath(fullfile(MAIN,'Quadrature'),'-end');
quadrature_paths;
addpath(fullfile(MAIN,'Elem_Defn'),'-end');
addpath(fullfile(MAIN,'Elem_Defn', 'Unit_Test'),'-end');
addpath(fullfile(MAIN,'Elem_Defn', 'Generators'),'-end');
addpath(fullfile(MAIN,'Elem_Defn', 'Generators', 'Helper_Routines'),'-end');
addpath(fullfile(MAIN,'Elem_Defn', 'Nodal_Variables'),'-end');
addpath(fullfile(MAIN,'Misc_Routines'),'-end');
addpath(fullfile(MAIN,'Reference_Data'),'-end');

% special purpose codes that are NOT auto-generated
addpath(fullfile(MAIN,'Static_Codes'),'-end');
static_code_paths;

% basic utilities
addpath(fullfile(MAIN,'Utilities'),'-end');
utilities_paths;

clear MAIN;
%