function MATS = MatAssem_Curved_Domain_2D()
%MatAssem_Curved_Domain_2D

% Copyright (c) 04-14-2017,  Shawn W. Walker

% define domain (in the x-y plane)
Omega = Domain('triangle');
Gamma = Domain('interval') < Omega; % subset

% define finite element spaces
V_h = Element(Omega, lagrange_deg2_dim2); % piecewise quadratic

% define functions in FE spaces
v_h = Test(V_h);
u_h = Trial(V_h);

% geometric function
gf = GeoFunc(Gamma);

% define (discrete) forms
M = Bilinear(V_h,V_h);
M = M + Integral(Omega, v_h.val * u_h.val );

M_Gamma = Bilinear(V_h,V_h);
M_Gamma = M_Gamma + Integral(Gamma, v_h.val * u_h.val );

B_neu = Linear(V_h);
B_neu = B_neu + Integral(Gamma, v_h.grad' * gf.N );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;
% define how \Omega is represented: with piecewise quadratics
G1 = GeoElement(Omega,lagrange_deg2_dim2);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(B_neu);
MATS = MATS.Append_Matrix(M);
MATS = MATS.Append_Matrix(M_Gamma);

end