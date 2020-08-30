function obj = Store_SubMatrix_Info(obj,SubMatrices,DoI_GeomFunc,BF,Ccode_Frag)
%Store_SubMatrix_Info
%
%   This fills *all* the SubMAT struct.

% Copyright (c) 06-10-2016,  Shawn W. Walker

for si = 1:length(SubMatrices)
    
    SM = SubMatrices(si);
    
    % check for symmetry
    symm = obj.Check_Symbolic_For_Symmetry(SM.Sym_Integrand,BF.v_str,BF.u_str);
    
    sub_ind = SM.Sub_Ind; % for convenience
    obj.SubMAT(sub_ind).GeomFunc_CPP     = DoI_GeomFunc.CPP;
    obj.SubMAT(sub_ind).Ccode_Frag       = Ccode_Frag;
    obj.SubMAT(sub_ind).cpp_index        = sub_ind-1;
    obj.SubMAT(sub_ind).Symmetric        = symm;
    obj.SubMAT(sub_ind).Row_Shift        = SM.vector_SubMAT_index(1)-1; % for c-indexing
    obj.SubMAT(sub_ind).Col_Shift        = SM.vector_SubMAT_index(2)-1; % for c-indexing
    obj.SubMAT(sub_ind).COPY_SubMAT      = SM.COPY_SubMAT; % record this!
end

end