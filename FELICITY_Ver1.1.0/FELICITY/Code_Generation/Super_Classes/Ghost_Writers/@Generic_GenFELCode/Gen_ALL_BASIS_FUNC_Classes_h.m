function Gen_ALL_BASIS_FUNC_Classes_h(obj,FS)
%Gen_ALL_BASIS_FUNC_Classes_h
%
%   This generates the file: "./Basis_FEM_Classes/ALL_BASIS_FUNC_Classes.h".

% Copyright (c) 06-04-2012,  Shawn W. Walker

ENDL = '\n';

% start with A part
File1 = 'ALL_BASIS_FUNC_Classes.h';
WRITE_File = fullfile(obj.Output_Dir, obj.Sub_Dir.Basis_Classes, File1);
FEL_CopyFile(fullfile(obj.Skeleton_Dir, 'ALL_BASIS_FUNC_Classes_A.h'),WRITE_File);

% open file for writing
fid = fopen(WRITE_File, 'a');

% EXAMPLE:
%%%%%%%
% /*------------ BEGIN: Auto Generate ------------*/
% 
% #include "Data_Type_CONST_ONE_phi.cc"
% #include "Data_Type_Scalar_P2_phi.cc"
% 
% /*------------   END: Auto Generate ------------*/

%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);
% this one is always there
fprintf(fid, ['#include "Data_Type_CONST_ONE_phi.cc"\n']);
% loop through all the specific basisfunction names
for int_index = 1:length(FS.Integration)
    BF_Set = FS.Integration(int_index).BasisFunc;
    BF_Names = BF_Set.keys;
    for index = 1:length(BF_Names)
        fprintf(fid, ['#include "', BF_Set(BF_Names{index}).CPP_Data_Type, '.cc"\n']);
    end
end
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
%%%%%%%

% append the B part
Fixed_File = fullfile(obj.Skeleton_Dir, 'ALL_BASIS_FUNC_Classes_B.h');
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid);

% DONE!
fclose(fid);

end