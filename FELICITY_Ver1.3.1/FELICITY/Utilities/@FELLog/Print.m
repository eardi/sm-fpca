function Print(obj,Priority_Level)
%Print
%
%   This will print all of the log comments to the MATLAB console.
%
%   obj.Print(Priority_Level);
%
%   Priority_Level = this indicates to print comments that have a priority
%                    level <= 'Priority_Level'.  Note: Priority_Level = 0 is
%                    "high" priority.  If Priority_Level = [], then the level is
%                    set to "infinity".

% Copyright (c) 12-10-2010,  Shawn W. Walker

if ~isnumeric(Priority_Level)
    error('Desired priority level must be an integer.');
end
if isempty(Priority_Level)
    Priority_Level = 10000;
end

Num_Comments = length(obj.Log_Comment);
Priority_Level = max(Priority_Level,0);

for index=1:Num_Comments
    level = obj.Log_Comment(index).str{1};
    if level <= Priority_Level
        temp_str = sprintf(obj.Log_Comment(index).str{2});
        disp(temp_str);
    end
end
disp('...END OF LOG FILE...');

end