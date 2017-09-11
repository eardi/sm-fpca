function Q = FEL_Compute_Exact_Solution_Hessian_Ex_3D()
%FEL_Compute_Exact_Solution_Hessian_Ex_3D
%
%   Compute exact solution to test FELICITY Auto-Generated Assembly Code.

% Copyright (c) 08-15-2014,  Shawn W. Walker

f1 = sym('exp(x)*y*sin(2*z) - 1');
f2 = sym('y*exp(-x)*cos(3*z)');

hess_f1 = hessian(f1);
hess_f2 = hessian(f2);
 
Int1 = sum(sum(hess_f1.^2));
Int2 = sum(sum(hess_f2.^2));
 
Big_Int = simplify(Int1 + Int2);
integrand_FH = matlabFunction(Big_Int);
%integrand_FH
Other_Int = simplify(trace(hess_f2));
integrand_FH = matlabFunction(Other_Int);
integrand_FH

XMIN = 0;
XMAX = 1;
YMIN = 0;
YMAX = 1;
ZMIN = 0;
ZMAX = 1;
Q = integral3(integrand_FH,XMIN,XMAX,YMIN,YMAX,ZMIN,ZMAX,'AbsTol',1e-15);

end