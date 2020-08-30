function MATS = MatAssem_Simple_Elasticity_3D()
%MatAssem_Simple_Elasticity_3D

% Copyright (c) 06-30-2012,  Shawn W. Walker

% define domain (3-D volume)
Omega = Domain('tetrahedron'); % ``elastic'' domain
Sigma = Domain('interval') < Omega; % edge of \Omega

% define finite element spaces
Vector_P1 = Element(Omega,lagrange_deg1_dim3,3); % 3-D vector valued

% define functions on FE spaces
vv = Test(Vector_P1);
uu = Trial(Vector_P1);

Displace = Coef(Vector_P1);

% define geometric function on \Sigma
gSigma = GeoFunc(Sigma);

% define FEM matrices
Mass_Matrix = Bilinear(Vector_P1,Vector_P1);
Mass_Matrix = Mass_Matrix + Integral(Omega,vv.val' * uu.val);

Stiff_Matrix = Bilinear(Vector_P1,Vector_P1);
Stiff_Matrix = Stiff_Matrix + Integral(Omega,sum(sum(vv.grad .* uu.grad)));

Eval_Matrix = Real(1,1);
Eval_Matrix = Eval_Matrix + Integral(Sigma, Displace.val' * gSigma.T );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 3;
% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Eval_Matrix);
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);

end