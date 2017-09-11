function Gen_Misc_Domain_Classes(obj,fid,GeomFunc)
%Gen_Misc_Domain_Classes
%
%   This generates a section of Misc_Stuff.h:  the domain class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% mesh domains
obj.Make_SubDir(obj.Sub_Dir.Domains);
Domains_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Domains);

ENDL = '\n';
fprintf(fid, ['// mesh domain class files', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Domains, '/ALL_Domains.h"', ENDL]);
status = write_domain_files(Domains_Dir,'ALL_Domains.h',GeomFunc);
fprintf(fid, ['', ENDL]);

end

function status = write_domain_files(Dir,hdr_h,GeomFunc)

ENDL = '\n';

WRITE_File = fullfile(Dir, hdr_h);

% open file for writing
fid = fopen(WRITE_File, 'a');
fprintf(fid, ['/*', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['    Mesh domain class files.', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['*/', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, ['#include "Abstract_Domain_Class.cc"', ENDL]);
Num_GeomFunc = length(GeomFunc);
for ind=1:Num_GeomFunc
    CPP = GeomFunc{ind}.Domain.Determine_CPP_Info;
    fprintf(fid,['#include "', CPP.Data_Type_Name_cc, '"', ENDL]);
end
fprintf(fid, ['', ENDL]);

fprintf(fid, ['/***/', ENDL]);
status = fclose(fid);

end