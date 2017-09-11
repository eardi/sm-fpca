function Gen_Misc_Point_Search_Classes(obj,fid)
%Gen_Misc_Point_Search_Classes
%
%   This generates a section of Misc_Stuff.h:  the point search class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-16-2014,  Shawn W. Walker

% % copy some standard files over
% FC = FELCodeHdr();
% 
% % interpolation class files
% obj.Make_SubDir(obj.Sub_Dir.Point_Search_Classes);
% Search_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Point_Search_Classes);
% FPS_Files = FC.Copy_Point_Search_Files(Search_Dir);

ENDL = '\n';
fprintf(fid, ['// misc files defining point search classes', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Point_Search_Classes, '/ALL_Point_Search_Classes.h"', ENDL]);
%status = write_pt_search_files(obj,Search_Dir,'ALL_Point_Search_Classes.h',FPS_Files);
fprintf(fid, ['', ENDL]);

end

% function status = write_pt_search_files(obj,Dir,hdr_h,FPS_Files)
% 
% ENDL = '\n';
% 
% WRITE_File = fullfile(Dir, hdr_h);
% 
% % open file for writing
% fid = fopen(WRITE_File, 'a');
% fprintf(fid, ['/*', ENDL]);
% fprintf(fid, ['============================================================================================', ENDL]);
% fprintf(fid, ['    Basic point searching classes.', ENDL]);
% fprintf(fid, ['============================================================================================', ENDL]);
% fprintf(fid, ['*/', ENDL]);
% fprintf(fid, ['', ENDL]);
% 
% obj.Write_Preprocessor_Include_Lines(fid,FPS_Files);
% 
% fprintf(fid, ['/***/', ENDL]);
% status = fclose(fid);
% 
% end