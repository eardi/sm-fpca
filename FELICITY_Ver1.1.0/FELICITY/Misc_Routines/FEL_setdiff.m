function C = FEL_setdiff(A,B)
%FEL_setdiff
%
%   This returns the set difference of two sets of positive integers:
%   C = A \ B = { things in A that are not in B }
%   Note: this is much faster than built-in setdiff.
%
%   C = FEL_setdiff(A,B);

% Copyright (c) 04-23-2013,  Shawn W. Walker

if isempty(A)
    C = [];
    return;
end

if isempty(B)
    C = A;
    return; 
end

% then both non-empty
Num_A = max(A);
Num_B = max(B);

bits    = false(max(Num_A,Num_B), 1);
bits(A) = true;
bits(B) = false;
C = A(bits(A));

end