function Gen_Misc_Interp_Classes(obj,fid)
%Gen_Misc_Interp_Classes
%
%   This generates a section of Misc_Stuff.h:  the interpolation class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% interpolation class files
obj.Make_SubDir(obj.Sub_Dir.Interpolation_Classes);
FI_Files = FC.Copy_FEM_Interpolation_Files(fullfile(obj.Output_Dir, obj.Sub_Dir.Interpolation_Classes));

ENDL = '\n';
fprintf(fid, ['// misc files defining finite element interpolations', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Interpolation_Classes, '/ALL_FEM_Interpolation_Classes.h"', ENDL]);
fprintf(fid, ['', ENDL]);

end