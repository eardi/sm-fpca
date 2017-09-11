function subs_handle = FEL_subs_handle()
%FEL_subs_handle
%
%   This returns a function handle to the correct version of subs to use for FELICITY.
%
%   subs_handle = FEL_subs_handle();
%
%   type "help subs" for more info.

% Copyright (c) 01-24-2014,  Shawn W. Walker

if verLessThan('matlab', '8.1')
    % old version of "subs"
    subs_handle = @(S,OLD,NEW) subs(S,OLD,NEW,0); % you *need* the zero!
else
    % *new* version of "subs"
    subs_handle = @(S,OLD,NEW) subs(S,OLD,NEW);
end

end