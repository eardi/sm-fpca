function success = Make_SubDir(obj,SubDir)
%Make_SubDir
%
%   This makes a sub-dir of obj.Output_Dir.

% Copyright (c) 04-10-2010,  Shawn W. Walker

success = true;

TEMP_STR = fullfile(obj.Output_Dir, SubDir);
if ~isdir(TEMP_STR)
    success = mkdir(obj.Output_Dir, SubDir);
end

end