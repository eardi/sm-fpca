function obj = Gen_FEM_Interpolate_snippet(obj,sub_row,sub_col,Ccode_Frag)
%Gen_FEM_Interpolate_snippet
%
%   This encapsulates the code generation for computing the single
%   interpolation.

% Copyright (c) 01-29-2013,  Shawn W. Walker

% open file for writing
File1 = [obj.Name, '_', num2str(sub_row-1), num2str(sub_col-1), '.cpp'];
WRITE_File = fullfile(obj.Snippet_Dir, File1);
obj.SubINT(sub_row,sub_col).Eval_Interp_snip = WRITE_File;
fid = fopen(WRITE_File, 'w');

% generate evaluation loop!
status = Gen_CPP_Interp_Eval_Code(fid,Ccode_Frag);

% DONE!
fclose(fid);

end