function Gen_Misc_Matrix_Classes(obj,fid)
%Gen_Misc_Matrix_Classes
%
%   This generates a section of Misc_Stuff.h:  the matrix class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% matrix class files
obj.Make_SubDir(obj.Sub_Dir.Matrix_Classes);
FM_Files = FC.Copy_FEM_Matrix_Files(fullfile(obj.Output_Dir, obj.Sub_Dir.Matrix_Classes));

ENDL = '\n';
fprintf(fid, ['// misc files defining finite element matrices', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Matrix_Classes, '/ALL_MATRIX_Classes.h"', ENDL]);
fprintf(fid, ['', ENDL]);

end