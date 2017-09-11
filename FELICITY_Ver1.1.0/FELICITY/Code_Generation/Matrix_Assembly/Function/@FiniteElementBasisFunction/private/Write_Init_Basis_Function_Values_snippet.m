function status = Write_Init_Basis_Function_Values_snippet(obj,fid)
%Write_SUBRoutine_Init_Basis_Function_Values
%
%   This generates a one-time piece of code for evaluating the basis functions.

% Copyright (c) 06-06-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';

% SPECIAL CASE
% for H^1 functions only (and only when NOT generating interpolation code)
if and(isa(obj.FuncTrans,'H1_Trans'),~obj.INTERPOLATION)
    CDMap = Codim_Map(obj.GeomFunc);
    Compute_Local_Transformation = CDMap.Get_Basis_Function_Local_Transformation();
    status = fprintf(fid, [TAB, '// init basis function values on local mesh entities', ENDL]);
    for ind = 1:Compute_Local_Transformation.Num_Map_Basis
        EVAL_STR = [Compute_Local_Transformation.Map_Basis(ind).Val.CPP_Routine, '(',...
                    Compute_Local_Transformation.Map_Basis(ind).Val.VarName, ');'];
        status = fprintf(fid, [TAB, EVAL_STR, ENDL]);
    end
end

end