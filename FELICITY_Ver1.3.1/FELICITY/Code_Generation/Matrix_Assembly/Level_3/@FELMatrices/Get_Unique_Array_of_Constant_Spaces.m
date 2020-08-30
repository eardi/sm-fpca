function Array_Const_Space = Get_Unique_Array_of_Constant_Spaces(obj)
%Get_Unique_Array_of_Constant_Spaces
%
%   This returns a unique cell array of constant spaces.

% Copyright (c) 03-24-2017,  Shawn W. Walker

Map_Names = containers.Map;

for ind = 1:length(obj.Integration)
    Matrix_Names = obj.Integration(ind).Matrix.keys;
    for mm = 1:length(Matrix_Names)
        MAT = obj.Integration(ind).Matrix(Matrix_Names{mm});
        if ~isempty(MAT.row_constant_space)
            Map_Names(MAT.row_constant_space.CPP_Var) = MAT.row_constant_space;
        end
        if ~isempty(MAT.col_constant_space)
            Map_Names(MAT.col_constant_space.CPP_Var) = MAT.col_constant_space;
        end
    end
end

Array_Const_Space = Map_Names.values;

end