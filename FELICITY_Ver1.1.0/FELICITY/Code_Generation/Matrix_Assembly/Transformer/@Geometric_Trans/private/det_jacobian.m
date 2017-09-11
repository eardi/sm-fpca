function obj = det_jacobian(obj)
%det_jacobian
%
%   Get the determinant of the jacobian/transformation.
%   Note: det(jacobian) = det(PHI.Grad) or sqrt(det(PHI.Metric)).

% Copyright (c) 02-20-2012,  Shawn W. Walker

obj.PHI.Det_Jacobian = sym('[Det_Jac]');

end