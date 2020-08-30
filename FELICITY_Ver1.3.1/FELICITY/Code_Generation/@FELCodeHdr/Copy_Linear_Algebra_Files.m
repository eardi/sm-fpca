function Files = Copy_Linear_Algebra_Files(obj,Output_Dir)
%Copy_Linear_Algebra_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_Linear_Algebra_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 02-28-2012,  Shawn W. Walker

Files(2).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'matrix_vector_defn.h';
Files(2).str = 'matrix_vector_ops.h';

Copy_Files(obj.Dir.Linear_Algebra,Files,Output_Dir);

end