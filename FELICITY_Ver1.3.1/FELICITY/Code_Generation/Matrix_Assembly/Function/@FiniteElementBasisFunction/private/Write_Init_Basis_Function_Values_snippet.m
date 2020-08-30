function status = Write_Init_Basis_Function_Values_snippet(obj,fid)
%Write_SUBRoutine_Init_Basis_Function_Values
%
%   This generates a one-time piece of code for evaluating the basis functions.

% Copyright (c) 01-15-2018,  Shawn W. Walker

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
elseif isa(obj.FuncTrans,'Constant_Trans')
    C_Val_str = obj.FuncTrans.Output_CPP_Var_Name('Val');
    
    status = fprintf(fid, [TAB, '// actually, we will not init everything to zero.', ENDL]);
    status = fprintf(fid, [TAB, '// instead we will initialize the global constant basis function to 1.0', ENDL]);
    status = fprintf(fid, [TAB, '// Note: this must be done *outside* this routine because it is a static const', ENDL]);
    %status = fprintf(fid, [TAB, '//const  SCALAR  SpecificFUNC::', C_Val_str, ' = SCALAR(1.0);', ENDL]);
end

end