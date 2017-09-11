function New_S = FEL_subs(S,OLD,NEW)
%FEL_subs
%
%   This calls the symbolic toolbox functions "subs" but with the correct
%   arguments depending on the version of MATLAB.
%
%   New_S = FEL_subs(S,OLD,NEW);
%
%   type "help subs" for more info.

% Copyright (c) 06-10-2013,  Shawn W. Walker

if verLessThan('matlab', '8.1')
    % old version of "subs"
    New_S = subs(S,OLD,NEW,0); % you *need* the zero!
else
    % *new* version of "subs"
    New_S = subs(S,OLD,NEW);
end

end