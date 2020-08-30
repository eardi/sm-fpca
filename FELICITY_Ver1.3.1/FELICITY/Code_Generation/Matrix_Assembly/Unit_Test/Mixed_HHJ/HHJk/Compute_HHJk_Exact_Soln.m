function [soln_func, soln_grad_func, soln_hess, f_func] = Compute_HHJk_Exact_Soln(soln,vars)
%Compute_HHJk_Exact_Soln

% Copyright (c) 04-05-2018,  Shawn W. Walker

x = vars(1);
y = vars(2);

soln_func = matlabFunction(soln);
soln_func

% compute gradient of soln
soln_grad = [diff(soln,x,1); diff(soln,y,1)];
soln_grad_func = matlabFunction(soln_grad);
soln_grad_func

% compute hessian of soln
soln_hess = [diff(soln,x,x), diff(soln,x,y);
             diff(soln,y,x), diff(soln,y,y)];
% soln_hess_func = matlabFunction(soln_hess);
% soln_hess_func


% % get Laplace-Beltrami
% soln_surf_lap = trace(soln_surf_hess);
% soln_surf_lap = simplify(soln_surf_lap);
% 
% % get grad(\Delta u), hess(\Delta u)
% [~, SL_hess] = get_surf_grad_surf_hess(u,v,soln_surf_lap,J,g_inv????);
% soln_surf_biharmonic = trace(SL_hess);
% soln_surf_biharmonic_func = matlabFunction(soln_surf_biharmonic);
% %soln_surf_biharmonic_func
% 
% symbolic_f = simplify(soln_surf_biharmonic_func);
% 
% % RHS f term
% f_func = matlabFunction(symbolic_f);
% f_func
f_func = [];

end