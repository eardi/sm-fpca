function [INIT, MAIN_COMP, FINAL] = Gen_Quad_Loop_Sub_CPP_Code(NonCopy_Sub_Index,Det_Jac_str)
%Gen_Quad_Loop_Sub_CPP_Code
%
%   This writes part of the quadrature loop code, and is designed to
%   account for multiple sub-matrices.

% Copyright (c) 06-13-2016,  Shawn W. Walker

Num_Lines = length(NonCopy_Sub_Index);

INIT(Num_Lines).line = [];
MAIN_COMP(Num_Lines).line = [];
FINAL.RowCol(Num_Lines).line = [];
FINAL.RowCol_Copy(Num_Lines).line = [];
FINAL.Row(Num_Lines).line = [];
FINAL.Col(Num_Lines).line = [];
FINAL.Null(Num_Lines).line = [];
for ind = 1:Num_Lines
    Index_str = num2str(NonCopy_Sub_Index(ind)-1); % put into C-style indexing
    A_value_str = ['A', Index_str, '_value'];
    FE_Tensor_str = ['FE_Tensor_', Index_str];
    
    INIT(ind).line = ['double  ', A_value_str, ' = 0.0; // initialize'];
    
    MAIN_COMP(ind).line  = [A_value_str, ' += ', 'integrand_', Index_str, ' * ', Det_Jac_str, ';'];
    
    FINAL.RowCol(ind).line = [FE_Tensor_str, '[j*ROW_NB + i] = ', A_value_str, ';'];
    
    FINAL.RowCol_Copy(ind).line = [FE_Tensor_str, '[i*ROW_NB + j] = ', FE_Tensor_str, '[j*ROW_NB + i];'];
    
    FINAL.Row(ind).line = [FE_Tensor_str, '[i] = ', A_value_str, ';'];
    
    FINAL.Col(ind).line = [FE_Tensor_str, '[j] = ', A_value_str, ';'];
    
    FINAL.Null(ind).line = [FE_Tensor_str, '[0] = ', A_value_str, ';'];
end

end