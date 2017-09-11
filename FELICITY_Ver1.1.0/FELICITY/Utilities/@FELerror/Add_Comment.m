function obj = Add_Comment(obj,Comment)
%Add_Comment
%
%   This appends a comment to the error message.
%
%   obj = obj.Add_Comment(Comment);
%
%   Comment = a string.

% Copyright (c) 12-10-2010,  Shawn W. Walker

if isempty(Comment)
    Comment = '';
end

if ~ischar(Comment)
    error('Comment must be a string.');
end

Num_Comments = length(obj.Error_Comment);
obj.Error_Comment(Num_Comments+1).str = Comment;

end