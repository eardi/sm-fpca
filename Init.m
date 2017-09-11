addpath(genpath('FELICITY_Ver1.1.0'))

mex -setup
%test_FELICITY
Main_Dir = '.';
[status, Path_To_Mex] = Convert_Mscript_to_MEX(Main_Dir,'MatAssem_Laplace_Penalty_Surface','Assem_Laplace_Penalty_Surface');