function MATCH_STR = Get_String_Match_Struct(obj)
%Get_String_Match_Struct
%
%   This is a struct containing the pattern matching strings to use for
%   identifying symbolic variables in expressions.

% Copyright (c) 08-15-2014,  Shawn W. Walker

% setup matching strings (keep this order!!!!!)
MATCH_STR.mesh_size       = '_Mesh_Size';
MATCH_STR.coord_deriv     = '_X[0123456789]_deriv[0123456789]';
MATCH_STR.tan_space_proj  = '_TSP_[0123456789][0123456789]';
MATCH_STR.coord_val       = '_X[0123456789]'; % this is never constant!
MATCH_STR.tangent         = '_T[0123456789]';
MATCH_STR.normal          = '_N[0123456789]';
MATCH_STR.curvvec         = '_VecKappa[0123456789]';
MATCH_STR.curv            = '_Total_Kappa';
MATCH_STR.gauss_curv      = '_Gauss_Kappa';
MATCH_STR.shape_op        = '_Shape_Op_[0123456789][0123456789]';

end