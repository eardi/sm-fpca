function Gen_Misc_Math(obj,fid)
%Gen_Misc_Math
%
%   This generates a section of Misc_Stuff.h:  the basic math code.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% copy over rudimentary structs and math stuff
obj.Make_SubDir(obj.Sub_Dir.Math);
Math_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Math);
Linear_Algebra_Files = FC.Copy_Linear_Algebra_Files(Math_Dir);
Geo_Comp_Files       = FC.Copy_Geometry_Files(Math_Dir);

ENDL = '\n';
fprintf(fid, ['// useful math structures', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Math, '/FEL_Math_Structs.h"', ENDL]);
status = write_math_files(obj,Math_Dir,'FEL_Math_Structs.h',Linear_Algebra_Files,Geo_Comp_Files);
fprintf(fid, ['', ENDL]);

end

function status = write_math_files(obj,Dir,hdr_h,Linear_Algebra_Files,Geo_Comp_Files)

ENDL = '\n';

WRITE_File = fullfile(Dir, hdr_h);

% open file for writing
fid = fopen(WRITE_File, 'a');
fprintf(fid, ['/*', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['    Rudimentary math structures.', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['*/', ENDL]);
fprintf(fid, ['', ENDL]);

obj.Write_Preprocessor_Include_Lines(fid,Linear_Algebra_Files);
obj.Write_Preprocessor_Include_Lines(fid,Geo_Comp_Files);

fprintf(fid, ['/***/', ENDL]);
status = fclose(fid);

end