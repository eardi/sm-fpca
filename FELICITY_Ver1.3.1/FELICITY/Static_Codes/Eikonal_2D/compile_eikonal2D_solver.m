function status = compile_eikonal_solver()
%compile_eikonal_solver
%
%    MEX compile stand-alone C++ code.

% Copyright (c) 09-06-2011,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

MAIN_CPP     = fullfile(Static_Dir, 'src_code', 'mexEikonal_Solve.cpp');
MEXDir       = Static_Dir;
MEX_FileName = 'mexEikonal_2D';

disp('=======> Compile ''Eikonal Solver 2D''...');
status = feval(@mex,'-v', '-largeArrayDims', MAIN_CPP, '-outdir', MEXDir, '-output', MEX_FileName);

end