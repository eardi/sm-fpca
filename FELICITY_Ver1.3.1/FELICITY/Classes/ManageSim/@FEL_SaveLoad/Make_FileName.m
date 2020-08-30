function FN = Make_FileName(obj, Index)
%Make_FileName
%
%   Make a valid filename from the given simulation index corresponding to dynamic data.
%
%   FN = obj.Make_FileName(Index);

% Copyright (c) 09-17-2014,  Shawn W. Walker

Pad_Length = obj.Num_Pad_Zeros_File_Index;

Index_str = Make_Index_String(Index, Pad_Length);

Subdir = obj.Main_Dir;
Prefix = obj.File_Prefix;

FN = fullfile(Subdir, [Prefix, Index_str, '.mat']);

end