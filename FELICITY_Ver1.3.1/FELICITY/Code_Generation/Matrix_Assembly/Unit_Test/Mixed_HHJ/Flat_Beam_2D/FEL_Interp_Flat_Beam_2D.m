function INTERP = FEL_Interp_Flat_Beam_2D(deg_geo,deg_k)
%FEL_Interp_Flat_Beam_2D

% Copyright (c) 03-30-2018,  Shawn W. Walker

% define domain
Omega = Domain('triangle');

% define finite element spaces
% P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
% W_h = Element(Omega,P_k_plus_1); % piecewise linear
HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
V_h = Element(Omega,HHJ_k);

% define functions on FE spaces
sig = Coef(V_h);

% % define geometric function on 'Gamma' domain
% gf = GeoFunc(Gamma);

% define expressions to interpolate
I_sig = Interpolate(Omega, sig.val);

% % define expressions to interpolate
% I_on_Gamma = Interpolate(Gamma,v.val' * gf.N);

% define geometry representation - Domain, reference element
deg_surf_str = num2str(deg_geo);
Pk_Omega = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
G_Space = GeoElement(Omega,Pk_Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G_Space);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_sig);
%INTERP = INTERP.Append_Interpolation(I_on_Gamma);

end