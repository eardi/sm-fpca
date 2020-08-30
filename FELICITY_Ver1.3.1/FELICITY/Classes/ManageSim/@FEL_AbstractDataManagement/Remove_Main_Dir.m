function [obj, status] = Remove_Main_Dir(obj)
%Remove_Main_Dir
%
%   Remove the current data directory, and set obj.Main_Dir to [];
%
%   [obj, status] = obj.Remove_Main_Dir();
%
%   status = indicates success == 0 or failure ~= 0.

% Copyright (c) 01-30-2017,  Shawn W. Walker

if (nargout < 1)
    disp('This routine modifies the object.');
    error('You must return the object (at least)!');
end

DIR = obj.Main_Dir;
obj.Main_Dir = []; % set to NULL value

status = obj.Remove_Dir(DIR);

end