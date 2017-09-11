function status = Write_Func_Computation_Code_snip(obj,fid,CF_CODE)
%Write_Func_Computation_Code_snip
%
%   This appends snippets of code for computing various external function quantities.

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, [TAB, '/*** compute coefficient function quantities ***/', ENDL]);
% write the coef. func. comp. code
for ind=1:length(CF_CODE)
    EVAL = CF_CODE(ind).Eval_Snip;
    for ei=1:length(EVAL)
        fprintf(fid, [TAB, EVAL(ei).line, ENDL]);
    end
end
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end