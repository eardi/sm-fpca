function MATS = Multiple_Subdomain_Embed_Dim_1()
%Multiple_Subdomain_Embed_Dim_1

% Copyright (c) 06-26-2012,  Shawn W. Walker

% define domains (one embedded in the other)
Global  = Domain('interval'); % one GLOBAL domain
Omega   = Domain('interval') < Global;
Omega_1 = Domain('interval') < Omega;
Omega_2 = Domain('interval') < Omega;

% define finite element spaces
U_Space  = Element(Omega, lagrange_deg1_dim1,1);
M_Space  = Element(Omega_1, lagrange_deg1_dim1,1);

% define functions on FE spaces
v = Test(U_Space);
u = Trial(U_Space);

mu     = Test(M_Space);
lambda = Trial(M_Space);

% define FEM matrices
Stiff_Matrix = Bilinear(U_Space,U_Space);
% variable coefficient
I1 = Integral(Omega_1, (v.grad * u.grad));
Stiff_Matrix = Stiff_Matrix + I1;
Stiff_Matrix = Stiff_Matrix + Integral(Omega_2, 10*(v.grad * u.grad));

Mixed = Bilinear(U_Space,M_Space);
Mixed = Mixed + Integral(Omega_1, (v.val * lambda.val));

RHS = Linear(U_Space);
I1 = Integral(Omega, -v.val);
RHS = RHS.Add_Integral(I1);

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 3;

% define geometry representation - Domain, reference element
G1 = GeoElement(Global);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(Mixed);
MATS = MATS.Append_Matrix(RHS);

end