function status = Row_ONLY_Quad_Loop(fid_Open,NonCopy_Sub_Index,Ccode_Frag,Det_Jac_str)
%Row_ONLY_Quad_Loop
%
%   This creates the quadrature loop over JUST row basis functions.

% Copyright (c) 06-10-2016,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

[INIT, MAIN_COMP, FINAL] = Gen_Quad_Loop_Sub_CPP_Code(NonCopy_Sub_Index,Det_Jac_str);
Num_Lines = length(INIT);

% compute the local FEM matrix
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Compute element tensor using quadrature', ENDL]);
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
fprintf(fid_Open, [TAB, 'for (unsigned int i = 0; i < ROW_NB; i++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
for kk = 1:Num_Lines
    fprintf(fid_Open, [TAB, TAB, INIT(kk).line, ENDL]);
end
fprintf(fid_Open, [TAB, TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);

% output optimized C-code fragment
for line_ind = 1:length(Ccode_Frag)
    fprintf(fid_Open, [TAB, TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
end

for kk = 1:Num_Lines
    fprintf(fid_Open, [TAB, TAB, TAB, MAIN_COMP(kk).line, ENDL]);
end
fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);

for kk = 1:Num_Lines
    fprintf(fid_Open, [TAB, TAB, FINAL.Row(kk).line, ENDL]);
end
status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);

end