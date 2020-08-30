function obj = inverse_det_jacobian(obj)
%inverse_det_jacobian
%
%   Get the INVERSE of determinant of the jacobian/transformation.
%   Note: det(jacobian) = det(PHI.Grad) or sqrt(det(PHI.Metric)).

% Copyright (c) 05-19-2016,  Shawn W. Walker

obj.PHI.Inv_Det_Jacobian = sym('Inv_Det_Jac');

end