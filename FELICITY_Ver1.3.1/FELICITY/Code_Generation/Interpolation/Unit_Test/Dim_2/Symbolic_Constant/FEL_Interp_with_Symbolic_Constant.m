function INTERP = FEL_Interp_with_Symbolic_Constant()
%FEL_Interp_with_Symbolic_Constant

% Copyright (c) 01-20-2018,  Shawn W. Walker

% define domain (flat)
Omega = Domain('triangle');

% define finite element spaces
Scalar_P2 = Element(Omega,lagrange_deg2_dim2);

% define functions on FE spaces
f = Coef(Scalar_P2);

% define a "global constant" 2x1 vector
c0 = Constant(Omega,2);

% define expressions to interpolate
I_f = Interpolate(Omega, f.grad' * c0.val);

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G_Space);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_f);

end