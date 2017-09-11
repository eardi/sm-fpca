function status = JUST_Quad_Loop(fid_Open,Ccode_Frag,Det_Jac_str)
%JUST_Quad_Loop
%
%   This creates JUST a quadrature loop.

% Copyright (c) 04-10-2010,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

MAIN_COMP_str = ['A[0] += ', 'integrand', ' * ', Det_Jac_str, ';'];

% compute the local FEM matrix
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Compute single entry using quadrature', ENDL]);
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
fprintf(fid_Open, [TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, '{', ENDL]);

% output optimized C-code fragment
for line_ind = 1:length(Ccode_Frag)
    fprintf(fid_Open, [TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
end

fprintf(fid_Open, [TAB, TAB, MAIN_COMP_str, ENDL]);

status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);

end