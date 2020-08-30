function INTERP = FEL_Interp_Ned1_triangle()
%FEL_Interp_Ned1_triangle

% Copyright (c) 10-19-2016,  Shawn W. Walker

% define domain
Omega = Domain('triangle');

% define finite element spaces
Ned1 = Element(Omega,nedelec_1stkind_deg1_dim2,1);

% define functions on FE spaces
v = Coef(Ned1);

% % define geometric function on 'Gamma' domain
% gf = GeoFunc(Gamma);

% define expressions to interpolate
I_v = Interpolate(Omega, v.val);

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G1);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_v);

end