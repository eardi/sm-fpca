function MATS = MatAssem_EWOD_FalkWalker()
%MatAssem_EWOD_FalkWalker

% Copyright (c) 11-07-2017,  Shawn W. Walker

% define domain (2-D domain with 1-D boundary)
Omega = Domain('triangle');
Gamma = Domain('interval') < Omega; % subset

% define finite element spaces
V_h = Element(Omega,brezzi_douglas_marini_deg1_dim2); % BDM_1
Q_h = Element(Omega,lagrange_deg0_dim2); % piecewise constant
M_h = Element(Gamma,lagrange_deg1_dim1); % piecewise linear
Y_h = Element(Gamma,lagrange_deg1_dim1,2); % vector-valued piecewise linear

% space that represents the geometry of the domain
G_h = Element(Omega,lagrange_deg1_dim2,2); % vector-valued piecewise linear

% define functions in FE spaces
u_h = Trial(V_h);
v_h = Test(V_h);
%p_h = Trial(Q_h);
q_h = Test(Q_h);
%lambda_h = Trial(M_h);
mu_h = Test(M_h);
x_h = Trial(Y_h);
y_h = Test(Y_h);

s_h = Trial(G_h);
r_h = Test(G_h);

% geometric functions
gf = GeoFunc(Gamma);

% define (discrete) forms
M = Bilinear(V_h,V_h);
M = M + Integral(Omega, v_h.val' * u_h.val );

K = Bilinear(Y_h,Y_h);
K = K + Integral(Gamma, sum(sum(x_h.grad .* y_h.grad)) );

B = Bilinear(Q_h,V_h);
B = B + Integral(Omega, q_h.val * u_h.div );

C = Bilinear(M_h,V_h);
C = C + Integral(Gamma, mu_h.val * (u_h.val' * gf.N) );

D = Bilinear(M_h,Y_h);
D = D + Integral(Gamma, mu_h.val * (x_h.val' * gf.N) );

chi = Linear(M_h);
chi = chi + Integral(Gamma, mu_h.val * (gf.X' * gf.N) );

A = Bilinear(G_h,G_h);
A = A + Integral(Omega, sum(sum(s_h.grad .* r_h.grad)) );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 5;
% define geometry representation (piecewise linear)
G_Space = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(M);
MATS = MATS.Append_Matrix(K);
MATS = MATS.Append_Matrix(B);
MATS = MATS.Append_Matrix(C);
MATS = MATS.Append_Matrix(D);
MATS = MATS.Append_Matrix(chi);
MATS = MATS.Append_Matrix(A);

end