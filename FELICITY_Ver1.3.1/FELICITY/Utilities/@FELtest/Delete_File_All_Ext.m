function status = Delete_File_All_Ext(obj,FileName)
%Delete_File_All_Ext
%
%   Delete given filename with ANY extension.  This assumes the full path is
%   given, but maybe not the extension.
%
%   status = obj.Delete_File_All_Ext(FileName);
%
%   FileName = (string) file name to delete.
%
%   status   = indicates success == 0 or failure ~= 0.

% Copyright (c) 04-10-2017,  Shawn W. Walker

[PATH, NAME, EXT] = fileparts(FileName);
FN = [fullfile(PATH,NAME), '.*'];
delete(FN);

% make sure the files were deleted
DD = dir(FN);
Still_Exists = ~isempty(DD);
if Still_Exists
    disp(['This file was not deleted: ', FileName]);
    status = 1;
else
    status = 0;
end

end