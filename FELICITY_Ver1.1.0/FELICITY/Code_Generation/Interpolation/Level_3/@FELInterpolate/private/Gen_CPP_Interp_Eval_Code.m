function status = Gen_CPP_Interp_Eval_Code(fid_Open,Ccode_Frag)
%Gen_CPP_Interp_Eval_Code
%
%   This generates C++ code for computing the entries of the local FE interpolation.

% Copyright (c) 01-29-2013,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

% compute the interpolation
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Compute interpolation', ENDL]);
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// only one point for interpolation', ENDL]);
fprintf(fid_Open, [TAB, 'for (unsigned int qp = 0; qp < 1; qp++)', ENDL]);

% output optimized C-code fragment
for line_ind = 1:length(Ccode_Frag)
    status = fprintf(fid_Open, [TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
end

end