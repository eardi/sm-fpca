function status = Write_Basis_Function_Value_H1_Trans_Pointer_snippet(fid,FuncTrans,Map_Basis)
%Write_Basis_Function_Value_H1_Trans_Pointer_snippet
%
%   This writes one line of code that looks like:
%        Func_f_Value = &Basis_Value_X;
%   where X denotes a local mesh entity index.
%
%   For the case of H^1 functions, (i.e. the H1_Trans class) it is cheaper to
%   store the basis function evaluations (on ALL the mesh entities) ONCE (done
%   in the constructor), and *then* to just change which one is referenced when
%   we loop through the mesh.
%   Note: this is only for H^1 functions, for which we *always* do this (because
%         moving a pointer is cheap to do!).

% Copyright (c) 03-17-2012,  Shawn W. Walker

status = 0; % init
ENDL = '\n';
TAB = '    ';

% ensure that the basis function evaluation variable is ``pointed'' to the
% correct mesh entity.
if isa(FuncTrans,'H1_Trans')
    Val_CODE = FuncTrans.FUNC_Val_C_Code;
    HDR = Val_CODE.Eval_Snip(1).line;
    fprintf(fid, [TAB, HDR, ENDL]);
    EVAL = [Val_CODE.Var_Name(1).line, ' = &', Map_Basis.Val.VarName, '; // point to the correct mesh entity'];
    status = fprintf(fid, [TAB, EVAL, ENDL]);
end

end