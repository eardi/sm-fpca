function MATS = MatAssem_Mesh_Size_interval()
%MatAssem_Mesh_Size_interval

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domain (1-D curve embedded in 2-D)
Sigma = Domain('interval',2);

% define finite element spaces
Scalar_P0    = Element(Sigma,lagrange_deg0_dim1,1);

% define functions on FEM spaces
v  = Test(Scalar_P0);
u  = Trial(Scalar_P0);

% define geometric function on 'Sigma' domain
gf = GeoFunc(Sigma);

% define FEM matrices
Mass_Matrix = Bilinear(Scalar_P0,Scalar_P0);
Mass_Matrix = Mass_Matrix + Integral(Sigma,v.val * u.val);

RHS = Linear(Scalar_P0);
RHS = RHS + Integral(Sigma,gf.Mesh_Size * v.val);

Small_Matrix = Real(1,1);
Small_Matrix = Small_Matrix + Integral(Sigma, gf.Mesh_Size ); % integrate the mesh size

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 1;
% define geometry representation - Domain, reference element
G1 = GeoElement(Sigma);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(RHS);
MATS = MATS.Append_Matrix(Small_Matrix);

end