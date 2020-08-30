function Integral_Value = integrate_on_tetrahedron(Integrand,Xmap,global_vars,local_vars)
%integrate_on_tetrahedron
%
%   This integrates over a tetrahedron (3-D volume).  This can be a
%   tetrahedron floating in \R^3.
%
%   Note: the reference domain is the standard "unit" tetrahedron with
%         vertices [0, 0, 0], [1, 0, 0], [0, 1, 0], [0, 0, 1].

% Copyright (c) 09-27-2016,  Shawn W. Walker

% get coordinates in local reference domain
u = local_vars(1);
v = local_vars(2);
w = local_vars(3);

% compute the Jacobian
dX_du = diff(Xmap,u);
dX_dv = diff(Xmap,v);
dX_dw = diff(Xmap,w);
J1 = [dX_du, dX_dv, dX_dw];

% compute determinant
dudvdw = det(J1);

% plug in parameterization
Integrand = subs(Integrand,global_vars,Xmap);
Integrand_with_dudvdw = Integrand * dudvdw;

% integrate with respect to u, from 0 to (1-v-w)
Indef_Integral_1  = int(Integrand_with_dudvdw,u);
Integrand_with_dvdw = subs(Indef_Integral_1,u, (1-v-w)) - subs(Indef_Integral_1,u, 0);

% next, integrate with respect to v, from 0 to (1-w)
Indef_Integral_2  = int(Integrand_with_dvdw,v);
Integrand_with_dw = subs(Indef_Integral_2,v, (1-w)) - subs(Indef_Integral_2,v, 0);

% finally, integrate with respect to w, from 0 to 1
Indef_Integral_3 = int(Integrand_with_dw,w);
% evaluate definite integral
Integral_Value = subs(Indef_Integral_3,w, 1) - subs(Indef_Integral_3,w, 0);

end