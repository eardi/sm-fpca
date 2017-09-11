function INTERP = FEL_Interp_Mixed_Geometry_2D()
%FEL_Interp_Mixed_Geometry_2D

% Copyright (c) 01-25-2014,  Shawn W. Walker

% define domains (one embedded in the other)
Gamma   = Domain('triangle',3);
Sigma   = Domain('interval') < Gamma;

% define finite element (FE) spaces
V_Space = Element(Sigma, lagrange_deg2_dim1,3);

% define functions on FE spaces
NN = Coef(V_Space);

% define geometric function on 'Gamma' subdomain
gGamma = GeoFunc(Gamma);
% define geometric function on 'Sigma' subdomain
gSigma = GeoFunc(Sigma);

% define expressions to interpolate
I_N        = Interpolate(Sigma, gGamma.N);
I_N_dot_NN = Interpolate(Sigma, gGamma.N' * NN.val);
I_N_dot_T  = Interpolate(Sigma, gGamma.N' * gSigma.T);

% define geometry representation - Domain, reference element
G1 = GeoElement(Gamma);

% define a set of interpolations to perform
INTERP = Interpolations(G1);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_N);
INTERP = INTERP.Append_Interpolation(I_N_dot_NN);
INTERP = INTERP.Append_Interpolation(I_N_dot_T);

end