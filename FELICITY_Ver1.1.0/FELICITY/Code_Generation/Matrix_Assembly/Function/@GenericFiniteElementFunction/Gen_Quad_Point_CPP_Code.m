function status = Gen_Quad_Point_CPP_Code(obj,Quad_Pt,fid_Open,COMMENT,TopDim_str)
%Gen_Quad_Point_CPP_Code
%
%   This encapsulates the code generation for the quadrature points.

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';

fprintf(fid_Open, [COMMENT, '// set of quadrature points', ENDL]);
fprintf(fid_Open, [COMMENT, 'static const double Quad_Points[NQ][', TopDim_str, '] = { \\', ENDL]);
status = Process_Quad_Data_to_CPP_Code(fid_Open,Quad_Pt,COMMENT);
fprintf(fid_Open, [COMMENT, '    ', '};', ENDL]);

end