function [soln_func, soln_surf_grad_func, soln_surf_hess, f_func, normal_vec_func] = DiffGeo_HHJk_Surface(surf_func,soln_tilde,vars)
%DiffGeo_HHJk_Surface

% Copyright (c) 03-30-2018,  Shawn W. Walker

% note: surf_func is a height function

u = vars(1);
v = vars(2);

soln_func = matlabFunction(soln_tilde);
soln_func

% define surface parameterization
Xmap = [u;v;surf_func(u,v)];

% compute metric
Xmap_du = diff(Xmap,u,1);
Xmap_dv = diff(Xmap,v,1);
J = [Xmap_du, Xmap_dv];
g = transpose(J) * J;

% compute the inverse metric
g_inv = inv(g);
%det_g = det(g);

% g
% g_inv
% det_g

% get grad(u), hess(u)
[soln_surf_grad, soln_surf_hess] = get_surf_grad_surf_hess(u,v,soln_tilde,J,g,g_inv);
soln_surf_grad_func = matlabFunction(soln_surf_grad);
%soln_surf_grad_func
% soln_surf_hess_func = matlabFunction(soln_surf_hess(:)');
% soln_surf_hess_func
soln_surf_hess

% get Laplace-Beltrami
soln_surf_lap = trace(soln_surf_hess);
soln_surf_lap = simplify(soln_surf_lap);

% get grad(\Delta u), hess(\Delta u)
[~, SL_hess] = get_surf_grad_surf_hess(u,v,soln_surf_lap,J,g,g_inv);
soln_surf_biharmonic = trace(SL_hess);
symbolic_f = simplify(soln_surf_biharmonic);
%symbolic_f

% RHS f term
f_func = matlabFunction(symbolic_f);
f_func

% compute the normal vector
NV_temp = cross(Xmap_du,Xmap_dv);
NV_temp_norm = sqrt(transpose(NV_temp) * NV_temp);
Normal_Vector = NV_temp / NV_temp_norm;
normal_vec_func = matlabFunction(Normal_Vector);
%normal_vec_func

end

function [surf_grad, surf_hess] = get_surf_grad_surf_hess(u,v,func,J,g,g_inv)

% % compute derivatives of soln (in reference domain)
% func_du = diff(func,u,1);
% func_dv = diff(func,v,1);
% 
% % compute the surface gradient of the solution (in reference coordinates)
% surf_grad = ([func_du, func_dv] * g_inv * transpose(J))';
% surf_grad = simplify(surf_grad);

surf_grad = get_surf_grad_only(u,v,func,J,g_inv);

% compute the COVARIANT surface hessian!

% compute derivatives of soln (in reference domain)
func_grad = [diff(func,u,1); diff(func,v,1)];

% compute hessian of soln (in reference domain)
func_hess = [diff(func,u,u), diff(func,u,v);
             diff(func,v,u), diff(func,v,v)];
%

% differentiate metric
grad_metric(2).mat = [];
grad_metric(1).mat = simplify(diff(g,u));
grad_metric(2).mat = simplify(diff(g,v));

% compute the Christoffel symbols (2nd kind)
Gamma(2).ij = sym(zeros(2,2));
for kk=1:2
for ii=1:2
for jj=1:2
    TEMP = sym(0);
    for ll=1:2
        TEMP = TEMP + g_inv(kk,ll) * ( grad_metric(ii).mat(ll,jj) + grad_metric(jj).mat(ii,ll) - grad_metric(ll).mat(ii,jj) );
    end
    Gamma(kk).ij(ii,jj) = (1/2) * simplify(TEMP);
end
end
end

% compute "local" term
local_hess = func_hess - ( func_grad(1) * Gamma(1).ij + func_grad(2) * Gamma(2).ij );
local_hess = simplify(local_hess);

% map to surface
J_g_inv_MAT = J * g_inv;
surf_hess = J_g_inv_MAT * local_hess * (transpose(J_g_inv_MAT));



% % compute derivatives in reference domain
% surf_grad_du = diff(surf_grad,u,1);
% surf_grad_dv = diff(surf_grad,v,1);
% 
% % compute the surface gradient of the solution (in reference coordinates)
% surf_hess_row(3).vec = [];
% for ii = 1:3
%     surf_hess_row(ii).vec = [surf_grad_du(ii), surf_grad_dv(ii)] * g_inv * transpose(J);
% end
% surf_hess = [surf_hess_row(1).vec;
%              surf_hess_row(2).vec;
%              surf_hess_row(3).vec];
% %
% surf_hess = simplify(surf_hess);

end

function surf_grad = get_surf_grad_only(u,v,func,J,g_inv)

% compute derivatives of soln (in reference domain)
func_du = diff(func,u,1);
func_dv = diff(func,v,1);

% compute the surface gradient of the solution (in reference coordinates)
surf_grad = ([func_du, func_dv] * g_inv * transpose(J))';
surf_grad = simplify(surf_grad);

end