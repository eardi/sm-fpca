function obj = Setup_Dirs(obj)
%Setup_Dirs
%
%   This sets up several directories that are used internally.
%
%   obj = obj.Setup_Dirs;

% Copyright (c) 02-28-2012,  Shawn W. Walker

Private_Dir = fileparts(mfilename('fullpath'));

obj.Dir.Linear_Algebra     = fullfile(Private_Dir, 'Linear_Algebra');
obj.Dir.Geometry           = fullfile(Private_Dir, 'Geometry');
obj.Dir.Matrix_Assembler   = fullfile(Private_Dir, 'Matrix_Assembler');

obj.Dir.FEM_Matrix             = fullfile(Private_Dir, 'FEM_Matrix');
obj.Dir.FEM_Function           = fullfile(Private_Dir, 'FEM_Function');
obj.Dir.FEM_Function_Specific  = fullfile(Private_Dir, 'FEM_Function_Specific');
obj.Dir.FEM_Interpolation      = fullfile(Private_Dir, 'FEM_Interpolation');

end