function obj = Append_Real_Matrix(obj,Real_Matrix_Name,Specific_Matrix_Name,Integration_Index,Integrand_str,...
                                      Num_Sub_Matrices,row_func,col_func,row_func_str,col_func_str)
%Append_Real_Matrix
%
%   This creates another finite element matrix and stores it under the
%   appropriate integration domain.  Note: this is only for Real matrices (no
%   finite element spaces!).

% Copyright (c) 06-22-2012,  Shawn W. Walker

% global matrix info
MM = Get_Matrix_Struct();
MM.Name           = Real_Matrix_Name;
MM.Row_Space_Name = '';
MM.Col_Space_Name = '';
obj.Matrix(Real_Matrix_Name) = MM; % insert

% check if this Real matrix is already present
Names = obj.Integration(Integration_Index).Matrix.keys;
[TF, LOC] = ismember(Real_Matrix_Name,Names);

if TF
    % the matrix is already there, so this must be another *component*, i.e.
    % this matrix must have more than 1 row and/or 1 column, so this is just
    % adding another component of the matrix
    Current_Matrix = obj.Integration(Integration_Index).Matrix(Real_Matrix_Name);
    
    % make some basic checks to ensure everything is consistent
    if ~strcmp(Current_Matrix.Name,Specific_Matrix_Name)
        error('Specific Matrix Name (i.e. the domain we are integrating on) must be the same!');
    end
%     if or(~isequal(Current_Matrix.row_func,row_func),~isequal(Current_Matrix.col_func,col_func))
%         error('row and col functions must match!');
%     end
    % we have another sub-matrix to compute
    Current_Matrix.Num_SubMAT = Current_Matrix.Num_SubMAT + 1;
    obj.Integration(Integration_Index).Matrix(Real_Matrix_Name) = Current_Matrix;
else
    Integrand_str = [Integrand_str, ',  ... etc... (see individual submatrices, i.e. Tab_Tensor routines.)'];
    % contribution to matrix from one integral
    obj.Integration(Integration_Index).Matrix(Real_Matrix_Name) = FELMatrix(Specific_Matrix_Name,...
        Integrand_str,Num_Sub_Matrices,row_func,col_func,row_func_str,col_func_str,obj.Snippet_Dir);
    %
end

end