function status = Delete_Files_With_Ext(obj,Input_Dir,FileExt)
%Delete_Files_With_Ext
%
%   Delete ALL filenames with given extension.  This assumes the full path is
%   given, but maybe not the extension.
%
%   status = obj.Delete_Files_With_Ext(Input_Dir,FileExt);
%
%   Input_Dir = (string) directory to delete in.
%   FileExt = (string) file extension to delete.
%
%   status   = indicates success == 0 or failure ~= 0.

% Copyright (c) 04-10-2017,  Shawn W. Walker

FN = [fullfile(Input_Dir, '*'), '.', FileExt];
delete(FN);

% make sure the files were deleted
DD = dir(FN);
Still_Exists = ~isempty(DD);
if Still_Exists
    disp('These files were not deleted:');
    for ii = 1:length(DD)
        DD(ii)
    end
    status = 1;
else
    status = 0;
end

end