function MATS = Multiple_Subdomain_Embed_Dim_3()
%Multiple_Subdomain_Embed_Dim_3

% Copyright (c) 06-26-2012,  Shawn W. Walker

% define domains (one embedded in the other)
Global  = Domain('tetrahedron'); % one GLOBAL domain
Omega   = Domain('tetrahedron') < Global;
Omega_1 = Domain('tetrahedron') < Omega;
Omega_2 = Domain('tetrahedron') < Omega;
Gamma   = Domain('triangle') < Omega;
Sigma   = Domain('interval') < Gamma;

% define finite element spaces
U_Space  = Element(Omega, lagrange_deg1_dim3,1);
M_Space  = Element(Gamma, lagrange_deg1_dim2,1);
E_Space  = Element(Sigma, lagrange_deg1_dim1,1);

% define functions on FEM spaces
v = Test(U_Space);
u = Trial(U_Space);

q = Test(M_Space);
p = Trial(M_Space);

mu     = Test(E_Space);
lambda = Trial(E_Space);

old_soln = Coef(U_Space);

% define geometric function on 'Gamma' subdomain
gGamma = GeoFunc(Gamma);

% define FEM matrices
Stiff_Matrix = Bilinear(U_Space,U_Space);
I1 = Integral(Omega, (v.grad' * u.grad));
Stiff_Matrix = Stiff_Matrix + I1;

Weight_Mass = Bilinear(U_Space,U_Space);
I1 = Integral(Omega_1, 1.0*(v.val * u.val));
Weight_Mass = Weight_Mass + I1;
Weight_Mass = Weight_Mass + Integral(Omega_2, 2.0*(v.val * u.val));

Bdy_Mixed = Bilinear(U_Space,M_Space);
I1 = Integral(Gamma, v.grad' * p.grad);
Bdy_Mixed = Bdy_Mixed.Add_Integral(I1);

Edge_Mixed = Bilinear(M_Space,E_Space);
I1 = Integral(Sigma, q.grad' * lambda.grad);
Edge_Mixed = Edge_Mixed.Add_Integral(I1);

C1 = Real(1,1);
C1 = C1 + Integral(Sigma, old_soln.val);

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 6;

% define geometry representation - Domain, reference element
G1 = GeoElement(Global);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Bdy_Mixed);
MATS = MATS.Append_Matrix(C1);
MATS = MATS.Append_Matrix(Edge_Mixed);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(Weight_Mass);

end