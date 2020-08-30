function obj = Include_C_Code(obj,FileName)
%Include_C_Code
%
%   This saves info for including external user created C code.
%
%   obj      = obj.Include_C_Code(FileName);
%
%   FileName = (string) full path to file name of C code to include.
%               Note: the extension of the file should be ".c".

% Copyright (c) 06-12-2014,  Shawn W. Walker

if ~char(FileName)
    error('FileName must be a string!');
end

[CC.Path, CC.File, CC.Ext] = fileparts(FileName);

if strcmp(CC.Path,'')
    CC.Path = []; % will use same directory as the external M-file (script).
end
if ~strcmp(CC.Ext,'.c')
    error('File should have a .c extension!');
end

obj = obj.Append_C_Code_Info(CC);

end