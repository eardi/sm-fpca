function MATS = Multiple_Subdomain_Embed_Dim_2()
%Multiple_Subdomain_Embed_Dim_2

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domains (one embedded in the other)
Global  = Domain('triangle'); % one GLOBAL domain
Omega   = Domain('triangle') < Global;
Omega_1 = Domain('triangle') < Omega;
Omega_2 = Domain('triangle') < Omega;
Gamma   = Domain('interval') < Omega_2;

% define finite element spaces
U_Space  = Element(Omega, lagrange_deg1_dim2,1);
V1_Space = Element(Omega_1,lagrange_deg1_dim2,1);
V2_Space = Element(Omega_2,lagrange_deg1_dim2,1);
M_Space  = Element(Gamma, lagrange_deg1_dim1,1);

% define functions on FEM spaces
v = Test(U_Space);
u = Trial(U_Space);

v1 = Test(V1_Space);
u1 = Trial(V1_Space);
v2 = Test(V2_Space);
u2 = Trial(V2_Space);

mu     = Test(M_Space);
lambda = Trial(M_Space);

old_soln = Coef(U_Space);

% define geometric function on 'Gamma' subdomain
gGamma = GeoFunc(Gamma);

% define FEM matrices
Mass_Matrix = Bilinear(M_Space,M_Space);
I1 = Integral(Gamma, (mu.val * lambda.val));
Mass_Matrix = Mass_Matrix + I1;

Bdy_1 = Bilinear(V1_Space,M_Space);
Bdy_1 = Bdy_1 + Integral(Gamma, (v1.val * lambda.val));

Bdy_2 = Bilinear(V2_Space,M_Space);
I1 = Integral(Gamma, (v2.val * lambda.val));
Bdy_2 = Bdy_2.Add_Integral(I1);

Bdy_Geo = Bilinear(U_Space,M_Space);
I1 = Integral(Gamma, old_soln.val * (v.grad' * gGamma.N) * lambda.ds);
Bdy_Geo = Bdy_Geo.Add_Integral(I1);

Bulk = Bilinear(U_Space,U_Space);
Bulk = Bulk + Integral(Omega, v.val * u.val);

RHS = Linear(U_Space);
I1 = Integral(Gamma, v.val);
RHS = RHS.Add_Integral(I1);

C1 = Real(2,1);
I1 = Integral(Gamma, old_soln.val);
C1(1,1) = C1(1,1) + I1;
C1(2,1) = C1(2,1) + Integral(Gamma, gGamma.X(2));

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 5;

% define geometry representation - Domain, reference element
G1 = GeoElement(Global);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Bdy_1);
MATS = MATS.Append_Matrix(Bdy_2);
MATS = MATS.Append_Matrix(Bdy_Geo);
MATS = MATS.Append_Matrix(Bulk);
MATS = MATS.Append_Matrix(C1);
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(RHS);

end