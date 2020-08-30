function Gen_Misc_BasisFunc_Classes(obj,fid)
%Gen_Misc_BasisFunc_Classes
%
%   This generates a section of Misc_Stuff.h:  the basis function class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% basis fem class files
obj.Make_SubDir(obj.Sub_Dir.Basis_Classes);
Basis_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Basis_Classes);
FEM_Func_Files = FC.Copy_FEM_Function_Files(Basis_Dir);
FFS_Files = FC.Copy_FEM_Function_Specific_Files(Basis_Dir);

ENDL = '\n';
fprintf(fid, ['// misc files defining basis functions', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Basis_Classes,  '/ALL_BASIS_FUNC_Classes.h"', ENDL]);
fprintf(fid, ['', ENDL]);

end