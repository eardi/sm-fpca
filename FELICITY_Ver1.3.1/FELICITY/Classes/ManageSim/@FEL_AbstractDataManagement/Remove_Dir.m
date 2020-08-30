function status = Remove_Dir(obj,DIR)
%Remove_Dir
%
%   Remove specified directory.
%
%   status = obj.Remove_Dir(DIR);
%
%   DIR    = (string) directory to remove.
%
%   status = indicates success == 0 or failure ~= 0.

% Copyright (c) 01-30-2017,  Shawn W. Walker

% clear out that directory
if FEL_isfolder(DIR)
    [SUCCESS,MESSAGE,MESSAGEID] = rmdir(DIR, 's');
%     MESSAGE
%     MESSAGEID
else
    disp(['The directory "', DIR, '" does not exist, so no need to remove.']);
    SUCCESS = true;
end

% if the directory still exists
if or(FEL_isfolder(DIR),~SUCCESS)
    disp('There was a problem removing the directory: ');
    disp(['      ', DIR]);
    disp('Make sure the directory is not being viewed by YOU!');
    disp('... i.e. opened in a file explorer.');
    disp('Also make sure all files in that directory are NOT open!');
    disp('... i.e. not being written to or accessed.');
    status = -1;
else
    status = 0;
end

end