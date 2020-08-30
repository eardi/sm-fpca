function status = Copy_Files(Interior_Dir,Files,Output_Dir)
%Copy_Files
%
%   This copies several files to a desired location.
%
%   status = Copy_Files(Interior_Dir,Files,Output_Dir);
%
%   Interior_Dir = directory to copy from.
%   Files = array of structs specifying file names to copy.
%   Output_Dir = directory to copy to.
%
%   status = success == 0 or failure ~= 0.

% Copyright (c) 02-28-2012,  Shawn W. Walker

for ind=1:length(Files)
    WRITE_File = fullfile(Output_Dir, Files(ind).str);
    status = FEL_CopyFile(fullfile(Interior_Dir, Files(ind).str),WRITE_File);
end

end