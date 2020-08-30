function obj = Reset_Options(obj)
%Reset_Options
%
%   This RESETS the options.

% Copyright (c) 04-10-2010,  Shawn W. Walker

RESET_CF_Opt = obj.Get_Opt_struct();
TEMP_obj = obj;
TEMP_obj.Opt = RESET_CF_Opt;

obj = obj.Set_Options(TEMP_obj);

end