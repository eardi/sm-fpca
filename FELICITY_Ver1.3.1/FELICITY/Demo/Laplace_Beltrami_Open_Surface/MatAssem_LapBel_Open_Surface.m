function MATS = MatAssem_LapBel_Open_Surface()
%MatAssem_LapBel_Open_Surface

% Copyright (c) 11-07-2017,  Shawn W. Walker

% define domain (2-D surface in 3-D)
Gamma  = Domain('triangle',3);
dGamma = Domain('interval') < Gamma; % subset

% define finite element spaces
V_h = Element(Gamma, lagrange_deg2_dim2); % piecewise quadratic
W_h = Element(dGamma,lagrange_deg1_dim1); % piecewise linear

% define functions in FE spaces
v_h = Test(V_h);
u_h = Trial(V_h);
mu_h = Test(W_h);

% define (discrete) forms
M = Bilinear(V_h,V_h);
M = M + Integral(Gamma, v_h.val * u_h.val );

K = Bilinear(V_h,V_h);
K = K + Integral(Gamma, v_h.grad' * u_h.grad );

B = Bilinear(W_h,V_h);
B = B + Integral(dGamma, mu_h.val * u_h.val );

% set the minimum number of quadrature points to use
Quadrature_Order = 10;
% define geometry representation - Domain, piecewise quadratic representation
G_Space = GeoElement(Gamma,lagrange_deg2_dim2);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(B);
MATS = MATS.Append_Matrix(K);
MATS = MATS.Append_Matrix(M);

end