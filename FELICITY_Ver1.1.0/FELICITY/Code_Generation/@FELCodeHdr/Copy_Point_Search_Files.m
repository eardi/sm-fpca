function Files = Copy_Point_Search_Files(obj,Output_Dir)
%Copy_Point_Search_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_Point_Search_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 06-16-2014,  Shawn W. Walker

Files(1).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'Subdomain_Search_Data.cc';
Files(2).str = 'Unstructured_Local_Points.cc';
Files(3).str = 'Mesh_Point_Search.cc';

Copy_Files(obj.Dir.FEM_Interpolation,Files,Output_Dir);

end