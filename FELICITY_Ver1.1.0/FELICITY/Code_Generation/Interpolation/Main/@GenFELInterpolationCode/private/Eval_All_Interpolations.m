function status = Eval_All_Interpolations(obj,fid,Specific)
%Eval_All_Interpolations
%
%   This writes snippets of code for evaluating the interpolations for the given
%   FELInterpolate.

% Copyright (c) 02-03-2013,  Shawn W. Walker

status = 0;

ENDL = '\n';
TAB = '    ';

fprintf(fid, ['', obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', '/* evaluate all FEM interpolations */', ENDL]);
fprintf(fid, ['', 'void SpecificFEM::Eval_All_Interpolations (const unsigned int& Interp_Pt_Index)', ENDL]);
fprintf(fid, ['', '{', ENDL]);
fprintf(fid, [TAB, '// loop through the different sub-interpolations', ENDL]);
for ir = 1:Specific.NumRow_SubINT
    for ic = 1:Specific.NumCol_SubINT
        INT = Specific.SubINT(ir,ic);
        row_str = num2str(INT.Row_Shift);
        col_str = num2str(INT.Col_Shift);
        fprintf(fid, [TAB, 'Eval_Interp_', row_str, col_str, '(Interp_Data[', row_str, '][', col_str, '][Interp_Pt_Index])', ';', ENDL]);
    end
end

fprintf(fid, ['', '}', ENDL]);
fprintf(fid, ['', '/***************************************************************************************/', ENDL]);
fprintf(fid, ['', obj.END_Auto_Gen, ENDL]);
fprintf(fid, ['', ENDL]);

end