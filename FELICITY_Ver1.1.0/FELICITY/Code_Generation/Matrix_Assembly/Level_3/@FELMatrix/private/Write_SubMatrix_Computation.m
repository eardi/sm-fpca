function obj = Write_SubMatrix_Computation(obj,SM,DoI_GeomFunc,BF,Ccode_Frag)
%Write_SubMatrix_Computation
%
%   This fills in the SubMAT struct and generates the Tabulate Tensor code.

% Copyright (c) 01-24-2014,  Shawn W. Walker

% check for symmetry
symm = obj.Check_Symbolic_For_Symmetry(SM.Sym_Integrand,BF.v_str,BF.u_str);

sub_ind = SM.Sub_Ind; % for convenience
obj.SubMAT(sub_ind).GeomFunc_CPP     = DoI_GeomFunc.CPP;
obj.SubMAT(sub_ind).Ccode_Frag       = Ccode_Frag;
obj.SubMAT(sub_ind).cpp_index        = sub_ind-1;
obj.SubMAT(sub_ind).Symmetric        = symm;
obj.SubMAT(sub_ind).Row_Shift        = SM.vector_SubMAT_index(1)-1;
obj.SubMAT(sub_ind).Col_Shift        = SM.vector_SubMAT_index(2)-1;
obj.SubMAT(sub_ind).COPY_SubMAT      = SM.COPY_SubMAT; % record this!

% copy previous sub-matrix computations if necessary
if and(sub_ind > 1,~isempty(SM.COPY_SubMAT))
    obj = obj.Gen_Copy_Tab_Tensor_snippet(sub_ind,SM.COPY_SubMAT);
else
    % generate the code
    obj = obj.Gen_Tab_Tensor_snippet(sub_ind,BF,Ccode_Frag);
end

end