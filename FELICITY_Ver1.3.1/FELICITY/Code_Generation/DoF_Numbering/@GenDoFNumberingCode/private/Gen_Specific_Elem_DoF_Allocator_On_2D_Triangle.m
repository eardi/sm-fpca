function CPP_Data_Type_str = Gen_Specific_Elem_DoF_Allocator_On_2D_Triangle(obj,Elem_Index)
%Gen_Specific_Elem_DoF_Allocator_On_2D_Triangle
%
%   This generates the file: "<Specific>_Elem_DoF_Allocator.cc" for 2D
%   triangulation.

% Copyright (c) 12-10-2010,  Shawn W. Walker

% for convenience
EL = obj.Elem(Elem_Index);

[elem_defines, CPP_Data_Type_str] = obj.Elem_DoF_Allocator_elem_defines(EL);
domain_defines = obj.Elem_DoF_Allocator_domain_defines(EL);
clss = obj.Elem_DoF_Allocator_class_declaration_2D_triangle(EL);
cons = obj.Elem_DoF_Allocator_constructor(EL);
dest = obj.Elem_DoF_Allocator_destructor;
idm  = obj.Elem_DoF_Allocator_init_dof_map;
fdm  = obj.Elem_DoF_Allocator_fill_dof_map_2D_triangle;
avd  = obj.Elem_DoF_Allocator_assign_vtx_dof_2D_triangle(EL);
aed  = obj.Elem_DoF_Allocator_assign_edge_dof_2D_triangle(EL);
afd  = obj.Elem_DoF_Allocator_assign_face_dof_2D_triangle(EL);
atd  = obj.Elem_DoF_Allocator_assign_tet_dof_2D_triangle(EL);
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
count = avd.Write_To_File(fid);
count = aed.Write_To_File(fid);
count = afd.Write_To_File(fid);
count = atd.Write_To_File(fid);
count = errc.Write_To_File(fid);
count = eofile.Write_To_File(fid);

% DONE!
status = fclose(fid);

end