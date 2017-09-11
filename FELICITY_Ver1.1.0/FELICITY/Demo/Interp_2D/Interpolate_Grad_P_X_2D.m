function INTERP = Interpolate_Grad_P_X_2D()
%Interpolate_Grad_P_X_2D

% Copyright (c) 02-11-2013,  Shawn W. Walker

% define domain
Omega = Domain('triangle');

% define finite element spaces
Scalar_P2  = Element(Omega,lagrange_deg2_dim2,1);

% define functions on FE spaces
p = Coef(Scalar_P2);

% define geometric function on 'Omega' domain
gf = GeoFunc(Omega);

% define expressions to interpolate
I_grad_p_X = Interpolate(Omega,p.grad' * gf.X);

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G1);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_grad_p_X);

end