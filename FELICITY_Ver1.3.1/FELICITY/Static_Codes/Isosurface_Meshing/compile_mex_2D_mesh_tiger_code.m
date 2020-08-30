function status = compile_mex_2D_mesh_tiger_code()
%compile_mex_2D_mesh_tiger_code
%
%    This compiles the mex file for the 2D isosurface mesher (TIGER).

% Copyright (c) 03-16-2012,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

Mesh_2D_CPP    = fullfile(Static_Dir, 'src_code_2D', 'mexMeshGen_2D.cpp');
Mesh_2D_MEXDir = Static_Dir;
Mesh_2D_MEX    = 'mexMeshGen_2D';

disp('=======> Compile ''Isosurface 2D Meshing (TIGER)''...');
status = feval(@mex,'-v', '-largeArrayDims', Mesh_2D_CPP, '-outdir', Mesh_2D_MEXDir, '-output', Mesh_2D_MEX);

end