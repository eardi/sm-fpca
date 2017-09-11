function status = Write_Basis_Function_Computation_Code_snippets(obj,fid,BF_CODE)
%Write_Basis_Function_Computation_Code_snippets
%
%   This writes the predetermined code for computing basis function quantities.

% Copyright (c) 03-13-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, [TAB, '/*** compute basis function quantities ***/', ENDL]);
% write the basis function computation (transformation) code
for ind=1:length(BF_CODE)
    EVAL = BF_CODE(ind).Eval_Snip;
    for ei=1:length(EVAL)
        fprintf(fid, [TAB, EVAL(ei).line, ENDL]);
    end
end
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end