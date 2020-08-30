function FUNC = Get_Kappa_Gauss(obj)
%Get_Kappa_Gauss
%
%   This outputs a string representation of the function:
%   \kappa_G, where \kappa_G is the Gauss curvature on the domain.
%
%   FUNC = obj.Get_Kappa_Gauss;
%
%   FUNC = string representation of function.

% Copyright (c) 03-09-2012,  Shawn W. Walker

FUNC{1} = [obj.Name, '_', 'Gauss_Kappa'];

end