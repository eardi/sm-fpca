function status = compile_quadtree_code()
%compile_quadtree_code
%
%    This compiles the mex file for a 2D point-region (PR) quadtree.  This is used for
%    point searches.

% Copyright (c) 01-14-2014,  Shawn W. Walker

Static_Dir = mfilename('fullpath');
Static_Dir = fileparts(Static_Dir);

Tree_CPP    = fullfile(Static_Dir, 'src_code_quadtree', 'mexQuadtree.cpp');
Tree_MEXDir = Static_Dir;
Tree_MEX    = 'mexQuadtree_CPP';

disp('=======> Compile ''Quadtree Point Searcher''...');
status = feval(@mex, '-v', '-largeArrayDims', Tree_CPP, '-outdir', Tree_MEXDir, '-output', Tree_MEX);
% % use this for debug
% status = feval(@mex, '-g', '-v', '-largeArrayDims', Tree_CPP, '-outdir', Tree_MEXDir, '-output', Tree_MEX);

end