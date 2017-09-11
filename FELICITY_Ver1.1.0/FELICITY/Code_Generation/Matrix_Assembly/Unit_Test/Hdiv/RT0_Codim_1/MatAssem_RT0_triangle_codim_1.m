function MATS = MatAssem_RT0_triangle_codim_1()
%MatAssem_RT0_triangle_codim_1

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domains (one embedded in the other)
Omega = Domain('triangle'); % there can only be ONE Global domain
Boundary = Domain('interval') < Omega;

% define finite element spaces
P0  = Element(Boundary,lagrange_deg0_dim1,1); % piecewise constants
RT0 = Element(Omega,raviart_thomas_deg0_dim2,1);

% define functions on FEM spaces
vv = Test(RT0);
uu = Trial(RT0);
q  = Test(P0);
p  = Trial(P0);

% define geometric function on Boundary
gf = GeoFunc(Boundary);

% RHS for divergence
NV_Constraint = Bilinear(P0,RT0);
NV_Constraint = NV_Constraint + Integral(Boundary,q.val * (uu.val' * gf.N));

% define FEM matrices
NV_Matrix = Bilinear(RT0,RT0);
NV_Matrix = NV_Matrix + Integral(Boundary,(vv.val' * gf.N)*(uu.val' * gf.N));

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 5;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(NV_Constraint);
MATS = MATS.Append_Matrix(NV_Matrix);

end