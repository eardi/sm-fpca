function obj = det_jacobian_with_quadrature_weight(obj)
%det_jacobian_with_quadrature_weight
%
%   Get the determinant of the jacobian multiplied by quadrature weight.

% Copyright (c) 05-19-2016,  Shawn W. Walker

obj.PHI.Det_Jacobian_with_quad_weight = sym('Det_Jac_w_Weight');

end