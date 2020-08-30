function MATS = Refined_Square_Codim_1()
%Refined_Square_Codim_1

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domains (one embedded in the other)
Omega = Domain('triangle'); % there can only be ONE Global domain
Gamma = Domain('interval') < Omega;

% define finite element spaces
E_Space      = Element(Gamma,lagrange_deg1_dim1,1);
M_Space      = Element(Gamma,lagrange_deg2_dim1,1);
U_Space      = Element(Omega,lagrange_deg1_dim2,1);

% define functions on FEM spaces
v = Test(U_Space);

theta  = Test(E_Space);
mu     = Test(M_Space);
lambda = Trial(M_Space);

old_soln = Coef(U_Space);

% define FEM matrices
Mass_Matrix = Bilinear(U_Space,M_Space);
Mass_Matrix = Mass_Matrix + Integral(Gamma, (v.val * lambda.val) );

Bdy_Mass = Bilinear(E_Space,M_Space);
Bdy_Mass = Bdy_Mass + Integral(Gamma, (theta.val * lambda.val) );

Bdy_Vec = Linear(M_Space);
Bdy_Vec = Bdy_Vec + Integral(Gamma, old_soln.grad(2) * mu.ds );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 16;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Bdy_Mass);
MATS = MATS.Append_Matrix(Bdy_Vec);

end