function Gen_ALL_EXT_FUNC_Classes_h(obj,FS)
%Gen_ALL_EXT_FUNC_Classes_h
%
%   This generates the file: ".\External_FEM_Classes\ALL_EXT_FUNC_Classes.h".

% Copyright (c) 06-04-2012,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'ALL_COEF_FUNC_Classes.h';
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Coef_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'ALL_EXT_FUNC_Classes_A.h'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% 
% #include "FEM_Matrix_Specific.cc"
% 
% /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
% loop through all the specific coef function names
for int_index = 1:length(FS.Integration)
    CF_Set = FS.Integration(int_index).CoefFunc;
    CF_Names = CF_Set.keys;
    for index = 1:length(CF_Names)
        fprintf(fid, ['#include "', CF_Set(CF_Names{index}).CPP_Data_Type, '.cc"\n']);
    end
end
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'ALL_EXT_FUNC_Classes_B.h');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end