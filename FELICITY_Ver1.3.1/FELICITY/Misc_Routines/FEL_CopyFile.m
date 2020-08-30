function status = FEL_CopyFile(File1,File2)
%FEL_CopyFile
%
%   This copies what is at location file1 to file2.
%
%   status = FEL_CopyFile(File1,File2)
%
%   File1, File2 = (string) full path file names.
%
%   status = (integer) indicates success == 0 or failure ~= 0.

% Copyright (c) 01-08-2020,  Shawn W. Walker

% find out the O/S
OS1 = computer;

if strcmp(OS1(1:4),'GLNX')
    COPY_STR = 'cp';
elseif strcmp(OS1(1:3),'MAC')
    COPY_STR = 'cp';
elseif strcmp(OS1(1:5),'PCWIN')
    COPY_STR = 'copy';
else
    error('Computer architecture not recognized!');
end

% % make sure MATLAB sees the file to be copied!
% EX_ID = exist(File1,'file');
% if (EX_ID~=2)
%     disp('MATLAB cannot see the file to be copied...');
%     error('Please report this error!');
% end

%[status, result] = system([COPY_STR, ' ', File1, ' ', File2]);
[status, result] = system([COPY_STR, ' "', File1, '" "', File2, '"']);
if (status~=0)
    disp(['Tried to copy ', File1, ' to ', File2, '  ...']);
    disp(['The result was: ']);
    disp(result);
    error('Copy failed!');
end

% make sure MATLAB notices that the file is there!
EX_ID = exist(File2,'file');
if (EX_ID~=2)
    disp('MATLAB cannot see the file that just got copied...');
    error('Please report this error!');
end

end