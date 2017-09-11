function CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_For_DG(obj,Elem_Index)
%Gen_Specific_Elem_DoF_Allocator_For_DG
%
%   This generates the file: "<Specific>_Elem_DoF_Allocator.cc" for 2D
%   triangulation.

% Copyright (c) 12-10-2010,  Shawn W. Walker

% for convenience
EL = obj.Elem(Elem_Index);

[elem_defines, CPP_Data_Type_str] = obj.Elem_DoF_Allocator_elem_defines(EL);
domain_defines = obj.Elem_DoF_Allocator_domain_defines(EL);
clss = obj.Elem_DoF_Allocator_class_declaration_for_DG(EL);
cons = obj.Elem_DoF_Allocator_constructor_for_DG;
dest = obj.Elem_DoF_Allocator_destructor;
idm  = obj.Elem_DoF_Allocator_init_dof_map;
fdm  = obj.Elem_DoF_Allocator_fill_dof_map_for_DG(EL);
errc = obj.Elem_DoF_Allocator_error_check_dof_map;
eofile = obj.Elem_DoF_Allocator_end_of_file;

% start with an initial snippet
File1 = [CPP_Data_Type_str, '.cc'];
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'Elem_DoF_Allocator_HDR.cc'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');
count = elem_defines.Write_To_File(fid);
count = domain_defines.Write_To_File(fid);
count = clss.Write_To_File(fid);
count = cons.Write_To_File(fid);
count = dest.Write_To_File(fid);
count = idm.Write_To_File(fid);
count = fdm.Write_To_File(fid);
count = errc.Write_To_File(fid);
count = eofile.Write_To_File(fid);

% DONE!
status = fclose(fid);

end