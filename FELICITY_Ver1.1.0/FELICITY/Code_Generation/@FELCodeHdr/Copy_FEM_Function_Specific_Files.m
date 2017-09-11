function Files = Copy_FEM_Function_Specific_Files(obj,Output_Dir)
%Copy_FEM_Function_Specific_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_FEM_Function_Specific_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 02-28-2012,  Shawn W. Walker

Files(1).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'Data_Type_CONST_ONE_phi.cc';

Copy_Files(obj.Dir.FEM_Function_Specific,Files,Output_Dir);

end