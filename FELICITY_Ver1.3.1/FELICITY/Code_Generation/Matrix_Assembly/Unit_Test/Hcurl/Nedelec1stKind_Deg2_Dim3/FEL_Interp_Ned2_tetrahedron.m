function INTERP = FEL_Interp_Ned2_tetrahedron()
%FEL_Interp_Ned2_tetrahedron

% Copyright (c) 10-19-2016,  Shawn W. Walker

% define domain
Omega = Domain('tetrahedron');

% define finite element spaces
Ned2 = Element(Omega,nedelec_1stkind_deg2_dim3,1);

% define functions on FE spaces
v = Coef(Ned2);

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