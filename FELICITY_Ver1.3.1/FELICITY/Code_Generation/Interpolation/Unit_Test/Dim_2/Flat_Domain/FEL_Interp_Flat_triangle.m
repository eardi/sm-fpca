function INTERP = FEL_Interp_Flat_triangle()
%FEL_Interp_Flat_triangle

% Copyright (c) 01-25-2013,  Shawn W. Walker

% define domain (flat)
Omega = Domain('triangle');

% define finite element spaces
Scalar_P2  = Element(Omega,lagrange_deg2_dim2,1);
Vector_P1  = Element(Omega,lagrange_deg1_dim2,2);

% define functions on FE spaces
v = Coef(Vector_P1);
p = Coef(Scalar_P2);

% define geometric function on 'Omega' domain
gf = GeoFunc(Omega);

% define expressions to interpolate
I_v = Interpolate(Omega,v.grad);

% define expressions to interpolate
I_p = Interpolate(Omega,p.grad' * gf.X);

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G_Space);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_v);
INTERP = INTERP.Append_Interpolation(I_p);

end