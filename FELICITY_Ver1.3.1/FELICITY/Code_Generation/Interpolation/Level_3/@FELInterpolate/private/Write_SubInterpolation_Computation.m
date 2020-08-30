function obj = Write_SubInterpolation_Computation(obj,sub_row,sub_col,DoI_GeomFunc,Ccode_Frag)
%Write_SubInterpolation_Computation
%
%   This fills in the SubINT struct and generates the FEM Interpolation code.

% Copyright (c) 01-29-2013,  Shawn W. Walker

obj.SubINT(sub_row,sub_col).GeomFunc_CPP     = DoI_GeomFunc.CPP;
obj.SubINT(sub_row,sub_col).Ccode_Frag       = Ccode_Frag;
obj.SubINT(sub_row,sub_col).cpp_index        = [];
obj.SubINT(sub_row,sub_col).Row_Shift        = sub_row-1;
obj.SubINT(sub_row,sub_col).Col_Shift        = sub_col-1;

% generate the code
obj = obj.Gen_FEM_Interpolate_snippet(sub_row,sub_col,Ccode_Frag);

end