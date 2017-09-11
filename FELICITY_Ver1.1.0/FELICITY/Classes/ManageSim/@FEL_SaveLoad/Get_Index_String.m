function Index_str = Get_Index_String(obj, Index)
%Get_Index_String
%
%   Make a string from the given simulation index, with zeros "padded".
%
%   Index_str = obj.Get_Index_String(Index);

% Copyright (c) 08-07-2014,  Shawn W. Walker

Pad_Length = obj.Num_Pad_Zeros_File_Index;

Index_str = Make_Index_String(Index, Pad_Length);

end