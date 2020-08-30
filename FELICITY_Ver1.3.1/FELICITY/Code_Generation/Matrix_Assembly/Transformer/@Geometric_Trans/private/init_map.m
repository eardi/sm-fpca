function obj = init_map(obj)
%init_map
%
%   This initializes the local map form.

% Copyright (c) 04-03-2018,  Shawn W. Walker

obj = mesh_size(obj);

obj = value_map(obj);
obj = grad_map(obj);
obj = metric_map(obj); % 1st fundamental form
obj = det_metric(obj);
obj = inverse_det_metric(obj);
obj = inverse_metric_map(obj);

obj = det_jacobian(obj);
obj = det_jacobian_with_quadrature_weight(obj);
obj = inverse_det_jacobian(obj);
obj = inverse_grad_map(obj);

obj = tangent_vector(obj);
obj = normal_vector(obj);
obj = tan_space_proj(obj);

obj = hess_map(obj);
obj = hess_inverse_map(obj);
obj = grad_metric_map(obj); % gradient (in local coordinates) of the metric matrix g
obj = grad_inverse_metric_map(obj); % gradient (in local coordinates) of the inverse metric matrix g^{-1}
obj = christoffel_2nd_kind(obj); % these are the \Gamma^k_{i,j}, where symmetric in (i,j)
obj = second_fund_form(obj); % 2nd fundamental form
obj = det_second_fund_form(obj);
obj = inverse_det_second_fund_form(obj);

obj = total_curvature_vector(obj);
obj = total_curvature(obj);
obj = gauss_curvature(obj);
obj = shape_op(obj);

end