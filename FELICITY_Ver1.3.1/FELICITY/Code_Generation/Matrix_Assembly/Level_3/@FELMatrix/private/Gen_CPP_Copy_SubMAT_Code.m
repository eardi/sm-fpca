function status = Gen_CPP_Copy_SubMAT_Code(fid_Open,Copy_Transpose)
%Gen_CPP_Copy_SubMAT_Code
%
%   This creates the copy loop for copying the results of some other
%   sub-matrix.

% Copyright (c) 05-27-2016,  Shawn W. Walker

ENDL = '\n';
TAB  = '    ';

sub_mat_data_str = 'A_tilde[j*ROW_NB + i];';

if Copy_Transpose
    COMMENT_str   = '// Copy the transpose of the other sub-matrix';
    % note the indices are flipped
    MAIN_COPY_str = ['A[i*COL_NB + j] = ', sub_mat_data_str];
else
    COMMENT_str   = '// Copy the other sub-matrix';
    MAIN_COPY_str = ['A[j*ROW_NB + i] = ', sub_mat_data_str];
end

% copy the other sub-matrix
fprintf(fid_Open, ['', ENDL]);

fprintf(fid_Open, [TAB, COMMENT_str, ENDL]);
fprintf(fid_Open, [TAB, 'for (unsigned int j = 0; j < COL_NB; j++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, '{', ENDL]);
fprintf(fid_Open, [TAB, TAB, 'for (unsigned int i = 0; i < ROW_NB; i++)', ENDL]);
fprintf(fid_Open, [TAB, TAB, TAB, '{', ENDL]);

fprintf(fid_Open, [TAB, TAB, TAB, MAIN_COPY_str, ENDL]);

fprintf(fid_Open, [TAB, TAB, TAB, '}', ENDL]);
status = fprintf(fid_Open, [TAB, TAB, '}', ENDL]);

% END %