function Files = Copy_FEM_Function_Files(obj,Output_Dir)
%Copy_FEM_Function_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_FEM_Function_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 02-28-2012,  Shawn W. Walker

Files(2).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'Abstract_FEM_Function.cc';
Files(2).str = 'basis_function_computations.h';

Copy_Files(obj.Dir.FEM_Function,Files,Output_Dir);

end