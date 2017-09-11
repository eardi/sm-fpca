function MATS = MatAssem_Hessian_Ex_3D()
%MatAssem_Hessian_Ex_3D

% Copyright (c) 08-14-2014,  Shawn W. Walker

% define domain (3-D)
Omega = Domain('tetrahedron');

% define finite element spaces
Vector_P2 = Element(Omega,lagrange_deg2_dim3,3);

% define functions on FEM spaces
vv = Test(Vector_P2);
uu = Trial(Vector_P2);

Vec = Coef(Vector_P2);

% define FEM matrices
Vector_Hess_Matrix = Bilinear(Vector_P2,Vector_P2);
HESS_PROD = vv.hess .* uu.hess;
Vector_Hess_Matrix = Vector_Hess_Matrix + Integral(Omega, sum(HESS_PROD(:)));

Small_Matrix = Real(1,1);
% compute trace of hessian of 2nd component
H = Vec.hess;
Small_Matrix(1,1) = Small_Matrix(1,1) + Integral(Omega, H(1,1,2) + H(2,2,2) + H(3,3,2) ); % verify the fundamental theorem of calculus

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;
% define geometry representation - Domain, reference element
G1 = GeoElement(Omega,lagrange_deg1_dim3);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Small_Matrix);
MATS = MATS.Append_Matrix(Vector_Hess_Matrix);

end