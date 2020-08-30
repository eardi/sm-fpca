function status = Row_Col_Quad_Loop(fid_Open,NonCopy_Sub_Index,SYMM,Ccode_Frag,Det_Jac_str)
%Row_Col_Quad_Loop
%
%   This creates the quadrature loop over both row and col basis functions.

% Copyright (c) 06-10-2016,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

[INIT, MAIN_COMP, FINAL] = Gen_Quad_Loop_Sub_CPP_Code(NonCopy_Sub_Index,Det_Jac_str);
Num_Lines = length(INIT);

if SYMM
    % compute the lower half first
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Compute element tensor using quadrature', ENDL]);
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
    fprintf(fid_Open, [TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, 'for (unsigned int i = j; i < ROW_NB; i++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, INIT(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '{', ENDL]);
    
    % output optimized C-code fragment
    for ii = 1:length(Ccode_Frag)
        fprintf(fid_Open, [TAB, TAB, TAB, TAB, Ccode_Frag(ii).line, ENDL]);
    end
    
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, TAB, MAIN_COMP(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '}', ENDL]);
    
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, FINAL.RowCol(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '}', ENDL]);
    
    % now copy the lower half to the upper half
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Copy the lower triangular entries to the upper triangular part (by symmetry)', ENDL]);
    fprintf(fid_Open, [TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, 'for (unsigned int i = j+1; i < ROW_NB; i++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);
    
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, FINAL.RowCol_Copy(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
    status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);
else
    % compute the full local FEM matrix
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Compute element tensor using quadrature', ENDL]);
    fprintf(fid_Open, ['', ENDL]);
    fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
    fprintf(fid_Open, [TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
    fprintf(fid_Open, [TAB, TAB, 'for (unsigned int i = 0; i < ROW_NB; i++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, INIT(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '{', ENDL]);

    % output optimized C-code fragment
    for ii = 1:length(Ccode_Frag)
        fprintf(fid_Open, [TAB, TAB, TAB, TAB, Ccode_Frag(ii).line, ENDL]);
    end
    
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, TAB, MAIN_COMP(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, TAB, '}', ENDL]);
    
    for kk = 1:Num_Lines
        fprintf(fid_Open, [TAB, TAB, TAB, FINAL.RowCol(kk).line, ENDL]);
    end
    fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
    status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);
end

end