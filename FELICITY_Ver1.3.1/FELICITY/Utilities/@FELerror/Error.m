function Error(obj)
%Error
%
%   This will print an error message to the console, then you must stop the
%   MATLAB execution!
%
%   obj.Error;

% Copyright (c) 12-10-2010,  Shawn W. Walker

Num_Comments = length(obj.Error_Comment);
for index=1:Num_Comments
    disp(obj.Error_Comment(index).str);
end

obj.Sign_Off;

end