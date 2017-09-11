function obj = Gen_Tab_Tensor_snippet(obj,sub_ind,BF,Ccode_Frag)
%Gen_Tab_Tensor_snippet
%
%   This encapsulates the code generation for computing the local element matrix.

% Copyright (c) 03-14-2012,  Shawn W. Walker

v = BF.v;
u = BF.u;

% open file for writing
File1 = [obj.Name, '_', num2str(sub_ind-1), '.cpp'];
WRITE_File = fullfile(obj.Snippet_Dir, File1);
obj.SubMAT(sub_ind).Tab_Tensor_snip = WRITE_File;
fid = fopen(WRITE_File, 'w');

% generate quadrature loop!
status = Gen_CPP_Quad_Loop_Code(fid,obj.SubMAT(sub_ind).Symmetric,Ccode_Frag,v,u);

% DONE!
fclose(fid);

end