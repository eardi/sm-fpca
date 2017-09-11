function status = Check_For_Valid_Matrix(Matrix)
%Check_For_Valid_Matrix
%
%   This verifies that the given Matrix is a valid class.
%
%   status = Check_For_Valid_Matrix(Matrix);
%
%   Matrix = is a genericform object (i.e. Bilinear, Linear, or Real object).

% Copyright (c) 08-01-2011,  Shawn W. Walker

BILINEAR  = isa(Matrix,'Bilinear');
LINEAR    = isa(Matrix,'Linear');
REAL      = isa(Matrix,'Real');

if ~or(or(BILINEAR,LINEAR),REAL)
    error('Matrix type must be a Bilinear, Linear, or Real object!');
end

status = 0;

end