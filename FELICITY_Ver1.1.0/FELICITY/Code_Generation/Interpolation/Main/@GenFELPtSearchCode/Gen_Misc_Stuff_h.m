function Gen_Misc_Stuff_h(obj,GeomFuncs)
%Gen_Misc_Stuff_h
%
%   This generates the file: ".\Misc_Stuff.h".

% Copyright (c) 06-28-2014,  Shawn W. Walker

ENDL = '\n';

% start the file
File1 = 'Misc_Stuff.h';
WRITE_File = fullfile(obj.Output_Dir, File1);

% open file for writing
fid = fopen(WRITE_File, 'w');

%%%%%%%
% write the initial header
fprintf(fid, ['/*', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['   This header file contains various classes that are used in this code.', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['   Copyright (c) 06-13-2014,  Shawn W. Walker', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['*/', ENDL]);
fprintf(fid, ['', ENDL]);

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

Gen_Misc_Math(obj,fid);

fprintf(fid, ['// user defined C-code', ENDL]);
fprintf(fid, ['#include "ALL_EXT_C_Code.h"', ENDL]);
fprintf(fid, ['', ENDL]);

Gen_Misc_Domain_Classes(obj,fid,GeomFuncs);

Gen_Misc_Geometry_Classes(obj,fid,GeomFuncs);

Gen_Misc_Point_Search_Classes(obj,fid)

fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['/***/', ENDL]);

% DONE!
fclose(fid);

end