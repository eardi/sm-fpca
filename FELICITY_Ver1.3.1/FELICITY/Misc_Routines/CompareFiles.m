function IDENTICAL = CompareFiles(File1,File2)
%CompareFiles
%
%   This compares two text files and returns whether they are identical or not.
%
%   IDENTICAL = CompareFiles(File1,File2);
%
%   File1,File2 = (string) full path file names to compare.
%
%   IDENTICAL = (boolean) indicates if they are the same.

% Copyright (c) 12-10-2010,  Shawn W. Walker

fid1 = fopen(File1, 'r');
fid2 = fopen(File2, 'r');
IDENTICAL = true; % init

while true
    % read in line
    line1 = fgetl(fid1);
    line2 = fgetl(fid2);
    if and(~ischar(line1),~ischar(line2))
        break;
    end
    if ~strcmp(line1,line2)
        IDENTICAL = false;
        break;
    end
end
status1 = fclose(fid1);
status2 = fclose(fid2);
if status1~=0
    disp('--------------------------------');
    disp(['This file did not close properly: ''', File1, '''']);
    disp(['status = ', num2str(status1,'%d')]);
    disp('--------------------------------');
    error('Find out what went wrong!');
end
if status2~=0
    disp('--------------------------------');
    disp(['This file did not close properly: ''', File2, '''']);
    disp(['status = ', num2str(status2,'%d')]);
    disp('--------------------------------');
    error('Find out what went wrong!');
end

% END %