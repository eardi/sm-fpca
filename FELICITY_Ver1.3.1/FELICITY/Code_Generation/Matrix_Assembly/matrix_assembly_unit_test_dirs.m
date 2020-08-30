function Unit_Test_Dirs = matrix_assembly_unit_test_dirs()
%matrix_assembly_unit_test_dirs
%
%   This outputs a list of directories containing the unit tests.

% Copyright (c) 04-05-2018,  Shawn W. Walker

% get the main directory that this function is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% define unit test dirs

% init
Unit_Test_Dirs.str1 = fullfile(Main_Dir, 'Unit_Test', 'Assembly', 'Assemble_Subset_2D');
Unit_Test_Dirs.str2 = [];
Unit_Test_Dirs.str3 = [];

% next!
str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Dim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Coarse_Square');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Codim_1', 'Refined_Square');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT0_Codim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RTk_Surface');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'RT1_Dim3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdiv', 'BDM1_Codim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

% str1 = fullfile(Main_Dir, 'Unit_Test', 'Hdivdiv', 'HHJk');
% Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);


disp('SWW: put in unit test for HHJ!!!!');


str1 = fullfile(Main_Dir, 'Unit_Test', 'Lagrange');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg1_Dim2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg1_Dim2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg2_Dim3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hcurl', 'Nedelec1stKind_Deg2_Dim3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'Dim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_1_GeoDim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Hessian', 'TopDim_2_GeoDim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Mesh_Size', 'Dim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Embedding_Dim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Multiple_Subdomains', 'Mixed_Geometry_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Symbolic_Constants', 'Dim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Symbolic_Constants', 'Mixed_Domains');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

end

function New_Dirs = append_dir(Dirs,str1,str2,str3)

DS.str1 = str1;
DS.str2 = str2;
DS.str3 = str3;

Num = length(Dirs);
New_Dirs = Dirs; % init
New_Dirs(Num+1) = DS;

end