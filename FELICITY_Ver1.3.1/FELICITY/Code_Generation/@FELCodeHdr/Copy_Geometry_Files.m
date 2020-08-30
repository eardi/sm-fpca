function Files = Copy_Geometry_Files(obj,Output_Dir)
%Copy_Geometry_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_Geometry_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 02-28-2012,  Shawn W. Walker

Files(1).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'geometric_computations.h';

Copy_Files(obj.Dir.Geometry,Files,Output_Dir);

end