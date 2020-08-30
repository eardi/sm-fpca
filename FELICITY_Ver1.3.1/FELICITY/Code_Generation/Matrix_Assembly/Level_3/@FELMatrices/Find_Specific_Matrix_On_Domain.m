function Specific_Matrix = Find_Specific_Matrix_On_Domain(obj,Matrix_Name,Given_Integration_Domain)
%Find_Specific_Matrix_On_Domain
%
%   This returns a FELMatrix.

% Copyright (c) 06-18-2012,  Shawn W. Walker

Specific_Matrix = []; % init

if nargin==2
    for index = 1:length(obj.Integration)
        MAT_Set = obj.Integration(index).Matrix;
        MAT_Set_Names = MAT_Set.keys;
        if ismember(Matrix_Name,MAT_Set_Names)
            Specific_Matrix = MAT_Set(Matrix_Name);
            break;
        end
    end
else
    Int_Index = obj.Get_Integration_Index(Given_Integration_Domain);
    MAT_Set = obj.Integration(Int_Index).Matrix;
    MAT_Set_Names = MAT_Set.keys;
    if ismember(Matrix_Name,MAT_Set_Names)
        Specific_Matrix = MAT_Set(Matrix_Name);
    end
end

if isempty(Specific_Matrix)
    disp('Warning: Matrix not found!');
end

end