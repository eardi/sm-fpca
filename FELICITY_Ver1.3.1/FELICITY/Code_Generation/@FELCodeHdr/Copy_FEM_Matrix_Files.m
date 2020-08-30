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

% Copyright (c) 06-15-2016,  Shawn W. Walker

Files(2).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
%%%Files(1).str = 'FEM_Matrix.cc';
Files(1).str = 'Base_FE_Matrix.cc';
Files(2).str = 'Block_Assemble_FE_Matrix.cc';

Copy_Files(obj.Dir.FEM_Matrix,Files,Output_Dir);

end