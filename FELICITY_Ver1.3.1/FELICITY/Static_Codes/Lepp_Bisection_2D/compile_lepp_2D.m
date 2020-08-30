function status = compile_lepp_2D()
%compile_lepp_2D
%
%    MEX compile stand-alone C++ code.

% Copyright (c) 09-06-2011,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

Lepp_Bisection_2D_CPP    = fullfile(Static_Dir, 'src_code', 'mexLEPP_Bisection_2D.cpp');
Lepp_Bisection_2D_MEXDir = Static_Dir;
Lepp_Bisection_2D_MEX    = 'mexLEPP_Bisection_2D';

disp('=======> Compile ''LEPP Bisection 2D''...');
status = feval(@mex,'-v', '-largeArrayDims', Lepp_Bisection_2D_CPP,...
           '-outdir', Lepp_Bisection_2D_MEXDir, '-output', Lepp_Bisection_2D_MEX);
%

% status = feval(@mex,'-v', 'COMPFLAGS="$COMPFLAGS -Wall"', '-largeArrayDims', Lepp_Bisection_2D_CPP,...
%            '-outdir', Lepp_Bisection_2D_MEXDir, '-output', Lepp_Bisection_2D_MEX);

end