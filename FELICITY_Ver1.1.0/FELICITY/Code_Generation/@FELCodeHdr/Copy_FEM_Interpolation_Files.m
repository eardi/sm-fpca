function Files = Copy_FEM_Interpolation_Files(obj,Output_Dir)
%Copy_FEM_Interpolation_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_FEM_Interpolation_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 01-29-2013,  Shawn W. Walker

Files(1).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'Unstructured_Interpolation.cc';
Files(2).str = 'FEM_Interpolation.cc';

Copy_Files(obj.Dir.FEM_Interpolation,Files,Output_Dir);

end