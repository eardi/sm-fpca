function SF = Get_Derivative(obj,alpha)
%Get_Derivative
%
%   This outputs a FELSymFunc for the particular (multi-index) derivative you
%   want.
%
%   SF = obj.Get_Derivative(alpha);
%
%   alpha = 1xN vector that contains the derivatives to compute in multi-index
%           notation.  N = number of independent variables of the function.

% Copyright (c) 02-28-2013,  Shawn W. Walker

Deriv_Order = error_check_alpha(obj,alpha);

if (Deriv_Order==0)
    SF = obj.Base_Func;
else
    key_str = make_alpha_str(alpha);
    SF = obj.Deriv_Func(key_str);
end

end