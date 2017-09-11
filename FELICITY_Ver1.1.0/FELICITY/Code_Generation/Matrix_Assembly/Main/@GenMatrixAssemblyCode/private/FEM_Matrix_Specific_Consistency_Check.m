function FEM_Matrix_Specific_Consistency_Check(SpecificMAT,RowElem,ColElem)
%FEM_Matrix_Specific_Consistency_Check
%
%   This just makes some sanity checks.

% Copyright (c) 06-06-2012,  Shawn W. Walker

MAX_ROW_SHIFT = -1;
MAX_COL_SHIFT = -1;
for ind=1:SpecificMAT.Num_SubMAT
    MAX_ROW_SHIFT = max(MAX_ROW_SHIFT,SpecificMAT.SubMAT(ind).Row_Shift);
    MAX_COL_SHIFT = max(MAX_COL_SHIFT,SpecificMAT.SubMAT(ind).Col_Shift);
end

if (RowElem.Num_Comp < (MAX_ROW_SHIFT+1))
    disp('The number of vector components in RowElem is LESS than the number of');
    disp('              vector components used in SpecificMAT.');
    error('Check your matrix gen code!');
end
if (ColElem.Num_Comp < (MAX_COL_SHIFT+1))
    disp('The number of vector components in ColElem is LESS than the number of');
    disp('              vector components used in SpecificMAT.');
    error('Check your matrix gen code!');
end

end