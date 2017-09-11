function MATS = MatAssem_Hessian_Ex_TD_2_GD_3()
%MatAssem_Hessian_Ex_TD_2_GD_3

% Copyright (c) 08-14-2014,  Shawn W. Walker

% define domain (2-D surface embedded in 3-D)
Gamma = Domain('triangle',3);

% define finite element spaces
Vector_P2 = Element(Gamma,lagrange_deg2_dim2,3);

% define functions on FEM spaces
vv = Test(Vector_P2);
uu = Trial(Vector_P2);

Vec = Coef(Vector_P2);

% define FEM matrices
Vector_Hess_Matrix = Bilinear(Vector_P2,Vector_P2);
HESS_PROD = vv.hess .* uu.hess;
Vector_Hess_Matrix = Vector_Hess_Matrix + Integral(Gamma, sum(HESS_PROD(:)));

Small_Matrix = Real(1,1);
% compute trace of hessian of 1st component
H = Vec.hess;
Small_Matrix(1,1) = Small_Matrix(1,1) + Integral(Gamma, H(1,1,1) + H(2,2,1) + H(3,3,1) ); % verify the fundamental theorem of calculus

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 8;
% define geometry representation - Domain, reference element
G1 = GeoElement(Gamma,lagrange_deg2_dim2);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Small_Matrix);
MATS = MATS.Append_Matrix(Vector_Hess_Matrix);

end