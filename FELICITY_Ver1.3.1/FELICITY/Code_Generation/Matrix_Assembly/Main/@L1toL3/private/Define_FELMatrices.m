function [FS, FM] = Define_FELMatrices(obj,FS,FM,Matrix_Parsed)
%Define_FELMatrices
%
%   This completes the definition of the FEM matrices.
%   Note: each individual matrix has no clue what the other matrices are doing,
%   or what they are, or what spaces are involved!
%
%   Matrix_Parsed(k).Integral{j} = jth integral of matrix k, i.e. the jth
%                                  contribution to the global kth matrix.
%   Note: obj.MATS.Matrix_Data{k}.Integral(j) corresponds directly to
%                  Matrix_Parsed(k).Integral{j}.

% Copyright (c) 06-09-2016,  Shawn W. Walker

Num_Mats = length(obj.MATS.Matrix_Data);
for ind = 1:Num_Mats
    
    Matrix = obj.MATS.Matrix_Data{ind};
    Parsed_Integral = Matrix_Parsed(ind).Integral;
    Num_Integrals = length(Parsed_Integral);
    
    for integral_index = 1:Num_Integrals
        FELMatrices_Integration_Index = Parsed_Integral{integral_index}.Integration_Index;
        % put it into the form of a Level 2 struct
        L2_Obj_Integral = Set_L2_Obj_Integral(Matrix,Parsed_Integral{integral_index});
        
        % write code for all the *sub-matrices* of the jth integral of the kth matrix
        [FM, FS] = FM.Set_FEM_Matrix(FELMatrices_Integration_Index,FS,L2_Obj_Integral);
    end
end

end