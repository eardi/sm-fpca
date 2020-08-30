function Integral_Value = integrate_on_face(Integrand,Xmap,global_vars,local_vars)
%integrate_on_face
%
%   This integrates over a triangle face (2-D manifold).  This can be a
%   triangle floating in \R^3.
%
%   Note: the reference domain is the standard "unit" triangle with
%         vertices [0, 0], [1, 0], [0, 1].

% Copyright (c) 09-27-2016,  Shawn W. Walker

% get coordinates in local reference domain
u = local_vars(1);
v = local_vars(2);

% compute the metric tensor
dX_du = diff(Xmap,u);
dX_dv = diff(Xmap,v);
g11 = sum(dX_du .* dX_du);
g12 = sum(dX_du .* dX_dv);
g21 = sum(dX_dv .* dX_du);
g22 = sum(dX_dv .* dX_dv);

% compute determinant
det_g = g11*g22 - g12*g21;
dudv = sqrt(det_g);

% plug in parameterization
Integrand = subs(Integrand,global_vars,Xmap);
Integrand_with_dudv = Integrand * dudv;

% integrate with respect to u, from 0 to (1-v)
Indef_Integral_1 = int(Integrand_with_dudv,u);
Integrand_with_dv = subs(Indef_Integral_1,u, (1-v)) - subs(Indef_Integral_1,u, 0);

% next, integrate with respect to v, from 0 to 1
Indef_Integral_2 = int(Integrand_with_dv,v);
% evaluate definite integral
Integral_Value = subs(Indef_Integral_2,v, 1) - subs(Indef_Integral_2,v, 0);

end