function obj = Add_Comment(obj,Priority_Level,Comment)
%Add_Comment
%
%   This appends a comment to the log.  Priority_Level = 0 is the highest!
%
%   obj = obj.Add_Comment(Priority_Level,Comment);
%
%   Priority_Level = a number representing a qualitative "priority level" to
%                    assign to the logged info.
%   Comment = (string) the info to log/record.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if ~isnumeric(Priority_Level)
    error('Desired priority level must be an integer.');
end
if ~ischar(Comment)
    error('Comment must be a string.');
end

Num_Comments = length(obj.Log_Comment);
Priority_Level = max(Priority_Level,0);

obj.Log_Comment(Num_Comments+1).str{1} = Priority_Level;
obj.Log_Comment(Num_Comments+1).str{2} = [Comment, obj.ENDL];

% echo the comment to the console
disp(Comment);

end