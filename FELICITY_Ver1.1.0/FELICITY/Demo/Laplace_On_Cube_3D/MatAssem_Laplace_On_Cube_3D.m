function MATS = MatAssem_Laplace_On_Cube_3D()
%MatAssem_Laplace_On_Cube_3D

% Copyright (c) 06-30-2012,  Shawn W. Walker

% define domain (3-D volume)
Omega = Domain('tetrahedron');

% define finite element spaces
P1_Space = Element(Omega,lagrange_deg1_dim3,1);

% define functions on FE spaces
v = Test(P1_Space);
u = Trial(P1_Space);

% define FEM matrices
% Mass_Matrix = Bilinear(P1_Space,P1_Space);
% Mass_Matrix = Mass_Matrix + Integral(Omega, v.val * u.val );

Stiff_Matrix = Bilinear(P1_Space,P1_Space);
Stiff_Matrix = Stiff_Matrix + Integral(Omega, v.grad' * u.grad );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 1;
% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
%MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);

end