function status = Write_SUBRoutine_Basis_Value(obj,fid,Val_CODE,Map_Basis)
%Write_SUBRoutine_Basis_Value
%
%   This generates a sub-routine of the Basis_Function_Class for direct
%   evaluation of the local basis functions.
%
%   note: this sub-routine changes obj, but we do *NOT* want to update obj
%         outside this sub-routine.

% Copyright (c) 10-26-2016,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';

% insert code snippet
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* evaluate basis functions (no derivatives!) on the local reference element. */', ENDL]);
VarName = Val_CODE.Var_Name.line;
fprintf(fid, ['void SpecificFUNC::', Map_Basis.Val.CPP_Routine, '(SCALAR ', VarName, '[NB][NQ])', ENDL]);
fprintf(fid, ['{', ENDL]);
fprintf(fid, ['', ENDL]);

% since we are only dealing with function values, remove all other options
% (temporarily)
% this is to make the number of derivatives consistent with the options we
% want to evaluate
obj.Opt = obj.Get_Opt_struct();
obj.Opt.Val = true;
Basis_Num_Deriv = 0;

% insert the basis function evaluations
obj.Write_Basis_Func_Eval_snip(fid,Basis_Num_Deriv,Map_Basis);

% write the evaluation code
EVAL = Val_CODE.Eval_Snip;
for ei=1:length(EVAL)
    fprintf(fid, [TAB, EVAL(ei).line, ENDL]);
end

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end