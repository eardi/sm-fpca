function MATS = MatAssem_Mesh_Gen_With_Solving_PDE()
%MatAssem_Mesh_Gen_With_Solving_PDE

% Copyright (c) 04-24-2013,  Shawn W. Walker

% define domain (2-D)
Omega = Domain('triangle');
Gamma = Domain('interval') < Omega;
% there will be other boundaries also, but they are not needed here.

% define finite element spaces
P1_Space = Element(Omega,lagrange_deg1_dim2,1);

% define functions on FE spaces
v = Test(P1_Space);
u = Trial(P1_Space);

% define geometric function on \Gamma
gf = GeoFunc(Gamma);

% define FEM matrices
Stiff_Matrix = Bilinear(P1_Space,P1_Space);
Stiff_Matrix = Stiff_Matrix + Integral(Omega, v.grad' * u.grad );

Neumann_Matrix = Linear(P1_Space);
Neumann_Matrix = Neumann_Matrix + Integral(Gamma, 2*cos(pi*(gf.X(1) + gf.X(2))) * v.val );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 5;
% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(Neumann_Matrix);

end