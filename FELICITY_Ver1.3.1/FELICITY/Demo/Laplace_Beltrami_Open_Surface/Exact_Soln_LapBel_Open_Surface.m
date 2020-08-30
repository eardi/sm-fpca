function [soln_func, lambda_func, f_func] = Exact_Soln_LapBel_Open_Surface()
%Exact_Soln_LapBel_Open_Surface

% Copyright (c) 11-07-2017,  Shawn W. Walker

% define surface height function
saddle_func = @(x,y) 0.5*(x.^2 - y.^2);

u = sym('u','real'); % u = x
v = sym('v','real'); % v = y

% define solution in reference domain
soln_tilde = sin(2*pi*u) .* cos(2*pi*v);
soln_func = matlabFunction(soln_tilde);
soln_func

% define surface parameterization
Xmap = [u;v;saddle_func(u,v)];

% compute metric
Xmap_du = diff(Xmap,'u',1);
Xmap_dv = diff(Xmap,'v',1);
J = [Xmap_du, Xmap_dv];
g = transpose(J) * J;

% compute the inverse metric
g_inv = inv(g);
det_g = det(g);

% g
% g_inv
% det_g

% compute derivatives of soln (in reference domain)
soln_du = diff(soln_tilde,'u',1);
soln_dv = diff(soln_tilde,'v',1);

% compute Laplace-Beltrami
TT1 = g_inv(1,1) * soln_du * Xmap_du + g_inv(1,2) * soln_du * Xmap_dv + ...
      g_inv(2,1) * soln_dv * Xmap_du + g_inv(2,2) * soln_dv * Xmap_dv;
%
TT1_du = diff(TT1,'u',1);
TT1_dv = diff(TT1,'v',1);
% Laplace-Beltrami in reference coordinates
LB_soln = g_inv(1,1) * dot(TT1_du,Xmap_du) + g_inv(1,2) * dot(TT1_du,Xmap_dv) + ...
          g_inv(2,1) * dot(TT1_dv,Xmap_du) + g_inv(2,2) * dot(TT1_dv,Xmap_dv);
%

LB_soln_temp = simplify(LB_soln);
symbolic_f = -LB_soln_temp;

% RHS f term
f_func = matlabFunction(symbolic_f);
f_func

% compute the normal vector
NV_temp = cross(Xmap_du,Xmap_dv);
NV_temp_norm = sqrt(transpose(NV_temp) * NV_temp);
Normal_Vector = NV_temp / NV_temp_norm;

% parameterize the boundary curve (tangent)
tau_temp = [-v;u;-2*u*v];
tau_temp_norm = sqrt(transpose(tau_temp) * tau_temp);
Tangent_Vector = tau_temp / tau_temp_norm;

% cross product to get xi vector
xi_Vector = cross(Tangent_Vector,Normal_Vector);

% compute the surface gradient of the solution
soln_surf_grad = ([soln_du, soln_dv] * g_inv * transpose(J))';

% compute the Neumann data
lambda = -dot(xi_Vector,soln_surf_grad);
lambda = simplify(lambda);
lambda_func = matlabFunction(lambda);
lambda_func

end