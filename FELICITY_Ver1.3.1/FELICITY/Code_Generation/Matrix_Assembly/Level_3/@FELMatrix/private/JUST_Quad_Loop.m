function status = JUST_Quad_Loop(fid_Open,NonCopy_Sub_Index,Ccode_Frag,Det_Jac_str)
%JUST_Quad_Loop
%
%   This creates JUST a quadrature loop.

% Copyright (c) 06-10-2016,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

[INIT, MAIN_COMP, FINAL] = Gen_Quad_Loop_Sub_CPP_Code(NonCopy_Sub_Index,Det_Jac_str);
Num_Lines = length(INIT);

% compute the local FEM matrix
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Compute single entry using quadrature', ENDL]);
fprintf(fid_Open, ['', ENDL]);
fprintf(fid_Open, [TAB, '// Loop quadrature points for integral', ENDL]);
for kk = 1:Num_Lines
    fprintf(fid_Open, [TAB, INIT(kk).line, ENDL]);
end

fprintf(fid_Open, [TAB, 'for (unsigned int qp = 0; qp < NQ; qp++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, '{', ENDL]);

% output optimized C-code fragment
for line_ind = 1:length(Ccode_Frag)
    fprintf(fid_Open, [TAB, TAB, Ccode_Frag(line_ind).line, ENDL]);
end

for kk = 1:Num_Lines
    fprintf(fid_Open, [TAB, TAB, MAIN_COMP(kk).line, ENDL]);
end
fprintf(fid_Open, [TAB, TAB, '}', ENDL]);

for kk = 1:Num_Lines
    status = fprintf(fid_Open, [TAB, FINAL.Null(kk).line, ENDL]);
end

end