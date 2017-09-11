function status = Write_Preprocessor_Include_Lines(obj,fid,FileName)
%Write_Preprocessor_Include_Lines
%
%   This writes ``#include "XXX"'' lines to a file, where XXX is a filename.
%   The filenames are stored in the array of struct FileName.

% Copyright (c) 06-29-2012,  Shawn W. Walker

ENDL = '\n';
for ind=1:length(FileName(:))
    fprintf(fid, ['#include "', FileName(ind).str, '"', ENDL]);
end
status = fprintf(fid, ['', ENDL]);

end