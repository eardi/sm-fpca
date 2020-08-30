function MATS = MatAssem_Hessian_Ex_TD_1_GD_3()
%MatAssem_Hessian_Ex_TD_1_GD_3

% Copyright (c) 08-13-2014,  Shawn W. Walker

% define domain (1-D curve embedded in 3-D)
Sigma = Domain('interval',3);

% define finite element spaces
Scalar_P2 = Element(Sigma,lagrange_deg2_dim1,1);
Vector_P2 = Element(Sigma,lagrange_deg2_dim1,3);

% define functions on FEM spaces
v  = Test(Scalar_P2);
vv = Test(Vector_P2);
u  = Trial(Scalar_P2);
uu = Trial(Vector_P2);

Sca = Coef(Scalar_P2);
Vec = Coef(Vector_P2);

% define FEM matrices
dsds_Matrix = Bilinear(Scalar_P2,Scalar_P2);
dsds_Matrix = dsds_Matrix + Integral(Sigma, v.dsds * u.dsds);

Vector_Hess_Matrix = Bilinear(Vector_P2,Vector_P2);
HESS_PROD = vv.hess .* uu.hess;
Vector_Hess_Matrix = Vector_Hess_Matrix + Integral(Sigma, sum(HESS_PROD(:)));

Small_Matrix = Real(2,1);
Small_Matrix(1,1) = Small_Matrix(1,1) + Integral(Sigma, Sca.hess(1,1) + Sca.hess(2,2) + Sca.hess(3,3) );    % verify the fundamental theorem of calculus
Small_Matrix(2,1) = Small_Matrix(2,1) + Integral(Sigma, Vec.dsds(2) ); % verify the fundamental theorem of calculus

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 8;
% define geometry representation - Domain, reference element
G1 = GeoElement(Sigma,lagrange_deg2_dim1);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(dsds_Matrix);
MATS = MATS.Append_Matrix(Vector_Hess_Matrix);
MATS = MATS.Append_Matrix(Small_Matrix);

end