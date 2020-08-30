function Write(obj,Priority_Level,FileName)
%Write
%
%   This will write all of the log comments that have been stored to the
%   default directory.
%
%   obj.Write(Priority_Level,FileName);
%
%   Priority_Level = this indicates to write comments that have a priority
%                    level <= 'Priority_Level'.  Note: Priority_Level = 0 is
%                    "high" priority.  If Priority_Level = [], then the level is
%                    set to "infinity".
%   FileName = where to write the comments to.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if isempty(FileName)
    Fixed_File = fullfile(obj.Default_Dir,obj.Default_FileName);
else
    Fixed_File = fullfile(obj.Default_Dir,FileName);
end

if ~isnumeric(Priority_Level)
    error('Desired priority level must be an integer.');
end
if isempty(Priority_Level)
    Priority_Level = 10000;
end

Num_Comments = length(obj.Log_Comment);
Priority_Level = max(Priority_Level,0);

fid = fopen(Fixed_File, 'w');
% loop through all log comments
for index=1:Num_Comments
    level = obj.Log_Comment(index).str{1};
    if level <= Priority_Level
        fprintf(fid, obj.Log_Comment(index).str{2});
        fprintf(fid, obj.ENDL);
    end
end
STD_LINE = '---------------------------------------------------';
fprintf(fid, [STD_LINE, obj.ENDL]);
fprintf(fid, ['END OF LOG FILE', obj.ENDL]);
fprintf(fid, [STD_LINE, obj.ENDL]);

status = fclose(fid);
if status~=0
    disp('--------------------------------');
    disp(['This file did not close properly: ''', Fixed_File, '''']);
    disp(['status = ', num2str(status,'%d')]);
    disp('--------------------------------');
    error('Find out what went wrong!');
end

% END %