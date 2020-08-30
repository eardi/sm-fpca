function Gen_ALL_EXT_C_Code_h(obj,Extra_C_Code)
%Gen_ALL_EXT_C_Code_h
%
%   This generates the file: ".\ALL_EXT_C_Code.h".

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'ALL_EXT_C_Code.h';
WRITE_File = fullfile(obj.Output_Dir, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'ALL_EXT_C_Code_A.h'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% 
% ... <User Supplied C-Code> ...
% 
% /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
% loop through all the specific matrix names
if ~isempty(Extra_C_Code(1).FileName)
    for index = 1:length(Extra_C_Code)
        % append the C-code
        status = obj.Append_ASCII_File_To_Open_File(Extra_C_Code(index).FileName,fid);
    end
end
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'ALL_EXT_C_Code_B.h');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

% END %