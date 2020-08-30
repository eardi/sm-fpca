function status = compile_octree_code()
%compile_octree_code
%
%    This compiles the mex file for a 3D point-region (PR) octree.  This is used for
%    point searches.

% Copyright (c) 01-14-2014,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

Tree_CPP    = fullfile(Static_Dir, 'src_code_octree', 'mexOctree.cpp');
Tree_MEXDir = Static_Dir;
Tree_MEX    = 'mexOctree_CPP';

disp('=======> Compile ''Octree Point Searcher''...');
status = feval(@mex, '-v', '-largeArrayDims', Tree_CPP, '-outdir', Tree_MEXDir, '-output', Tree_MEX);
% % use this for debug
% status = feval(@mex, '-g', '-v', '-largeArrayDims', Tree_CPP, '-outdir', Tree_MEXDir, '-output', Tree_MEX);

end