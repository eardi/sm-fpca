function status = Write_SUBRoutine_Basis_Value(obj,fid,Val_CODE,Map_Basis)
%Write_SUBRoutine_Basis_Value
%
%   This generates a sub-routine of the Basis_Function_Class for direct
%   evaluation of the local basis functions.

% Copyright (c) 03-16-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';

% insert code snippet
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* evaluate basis functions on the local reference element */', ENDL]);
VarName = Val_CODE.Var_Name.line;
fprintf(fid, ['void SpecificFUNC::', Map_Basis.Val.CPP_Routine, '(SCALAR ', VarName, '[NB][NQ])', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['', ENDL]);

% insert the basis function evaluations
Basis_Num_Deriv = 0;
obj.Write_Basis_Func_Eval_snip(fid,'phi',Basis_Num_Deriv,Map_Basis);

% write the evaluation code
EVAL = Val_CODE.Eval_Snip;
for ei=1:length(EVAL)
    fprintf(fid, [TAB, EVAL(ei).line, ENDL]);
end

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end