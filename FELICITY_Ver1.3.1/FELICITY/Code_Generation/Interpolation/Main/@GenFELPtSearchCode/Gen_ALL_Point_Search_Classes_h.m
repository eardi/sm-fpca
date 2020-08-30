function Gen_ALL_Point_Search_Classes_h(obj,FPS)
%Gen_ALL_Point_Search_Classes_h
%
%   This generates the file: ".\Point_Search\ALL_Point_Search_Classes.h".

% Copyright (c) 06-26-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% point search class files
obj.Make_SubDir(obj.Sub_Dir.Point_Search_Classes);
Search_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Point_Search_Classes);
FPS_Files = FC.Copy_Point_Search_Files(Search_Dir);

ENDL = '\n';

WRITE_File = fullfile(Search_Dir, 'ALL_Point_Search_Classes.h');

% open file for writing
fid = fopen(WRITE_File, 'a');
fprintf(fid, ['/*', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['   Point searching classes.', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, ['   Copyright (c) 06-26-2014,  Shawn W. Walker', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['*/', ENDL]);
fprintf(fid, ['', ENDL]);

obj.Write_Preprocessor_Include_Lines(fid,FPS_Files);
fprintf(fid, ['', ENDL]);

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% 
% #include "CLASS_Search_Omega.cc"
% 
% /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
Search_Domains = FPS.Get_Distinct_Domains;
NUM_Domains = length(Search_Domains);
% loop through all the specific domain names
for di = 1:NUM_Domains
    Dom_Name = Search_Domains{di}.Name;
    CPP_PTS = FPS.Get_CPP_Point_Search_Vars(Dom_Name);
    fprintf(fid, ['#include "', CPP_PTS.Search_Obj_CPP_Type, '.cc"\n']);
end
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
%%%%%%%

fprintf(fid, ['/***/', ENDL]);
status = fclose(fid);

end