function Gen_All_Domain_Classes(obj,GeomFunc)
%Gen_All_Domain_Classes
%
%   This generates a class file for accessing subdomain info.

% Copyright (c) 06-05-2012,  Shawn W. Walker

FN = 'Abstract_Domain_Class.cc';
OUT_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Domains);
WRITE_File = fullfile(OUT_Dir, FN);
GeomFunc{1}.Domain.Copy_File(FN, WRITE_File);

% generate code for each domain
for ind=1:length(GeomFunc)
    GeomFunc{ind}.Domain.Gen_Domain_Class_cc(OUT_Dir);
end

end