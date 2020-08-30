%
% compile_mod_code

SRC = 'C:\FILES\FELICITY\Code_Generation\Matrix_Assembly\Unit_Test\Codim_1\Refined_Square\Assembly_Code_AutoGen_BAK\';
FILE = 'mexAssemble_FEM.cpp';
MEXFile_Dir = 'C:\FILES\FELICITY\Code_Generation\Matrix_Assembly\Unit_Test\Codim_1\Refined_Square';
OUT_STR = ' -output UNIT_TEST_mex_Assemble_Refined_Square_Codim_1';

MEX_str = ['mex ', '-v -largeArrayDims ', SRC, FILE, ' -outdir ', MEXFile_Dir, OUT_STR];

eval(MEX_str);

%feval(@mex,'-v', '-largeArrayDims', [SRC, FILE], '-outdir', MEXFile_Dir, '-output', 'mexLEPP_Bisection_2D');
