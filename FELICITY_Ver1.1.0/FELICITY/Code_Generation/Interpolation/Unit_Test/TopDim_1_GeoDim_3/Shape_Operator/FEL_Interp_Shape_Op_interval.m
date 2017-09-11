function INTERP = FEL_Interp_Shape_Op_interval()
%FEL_Interp_Shape_Op_interval

% Copyright (c) 08-17-2014,  Shawn W. Walker

% define domain (embedded in 3-D)
Sigma = Domain('interval',3);

% % define finite element spaces
% Scalar_P2  = Element(Omega,lagrange_deg2_dim2,1);
% Vector_P1  = Element(Omega,lagrange_deg1_dim2,2);
% 
% % define functions on FE spaces
% v = Coef(Vector_P1);
% p = Coef(Scalar_P2);

% define geometric function on 'Gamma' domain
gf = GeoFunc(Sigma);

% define expressions to interpolate
I_kappa        = Interpolate(Sigma, gf.Kappa);
I_tangent      = Interpolate(Sigma, gf.T);
I_shape        = Interpolate(Sigma, gf.Shape_Op);

% define geometry representation - Domain, reference element
G1 = GeoElement(Sigma,lagrange_deg2_dim1);

% define a set of interpolations to perform
INTERP = Interpolations(G1);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_kappa);
INTERP = INTERP.Append_Interpolation(I_tangent);
INTERP = INTERP.Append_Interpolation(I_shape);

end