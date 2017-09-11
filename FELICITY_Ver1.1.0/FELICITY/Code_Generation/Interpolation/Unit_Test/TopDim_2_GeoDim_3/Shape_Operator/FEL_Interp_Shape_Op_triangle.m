function INTERP = FEL_Interp_Shape_Op_triangle()
%FEL_Interp_Shape_Op_triangle

% Copyright (c) 08-15-2014,  Shawn W. Walker

% define domain (embedded in 3-D)
Gamma = Domain('triangle',3);

% % define finite element spaces
% Scalar_P2  = Element(Omega,lagrange_deg2_dim2,1);
% Vector_P1  = Element(Omega,lagrange_deg1_dim2,2);
% 
% % define functions on FE spaces
% v = Coef(Vector_P1);
% p = Coef(Scalar_P2);

% define geometric function on 'Gamma' domain
gf = GeoFunc(Gamma);

% define expressions to interpolate
I_kappa        = Interpolate(Gamma, gf.Kappa);
I_kappa_gauss  = Interpolate(Gamma, gf.Kappa_Gauss);
I_normal       = Interpolate(Gamma, gf.N);
I_shape        = Interpolate(Gamma, gf.Shape_Op);

% define geometry representation - Domain, reference element
G1 = GeoElement(Gamma,lagrange_deg2_dim2);

% define a set of interpolations to perform
INTERP = Interpolations(G1);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_kappa);
INTERP = INTERP.Append_Interpolation(I_kappa_gauss);
INTERP = INTERP.Append_Interpolation(I_normal);
INTERP = INTERP.Append_Interpolation(I_shape);

end