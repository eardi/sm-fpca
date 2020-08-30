function [obj, status] = Reset_Main_Dir(obj)
%Reset_Main_Dir
%
%   Remove Main_Dir, then recreate it.
%
%   [obj, status] = obj.Reset_Main_Dir();
%
%   status = indicates success == 0 or failure ~= 0.

% Copyright (c) 01-30-2017,  Shawn W. Walker

DIR = obj.Main_Dir;

[obj, status] = obj.Remove_Main_Dir();

[obj, status] = obj.Set_Main_Dir(DIR);

end