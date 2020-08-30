function Integral_Value = integrate_on_edge(Integrand,Xmap,global_vars,u)
%integrate_on_edge
%
%   This integrates over an edge (1-D manifold).
%
%   Note: the reference domain is the unit interval: [0, 1].

% Copyright (c) 09-27-2016,  Shawn W. Walker

% differential (arc-length) measure
dP = diff(Xmap,u);
ds = sqrt(dot(dP,dP));

% plug in parameterization
Integrand = subs(Integrand,global_vars,Xmap);
Integrand_with_ds = Integrand * ds;

% integrate to get anti-derivative
Indef_Integral = int(Integrand_with_ds,u);
% evaluate definite integral
Integral_Value = subs(Indef_Integral,u,1) - subs(Indef_Integral,u,0);

end