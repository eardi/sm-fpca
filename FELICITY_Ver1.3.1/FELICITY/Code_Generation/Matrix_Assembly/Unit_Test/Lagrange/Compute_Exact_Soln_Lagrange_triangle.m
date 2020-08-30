function [soln_func, soln_grad_func, f_func] = Compute_Exact_Soln_Lagrange_triangle(exact_soln,vars)
%Compute_Exact_Soln_Lagrange_triangle

% Copyright (c) 04-04-2018,  Shawn W. Walker

DIM = length(vars);

soln_func = matlabFunction(exact_soln);
soln_func

% compute the gradient
soln_grad = sym(zeros(length(vars),1));
for ii=1:DIM
    soln_grad(ii) = diff(exact_soln,vars(ii),1);
end
soln_grad_func = matlabFunction(soln_grad);
soln_grad_func

% compute \Delta
soln_lap = sym(0);
for ii=1:DIM
    soln_lap = soln_lap + diff(exact_soln,vars(ii),2);
end
% f = -\Delta u + u
f = -soln_lap + exact_soln;
f_func = matlabFunction(f);
f_func

end