function MATS = MatAssem_Subset_2D()
%MatAssem_Subset_2D

% Copyright (c) 05-07-2019,  Shawn W. Walker

% define domain (2-D)
Omega = Domain('triangle');

% define finite element spaces
Vh = Element(Omega,lagrange_deg1_dim2);

% define functions on FEM spaces
v  = Test(Vh);
u  = Trial(Vh);

% define geometric function on 'Sigma' domain
gf = GeoFunc(Omega);

% define FEM matrices
Mass_Matrix = Bilinear(Vh,Vh);
Mass_Matrix = Mass_Matrix + Integral(Omega, v.val * u.val);

Stiff_Matrix = Bilinear(Vh,Vh);
Stiff_Matrix = Stiff_Matrix + Integral(Omega, v.grad' * u.grad);

RHS = Linear(Vh);
RHS = RHS + Integral(Omega, gf.X(2) * v.val);

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 3;
% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(RHS);

end