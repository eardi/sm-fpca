function MATS = MatAssem_Laplace_1D()
%MatAssem_Laplace_1D

% Copyright (c) 06-30-2012,  Shawn W. Walker

% define domain (1-D)
Omega = Domain('interval');

% define finite element spaces
Scalar_P1    = Element(Omega,lagrange_deg1_dim1,1);

% define functions on FE space
v  = Test(Scalar_P1);
u  = Trial(Scalar_P1);

% define FE matrices
Mass_Matrix = Bilinear(Scalar_P1,Scalar_P1);
I1 = Integral(Omega,v.val * u.val);
Mass_Matrix = Mass_Matrix.Add_Integral(I1);

Stiff_Matrix = Bilinear(Scalar_P1,Scalar_P1);
I2 = Integral(Omega,v.grad' * u.grad);
Stiff_Matrix = Stiff_Matrix + I2;

RHS = Linear(Scalar_P1);
RHS = RHS + Integral(Omega,-1.0 * v.val);

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;
% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(RHS);

end