function Q = FEL_Compute_Exact_Solution_Hessian_Ex_TD_2_GD_3()
%FEL_Compute_Exact_Solution_Hessian_Ex_TD_2_GD_3
%
%   Compute exact solution to test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 08-14-2014,  Shawn W. Walker

% parameterization of the domain: paraboloid over a unit disk
vr = sym('r','real');
vtheta = sym('theta','real');
vX = [vr .* cos(vtheta); vr .* sin(vtheta); (1 - vr.^2)];
Grad_vX = [diff(vX,'r'), diff(vX,'theta')];
Grad_vX = simplify(Grad_vX);

% compute the metric
g_met = simplify(Grad_vX' * Grad_vX);
g_met_inv = simplify(inv(g_met));

% define function
f1 = (vr.*cos(vtheta)).^2 .* (vr.*sin(vtheta)).^2;
%f1 = (vr.^1).*sin(vtheta).*exp(-vr);
f1

% compute the surface gradient and hessian (in local coordinates)
surf_grad_f1 = surf_grad(f1,g_met_inv,Grad_vX);
surf_hess_f1 = surf_grad(surf_grad_f1',g_met_inv,Grad_vX);

% compute Frob norm squared of hessian
f1_Norm_Sq = simplify(sum(sum(surf_hess_f1.^2)));
%f1_Norm_Sq
hess_11 = simplify(surf_hess_f1(1,1));
hess_trace = simplify(trace(surf_hess_f1));

% compute integrand of L^2 norm squared of hessian of f
%integrand = simplify(f1_Norm_Sq * sqrt(det(g_met)));
integrand = simplify(hess_trace * sqrt(det(g_met)));
%integrand
integrand_FH = matlabFunction(integrand);
%integrand_FH

XMIN = 0;
XMAX = 1;
YMIN = 0;
YMAX = 2*pi;
Q = integral2(integrand_FH,XMIN,XMAX,YMIN,YMAX,'AbsTol',1e-15);

end

function grad_func = surf_grad(func,g_met_inv,Grad_vX)

local_grad_func = [diff(func,'r'), diff(func,'theta')];
grad_func = simplify(local_grad_func * g_met_inv * Grad_vX');

end