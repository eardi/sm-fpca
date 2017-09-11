function Gen_Misc_Matrix_Assembler(obj,fid)
%Gen_Misc_Matrix_Assembler
%
%   This generates a section of Misc_Stuff.h:  the core matrix assembly code.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% assembler
obj.Make_SubDir(obj.Sub_Dir.Assembler);
Assem_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Assembler);
Matrix_Assembler_Files = FC.Copy_Matrix_Assembler_Files(Assem_Dir);

ENDL = '\n';
fprintf(fid, ['// matrix assembler', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Assembler, '/FEL_Assembler.h"', ENDL]);
status = write_assembler_files(obj,Assem_Dir,'FEL_Assembler.h',Matrix_Assembler_Files);
fprintf(fid, ['', ENDL]);

end

function status = write_assembler_files(obj,Dir,hdr_h,Matrix_Assembler_Files)

ENDL = '\n';

WRITE_File = fullfile(Dir, hdr_h);

% open file for writing
fid = fopen(WRITE_File, 'a');
fprintf(fid, ['/*', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['    Contents are matrix assembler files written by David Bindel.', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['*/', ENDL]);
fprintf(fid, ['', ENDL]);

obj.Write_Preprocessor_Include_Lines(fid,Matrix_Assembler_Files);

fprintf(fid, ['/***/', ENDL]);
status = fclose(fid);

end