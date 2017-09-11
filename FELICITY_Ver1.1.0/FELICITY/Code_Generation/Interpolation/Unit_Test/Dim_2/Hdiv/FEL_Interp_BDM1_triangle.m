function INTERP = FEL_Interp_BDM1_triangle()
%FEL_Interp_BDM1_triangle

% Copyright (c) 02-08-2013,  Shawn W. Walker

% define domain
Omega = Domain('triangle');
Gamma = Domain('interval') < Omega;

% define finite element spaces
BDM1 = Element(Omega,brezzi_douglas_marini_deg1_dim2,1);

% define functions on FE spaces
v = Coef(BDM1);

% define geometric function on 'Gamma' domain
gf = GeoFunc(Gamma);

% define expressions to interpolate
I_v = Interpolate(Omega,v.val);

% define expressions to interpolate
I_on_Gamma = Interpolate(Gamma,v.val' * gf.N);

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G1);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_v);
INTERP = INTERP.Append_Interpolation(I_on_Gamma);

end