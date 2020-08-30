function FUNC = Get_Kappa(obj)
%Get_Kappa
%
%   This outputs a string representation of the function:
%   \kappa, where \kappa is the signed (total) curvature on the domain.
%
%   FUNC = obj.Get_Kappa;
%
%   FUNC = string representation of function.

% Copyright (c) 08-01-2011,  Shawn W. Walker

FUNC{1} = [obj.Name, '_', 'Total_Kappa'];

end