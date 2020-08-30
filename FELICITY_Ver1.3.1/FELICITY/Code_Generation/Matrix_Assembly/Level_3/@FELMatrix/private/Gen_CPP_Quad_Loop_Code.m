function status = Gen_CPP_Quad_Loop_Code(fid_Open,NonCopy_Sub_Index,SYMM,Ccode_Frag,v,u)
%Gen_CPP_Quad_Loop_Code
%
%   This generates C++ code for computing the entries of the local FEM
%   matrix.  This uses quadrature!

% Copyright (c) 04-07-2010,  Shawn W. Walker

YES_ROW = ~strcmp(v.Elem.Element_Type,'constant_one');
YES_COL = ~strcmp(u.Elem.Element_Type,'constant_one');

Det_Jac_str = ['Mesh.Map_Det_Jac_w_Weight', '[qp]', '.a'];

if and(YES_ROW, YES_COL)
    status = Row_Col_Quad_Loop(fid_Open,NonCopy_Sub_Index,SYMM,Ccode_Frag,Det_Jac_str);
elseif and(YES_ROW, ~YES_COL)
    status = Row_ONLY_Quad_Loop(fid_Open,NonCopy_Sub_Index,Ccode_Frag,Det_Jac_str);
elseif and(~YES_ROW, YES_COL)
    status = Col_ONLY_Quad_Loop(fid_Open,NonCopy_Sub_Index,Ccode_Frag,Det_Jac_str);
else
    % this is some kind of norm error quadrature
    status = JUST_Quad_Loop(fid_Open,NonCopy_Sub_Index,Ccode_Frag,Det_Jac_str);
end

end