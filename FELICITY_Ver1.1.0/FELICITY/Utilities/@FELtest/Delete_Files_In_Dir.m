function status = Delete_Files_In_Dir(obj,DIR)
%Delete_Files_In_Dir
%
%   Delete files in specified directory.
%
%   status = obj.Delete_Files_In_Dir(DIR);
%
%   DIR = (string) directory to delete files from.
%
%   status   = indicates success == 0 or failure ~= 0.

% Copyright (c) 12-10-2010,  Shawn W. Walker

FN = fullfile(DIR,'*.*');
delete(FN);

listing = dir(DIR);
if (length(listing) > 2)
    disp('Not all files were deleted from: ');
    disp(['     ', DIR]);
    status = -1;
elseif (length(listing)==2)
    if ~and(strcmp(listing(1).name,'.'),strcmp(listing(2).name,'..'))
        disp('File structure not correct.');
        status = -1;
        error('This should not happen!');
    else
        status = 0;
    end
elseif (length(listing)==1)
    disp('File structure not correct.');
    status = -1;
    error('This should not happen!');
else
    status = 0;
end

end