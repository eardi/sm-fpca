function status = Row_ONLY_Quad_Loop(fid_Open,Ccode_Frag,Det_Jac_str)
%Row_ONLY_Quad_Loop
%
%   This creates the quadrature loop over JUST row basis functions.

% Copyright (c) 04-10-2010,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

MAIN_COMP_str = ['A[i] += ', 'integrand', ' * ', Det_Jac_str, ';'];

% compute the local FEM matrix
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Compute element tensor using quadrature', ENDL]);
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
fprintf(fid_Open, [TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
fprintf(fid_Open, [TAB, TAB, 'for (unsigned int i = 0; i < ROW_NB; i++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);

% output optimized C-code fragment
for line_ind = 1:length(Ccode_Frag)
    fprintf(fid_Open, [TAB, TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
end

fprintf(fid_Open, [TAB, TAB, TAB, MAIN_COMP_str, ENDL]);

fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);

end