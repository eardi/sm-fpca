function status = Check_For_Valid_Domain(DOM)
%Check_For_Valid_Domain
%
%   This verifies that the given DOM is a Level 1 Domain.

% Copyright (c) 06-13-2014,  Shawn W. Walker

VALID = isa(DOM,'Domain');

if ~VALID
    error('DOM must be a ''Domain'' class!');
end

status = 0;

end