function SS = Get_Sub_Dir(obj)
%Get_Sub_Dir
%
%   This returns the sub-directories to use in the generated code.

% Copyright (c) 06-16-2014,  Shawn W. Walker

SS.Assembler              = 'Assembler';
SS.Domains                = 'Domains';
SS.Geometry               = 'Geometry';
SS.Math                   = 'Math';
SS.Matrix_Classes         = 'FE_Matrices';
SS.Interpolation_Classes  = 'FE_Interpolations';
SS.Point_Search_Classes   = 'Point_Search';
SS.Basis_Classes          = 'Basis_Functions';
SS.Coef_Classes           = 'Coef_Functions';

end