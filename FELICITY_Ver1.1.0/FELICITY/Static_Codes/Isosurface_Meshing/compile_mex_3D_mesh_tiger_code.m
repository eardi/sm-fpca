function status = compile_mex_3D_mesh_tiger_code()
%compile_mex_3D_mesh_tiger_code
%
%    This compiles the mex file for the 3D isosurface mesher (TIGER).

% Copyright (c) 03-16-2012,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

Mesh_3D_CPP    = fullfile(Static_Dir, 'src_code_3D', 'mexMeshGen_3D.cpp');
Mesh_3D_MEXDir = Static_Dir;
Mesh_3D_MEX    = 'mexMeshGen_3D';

disp('=======> Compile ''Isosurface 3D Meshing (TIGER)''...');
status = feval(@mex,'-v', '-largeArrayDims', Mesh_3D_CPP, '-outdir', Mesh_3D_MEXDir, '-output', Mesh_3D_MEX);

end