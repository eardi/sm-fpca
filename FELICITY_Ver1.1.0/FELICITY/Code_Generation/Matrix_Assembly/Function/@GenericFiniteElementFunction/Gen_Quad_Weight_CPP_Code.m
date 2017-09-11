function status = Gen_Quad_Weight_CPP_Code(obj,Quad_Wt,fid_Open,COMMENT)
%Gen_Quad_Weight_CPP_Code
%
%   This encapsulates the code generation for the quadrature weights.

% Copyright (c) 04-07-2010,  Shawn W. Walker

ENDL = '\n';

fprintf(fid_Open, [COMMENT, '// set of quadrature weights', ENDL]);
fprintf(fid_Open, [COMMENT, 'static const double Quad_Weights[NQ] = { \\', ENDL]);
status = Process_Quad_Data_to_CPP_Code(fid_Open,Quad_Wt,COMMENT);
fprintf(fid_Open, [COMMENT, '    ', '};', ENDL]);

end