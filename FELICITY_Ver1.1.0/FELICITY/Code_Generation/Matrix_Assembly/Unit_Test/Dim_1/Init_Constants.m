function [C4, C5] = Init_Constants(t)
%Init_Constants
%
%   Setup some default constants!

% Copyright (c) 04-07-2010,  Shawn W. Walker

C4 = t^6;
if t > 0
    C5 = sin(2*pi*t);
else
    C5 = 0;
end

% END %