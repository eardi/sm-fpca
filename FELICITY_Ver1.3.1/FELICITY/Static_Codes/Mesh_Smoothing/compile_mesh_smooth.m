function status = compile_mesh_smooth()
%compile_mesh_smooth
%
%    MEX compile stand-alone C++ code.

% Copyright (c) 04-15-2013,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

FEL_Mesh_Smooth_CPP    = fullfile(Static_Dir, 'src_code', 'mexFELICITY_Mesh_Smooth.cpp');
FEL_Mesh_Smooth_MEXDir = Static_Dir;
FEL_Mesh_Smooth_MEX    = 'mexFELICITY_Mesh_Smooth';

disp('=======> Compile ''Mesh Smoothing Code''...');
status = feval(@mex,'-v', '-largeArrayDims', FEL_Mesh_Smooth_CPP,...
                    '-outdir', FEL_Mesh_Smooth_MEXDir, '-output', FEL_Mesh_Smooth_MEX);
%

end