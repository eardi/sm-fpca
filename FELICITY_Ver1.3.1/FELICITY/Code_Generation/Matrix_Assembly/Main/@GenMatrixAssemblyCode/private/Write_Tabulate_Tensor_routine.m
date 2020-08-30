function status = Write_Tabulate_Tensor_routine(obj,fid_Open,Specific)
%Write_Tabulate_Tensor_routine
%
%   This generates the code that computes the local element matrix
%   contribution.

% Copyright (c) 06-10-2016,  Shawn W. Walker

ENDL = '\n';

% output text-lines
fprintf(fid_Open, [obj.BEGIN_Auto_Gen, ENDL]);

% append Tab_Tensor computation for the specific sub matrix
Fixed_File = Specific.MAT.Tab_Tensor_Code;
status = obj.Append_ASCII_File_To_Open_File(Fixed_File,fid_Open);

fprintf(fid_Open, [obj.END_Auto_Gen, ENDL]);
fprintf(fid_Open, ['', ENDL]); % close the snippet!

end