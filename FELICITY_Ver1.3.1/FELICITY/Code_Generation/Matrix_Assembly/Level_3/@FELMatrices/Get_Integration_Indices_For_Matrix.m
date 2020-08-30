function Indices = Get_Integration_Indices_For_Matrix(obj,Matrix_Name)
%Get_Integration_Indices_For_Matrix
%
%   This returns an array of indices into obj.Integration(:) indicating which
%   integration domains the FE matrix is computed on.

% Copyright (c) 06-18-2012,  Shawn W. Walker

Indices = []; % init

for index = 1:length(obj.Integration)
    MAT_Set = obj.Integration(index).Matrix;
    MAT_Set_Names = MAT_Set.keys;
    if ismember(Matrix_Name,MAT_Set_Names)
        Indices = [Indices; index];
    end
end

end