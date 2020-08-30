function status = Write_Geometry_Computation_Code_snippets(obj,fid,Geo_CODE)
%Write_Geometry_Computation_Code_snippets
%
%   This writes the predetermined code for computing geometric quantities.

% Copyright (c) 03-07-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
%%%%%%%
% output text-lines
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, [TAB, '/*** compute geometric quantities ***/', ENDL]);
% write the geometry comp code
for ind=1:length(Geo_CODE)
    EVAL = Geo_CODE(ind).Eval_Snip;
    for ei=1:length(EVAL)
        fprintf(fid, [TAB, EVAL(ei).line, ENDL]);
    end
end
status = fprintf(fid, [obj.END_Auto_Gen, ENDL]);

end