function status = Write_SUBRoutine_Map_Basis_Function(obj,fid,BF_CODE,Premap_CODE,Map_Basis)
%Write_SUBRoutine_Map_Basis_Function
%
%   This generates a sub-routine of the Basis_Function_Class for computing
%   transformations of the local basis functions.

% Copyright (c) 10-27-2016,  Shawn W. Walker

ENDL = '\n';
% TAB = '    ';
% insert code snippet
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* map basis functions from the standard reference element', ENDL]);
fprintf(fid, ['       to an actual element in the Domain.     */', ENDL]);
fprintf(fid, ['void SpecificFUNC::', Map_Basis.CPP_Name, '()', ENDL]);
fprintf(fid, ['{', ENDL]);

% insert the quadrature and basis function evaluations
Basis_Eval_Opt  = obj.Opt;
Basis_Num_Deriv = obj.FuncTrans.Number_Of_Derivatives_For_Opt(Basis_Eval_Opt);

% this is for pre-mapping the basis functions (needed for H(div) and H(curl))
status = obj.Write_Premap_Call_snippet(fid,Premap_CODE);
fprintf(fid, ['', ENDL]);

% insert basis function evaluations at the quad points
if obj.INTERPOLATION
    % no quad points here
    status = obj.Write_Basis_Eval_Interpolation_snip(fid,Basis_Num_Deriv,Map_Basis);
else
    status = obj.Write_Basis_Func_Eval_snip(fid,Basis_Num_Deriv,Map_Basis);
end

% SWW: no longer needed!
%status = obj.Write_Basis_Function_Orientation_snippet(fid,obj.FuncTrans);

% this is only done when NOT interpolating (i.e. when assembling matrices)
if ~obj.INTERPOLATION
    status = Write_Basis_Function_Value_H1_Trans_Pointer_snippet(fid,obj.FuncTrans,Map_Basis);
end
fprintf(fid, ['', ENDL]);

status = obj.Write_Basis_Function_Computation_Code_snippets(fid,BF_CODE);

fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end