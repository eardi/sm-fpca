function Gen_ALL_FEM_Classes_h(obj,FM)
%Gen_ALL_FEM_Classes_h
%
%   This generates the file: ".\FEM_Matrix_Classes\ALL_FEM_Classes.h".

% Copyright (c) 06-04-2012,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'ALL_MATRIX_Classes.h';
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Matrix_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'ALL_FEM_Classes_A.h'),WRITE_File);

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
% loop through all the specific matrix names
Matrix_Names = FM.Matrix.keys;
for index = 1:length(Matrix_Names)
    fprintf(fid, ['#include "', FM.Matrix(Matrix_Names{index}).Name, '.cc"\n']);
end
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'ALL_FEM_Classes_B.h');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end