function Gen_Misc_CoefFunc_Classes(obj,fid)
%Gen_Misc_CoefFunc_Classes
%
%   This generates a section of Misc_Stuff.h:  the coef function class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% coef func class files
obj.Make_SubDir(obj.Sub_Dir.Coef_Classes);

ENDL = '\n';
fprintf(fid, ['// misc files defining coefficient functions', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Coef_Classes,   '/ALL_COEF_FUNC_Classes.h"', ENDL]);
fprintf(fid, ['', ENDL]);

end