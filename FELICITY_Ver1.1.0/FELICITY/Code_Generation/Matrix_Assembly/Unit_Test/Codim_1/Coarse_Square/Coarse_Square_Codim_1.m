function MATS = Coarse_Square_Codim_1()
%Coarse_Square_Codim_1

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domains (one embedded in the other)
Omega = Domain('triangle'); % there can only be ONE Global domain
Gamma = Domain('interval') < Omega;

% define finite element spaces
U_Space      = Element(Omega,lagrange_deg1_dim2,1);
M_Space      = Element(Gamma,lagrange_deg2_dim1,1);
Vector_P1    = Element(Gamma,lagrange_deg1_dim1,2);

% define functions on FEM spaces
v = Test(U_Space);
u = Trial(U_Space);

mu     = Test(M_Space);
lambda = Trial(M_Space);

vv = Test(Vector_P1);
uu = Trial(Vector_P1);

old_soln = Coef(U_Space);

% define some constants
inv_root_2 = 1/sqrt(2);

% define geometric function on 'Gamma' subdomain
gf = GeoFunc(Gamma);

% define FEM matrices
Mass_Matrix = Bilinear(M_Space,M_Space);
Mass_Matrix = Mass_Matrix + Integral(Gamma, (mu.val * lambda.val) );

Bdy_Mass = Bilinear(U_Space,M_Space);
Bdy_Mass = Bdy_Mass + Integral(Gamma, (v.val * lambda.val) );

Bdy_Vec = Linear(M_Space);
Bdy_Vec = Bdy_Vec + Integral(Gamma, old_soln.grad(1) * mu.ds );

Vec_Stiffness_Matrix = Bilinear(Vector_P1,Vector_P1);
Vec_Stiffness_Matrix = Vec_Stiffness_Matrix + Integral(Gamma, vv.ds' * uu.ds );

Small_Matrix = Real(2,2);
Small_Matrix(1,1) = Small_Matrix(1,1) + Integral(Gamma, gf.X(1) );
Small_Matrix(2,1) = Small_Matrix(2,1) + Integral(Gamma, sin(gf.X(1)) );
Small_Matrix(1,2) = Small_Matrix(1,2) + Integral(Gamma, inv_root_2 * (gf.N(1) + gf.N(2)) );
Small_Matrix(2,2) = Small_Matrix(2,2) + Integral(Gamma, gf.T' * gf.N );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Bdy_Mass);
MATS = MATS.Append_Matrix(Bdy_Vec);
MATS = MATS.Append_Matrix(Vec_Stiffness_Matrix);
MATS = MATS.Append_Matrix(Small_Matrix);

end