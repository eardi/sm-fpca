function Files = Copy_Matrix_Assembler_Files(obj,Output_Dir)
%Copy_Matrix_Assembler_Files
%
%   This copies files from the private code database to a desired location.
%
%   Files = obj.Copy_Matrix_Assembler_Files(Output_Dir);
%
%   Output_Dir = directory to copy to.
%
%   Files = array of structs containing file names that were copied.

% Copyright (c) 02-28-2012,  Shawn W. Walker

Files(5).str = [];
% these should be ordered by dependency, i.e. later files depend on earlier ones
Files(1).str = 'abstract_assembler.cc';
Files(2).str = 'block_alloc.h';
Files(3).str = 'assembler.cc';
Files(4).str = 'reassembler.cc';
Files(5).str = 'simple_assembler.cc';

Copy_Files(obj.Dir.Matrix_Assembler,Files,Output_Dir);

end