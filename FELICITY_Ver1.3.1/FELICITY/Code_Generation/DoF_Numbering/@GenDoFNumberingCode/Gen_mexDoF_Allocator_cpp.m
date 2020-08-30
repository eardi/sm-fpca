function status = Gen_mexDoF_Allocator_cpp(obj,Elem_Alloc)
%Gen_mexDoF_Allocator_cpp
%
%   This generates the file: "mexDoF_Allocator.cpp".

% Copyright (c) 12-10-2010,  Shawn W. Walker

% start with an initial snippet
File1 = 'mexDoF_Allocator.cpp';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'mexDoF_Allocator_HDR.cpp'),WRITE_File);

[defines, mex_strings] = obj.mexDoF_Allocator_defines(Elem_Alloc);
includes = obj.mexDoF_Allocator_includes(mex_strings);
generic  = obj.mexDoF_Allocator_generic;
errchk   = obj.mexDoF_Allocator_error_check(mex_strings);
main     = obj.mexDoF_Allocator_main_code(mex_strings,Elem_Alloc);
eofile   = obj.mexDoF_Allocator_end_of_file;

% open file for writing
fid = fopen(WRITE_File, 'a');
count = defines.Write_To_File(fid);
count = includes.Write_To_File(fid);
count = generic.Write_To_File(fid);
count = errchk.Write_To_File(fid);
count = main.Write_To_File(fid);
count = eofile.Write_To_File(fid);

% DONE!
status = fclose(fid);

end