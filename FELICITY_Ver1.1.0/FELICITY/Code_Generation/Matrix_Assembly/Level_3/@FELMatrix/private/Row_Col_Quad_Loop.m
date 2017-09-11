function status = Row_Col_Quad_Loop(fid_Open,SYMM,Ccode_Frag,Det_Jac_str)
%Row_Col_Quad_Loop
%
%   This creates the quadrature loop over both row and col basis functions.

% Copyright (c) 04-10-2010,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

MAIN_COMP_str = ['A[j*ROW_NB + i] += ', 'integrand', ' * ', Det_Jac_str, ';'];

if SYMM
    % compute the lower half first
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Compute element tensor using quadrature', ENDL]);
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
    fprintf(fid_Open, [TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, 'for (unsigned int i = j; i < ROW_NB; i++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '{', ENDL]);
    
    % output optimized C-code fragment
    for line_ind = 1:length(Ccode_Frag)
        fprintf(fid_Open, [TAB, TAB, TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
    end
    
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, MAIN_COMP_str, ENDL]);
    
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '}', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '}', ENDL]);
    
    % now copy the lower half to the upper half
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Copy the lower triangular entries to the upper triangular part (by symmetry)', ENDL]);
    fprintf(fid_Open, [TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, 'for (unsigned int i = j+1; i < ROW_NB; i++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);
    
    COPY_str = 'A[i*ROW_NB + j] = A[j*ROW_NB + i];';
    fprintf(fid_Open, [TAB, TAB, TAB, COPY_str, ENDL]);
    
    fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
    status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);
else
    % compute the full local FEM matrix
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Compute element tensor using quadrature', ENDL]);
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
    fprintf(fid_Open, [TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, 'for (unsigned int i = 0; i < ROW_NB; i++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '{', ENDL]);
    
    % output optimized C-code fragment
    for line_ind = 1:length(Ccode_Frag)
        fprintf(fid_Open, [TAB, TAB, TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
    end
    
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, MAIN_COMP_str, ENDL]);
    
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '}', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
    status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);
end

end