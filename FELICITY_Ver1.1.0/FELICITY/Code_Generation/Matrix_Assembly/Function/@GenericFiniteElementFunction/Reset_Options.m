function obj = Reset_Options(obj)
%Reset_Options
%
%   This RESETS the options.

% Copyright (c) 04-10-2010,  Shawn W. Walker

Fields = fieldnames(obj.Opt);
for ind = 1:length(Fields)
    obj.Opt.(Fields{ind}) = false;
end

end