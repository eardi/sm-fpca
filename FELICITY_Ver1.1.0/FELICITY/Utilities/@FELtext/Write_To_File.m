function count = Write_To_File(obj,FID)
%Write_To_File
%
%   This writes the (internally stored) text lines to a file.
%
%   count = obj.Write_To_File(FID);
%
%   FID   = file identifier for where to write text lines.
%
%   count = returns the number of bytes that fprintf writes.

% Copyright (c) 12-10-2010,  Shawn W. Walker

for ind=1:length(obj.Text)
    count = fprintf(FID, obj.Text(ind).line);
end

end