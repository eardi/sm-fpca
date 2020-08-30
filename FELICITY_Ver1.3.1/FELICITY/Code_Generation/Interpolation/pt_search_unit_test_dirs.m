function Unit_Test_Dirs = pt_search_unit_test_dirs()
%pt_search_unit_test_dirs
%
%   This outputs a list of directories containing the unit tests.

% Copyright (c) 05-07-2019,  Shawn W. Walker

% get the main directory that this function is in!
MFN = mfilename('fullpath');
Main_Dir = fileparts(MFN);

% define unit test dirs

% init
Unit_Test_Dirs.str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_1');
Unit_Test_Dirs.str2 = [];
Unit_Test_Dirs.str3 = [];

% next!
str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_2_Codim_1');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'Dim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_2');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_1_GeoDim_3');
Unit_Test_Dirs = append_dir(Unit_Test_Dirs,str1,[],[]);

str1 = fullfile(Main_Dir, 'Unit_Test', 'Point_Searches', 'TopDim_2_GeoDim_3');
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