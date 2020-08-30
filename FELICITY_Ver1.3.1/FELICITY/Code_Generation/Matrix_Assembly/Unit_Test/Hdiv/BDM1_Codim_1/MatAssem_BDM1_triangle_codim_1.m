function MATS = MatAssem_BDM1_triangle_codim_1()
%MatAssem_BDM1_triangle_codim_1

% Copyright (c) 05-21-2013,  Shawn W. Walker

% define domain
Box    = Domain('triangle');
Omega  = Domain('triangle') < Box;
Gamma  = Domain('interval') < Box;

% define finite element spaces
BDM1 = Element(Omega,brezzi_douglas_marini_deg1_dim2,1);

% define functions on FEM spaces
%uu = Trial(BDM1);
vv = Test(BDM1);

% define geometric function on \Gamma
gf_Gam  = GeoFunc(Gamma);

NV = Linear(BDM1);
NV = NV + Integral(Gamma, vv.val' * gf_Gam.N );

% Quadrature order
Quadrature_Order = 6;

% Geometry of Omega (piecewise linear)
G1 = GeoElement(Box);

% set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(NV);

end