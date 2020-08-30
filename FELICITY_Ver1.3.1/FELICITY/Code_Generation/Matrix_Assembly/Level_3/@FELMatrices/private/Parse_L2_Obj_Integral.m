function SM = Parse_L2_Obj_Integral(L2_Obj_Integral)
%Set_FEM_Matrix_Submatrix
%
%   This translates L2_Obj_Integral into a more convenient structure.

% Copyright (c) 06-09-2016,  Shawn W. Walker

SM.Matrix_Name    = L2_Obj_Integral.Name;
SM.Domain         = L2_Obj_Integral.Domain;
SM.Sub_Ind        = str2double(L2_Obj_Integral.SubMAT_Index);
SM.vector_SubMAT_index...
                  = [str2double(L2_Obj_Integral.row_index), str2double(L2_Obj_Integral.col_index)];
SM.Sym_Integrand  = sym(L2_Obj_Integral.Arg); % symbolic representation of integrand
SM.COPY_SubMAT    = Set_COPY_SubMAT(L2_Obj_Integral.COPY);

end