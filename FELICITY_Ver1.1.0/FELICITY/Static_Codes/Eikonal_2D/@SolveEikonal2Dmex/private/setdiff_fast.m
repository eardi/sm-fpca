function C = setdiff_fast(A,B)
% setdiff_fast:
%
%   Set difference of two sets of positive integers (much faster than built-in setdiff)
%
% C = my_setdiff(A,B)
% C = A \ B = { things in A that are not in B }
%
% we will assume that A is non-empty and that A contains B


% if isempty(A)
%     C = [];
%     return;
if isempty(B)
    C = A;
    return; 
else % both non-empty
    bits = false(1, max(A));
    bits(A) = 1;
    bits(B) = 0;
    C = A(bits(A));
end