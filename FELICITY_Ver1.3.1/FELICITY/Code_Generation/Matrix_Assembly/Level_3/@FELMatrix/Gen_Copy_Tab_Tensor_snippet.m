function obj = Gen_Copy_Tab_Tensor_snippet(obj,sub_ind,COPY_SubMAT)
%Gen_Copy_Tab_Tensor_snippet
%
%   This encapsulates the code generation for computing the local element
%   matrix by copying the computation of an earlier sub-matrix!

% Copyright (c) 05-26-2016,  Shawn W. Walker

% ENDL = '\n';
% TAB = '    ';

if (COPY_SubMAT.Use_SubMAT < 1)
    error('The Sub-Matrix index to copy must at least be 1!');
end
if (COPY_SubMAT.Use_SubMAT > obj.Num_SubMAT)
    error('The Sub-Matrix index to copy is too large!');
end
if (COPY_SubMAT.Use_SubMAT == sub_ind)
    error('The Sub-Matrix to copy cannot be itself!');
end

% open file for writing
File1 = [obj.Name, '_', num2str(sub_ind-1), '.cpp'];
WRITE_File = fullfile(obj.Snippet_Dir, File1);
obj.SubMAT(sub_ind).Tab_Tensor_snip = WRITE_File;
fid = fopen(WRITE_File, 'w');

% generate copy loop!
%status = Gen_CPP_Copy_SubMAT_Code(fid,obj.SubMAT(COPY_SubMAT.Use_SubMAT),COPY_SubMAT.Copy_Transpose);
status = Gen_CPP_Copy_SubMAT_Code(fid,COPY_SubMAT.Copy_Transpose);

% DONE!
fclose(fid);

end