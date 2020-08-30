function FEM_Matrix_Specific_Consistency_Check(SpecificMAT,Row_Space_Num_Comp,Col_Space_Num_Comp)
%FEM_Matrix_Specific_Consistency_Check
%
%   This just makes some sanity checks.

% Copyright (c) 03-24-2017,  Shawn W. Walker

MAX_ROW_SHIFT = -1;
MAX_COL_SHIFT = -1;
for ind=1:SpecificMAT.Num_SubMAT
    MAX_ROW_SHIFT = max(MAX_ROW_SHIFT,SpecificMAT.SubMAT(ind).Row_Shift);
    MAX_COL_SHIFT = max(MAX_COL_SHIFT,SpecificMAT.SubMAT(ind).Col_Shift);
end

if (Row_Space_Num_Comp < (MAX_ROW_SHIFT+1))
    Row_Space_Num_Comp
    (MAX_ROW_SHIFT+1)
    disp('The number of tuple components in RowElem is LESS than the number of');
    disp('              tuple components used in SpecificMAT.');
    error('Check your matrix gen code!');
end
if (Col_Space_Num_Comp < (MAX_COL_SHIFT+1))
    Col_Space_Num_Comp
    (MAX_COL_SHIFT+1)
    disp('The number of tuple components in ColElem is LESS than the number of');
    disp('              tuple components used in SpecificMAT.');
    error('Check your matrix gen code!');
end

end