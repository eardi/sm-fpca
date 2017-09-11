function Files = Copy_FEM_Matrix_Files(obj,Output_Dir)
%Copy_FEM_Matrix_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_FEM_Matrix_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 02-28-2012,  Shawn W. Walker

Files(1).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'FEM_Matrix.cc';

Copy_Files(obj.Dir.FEM_Matrix,Files,Output_Dir);

end