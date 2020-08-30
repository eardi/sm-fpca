function status = Check_For_Valid_Interpolation(INTERP)
%Check_For_Valid_Interpolation
%
%   This verifies that the given INTERP is a valid class.

% Copyright (c) 01-25-2013,  Shawn W. Walker

VALID = isa(INTERP,'Interpolate');

if ~VALID
    error('INTERP must be an ''Interpolate'' class!');
end

status = 0;

end