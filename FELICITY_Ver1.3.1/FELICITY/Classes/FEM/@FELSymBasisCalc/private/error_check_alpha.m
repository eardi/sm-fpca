function Deriv_Order = error_check_alpha(obj,alpha)
%error_check_alpha
%
%   This performs an error check to make sure the alpha multi-index is valid.
%
%   Note: alpha is 1xN row vector, where N is the number of independent
%         variables.

% Copyright (c) 03-04-2013,  Shawn W. Walker

Multiindex_Length = obj.Get_Length_Of_Multiindex;

if (length(alpha)~=Multiindex_Length)
    error('Length of alpha multi-index does not match number of (original) independent variables!');
end

Deriv_Order = sum(alpha);
if (Deriv_Order > obj.Max_Deriv)
    error('Multi-index derivative order is too large!');
end

end