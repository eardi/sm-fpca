function MATS = MatAssem_triangle()
%MatAssem_triangle

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domain (2-D surface embedded in 3-D)
Gamma = Domain('triangle',3);

% define finite element spaces
Scalar_P2    = Element(Gamma,lagrange_deg2_dim2,1);
Vector_P1    = Element(Gamma,lagrange_deg1_dim2,3);

% define functions on FEM spaces
v  = Test(Scalar_P2);
vv = Test(Vector_P1);
u  = Trial(Scalar_P2);
uu = Trial(Vector_P1);

old_soln = Coef(Scalar_P2);

% define geometric function on 'Gamma' domain
gf = GeoFunc(Gamma);

% define FEM matrices
Mass_Matrix = Bilinear(Scalar_P2,Scalar_P2);
Mass_Matrix = Mass_Matrix + Integral(Gamma,v.val * u.val);

% Laplace-Beltrami
Stiff_Matrix = Bilinear(Scalar_P2,Scalar_P2);
Stiff_Matrix = Stiff_Matrix + Integral(Gamma,v.grad' * u.grad);

Body_Force_Matrix = Linear(Scalar_P2);
Body_Force_Matrix = Body_Force_Matrix + Integral(Gamma,v.val * sin(gf.X(1)) * cos(gf.X(2)) * sin(gf.X(3)));

Vector_Mass_Matrix = Bilinear(Vector_P1,Vector_P1);
Vector_Mass_Matrix = Vector_Mass_Matrix + Integral(Gamma,vv.val' * uu.val);

Normal_Matrix = Linear(Vector_P1);
Normal_Matrix = Normal_Matrix + Integral(Gamma,vv.val' * gf.N);

Curv_Matrix = Linear(Scalar_P2);
Curv_Matrix = Curv_Matrix + Integral(Gamma,v.val * gf.Kappa);

Small_Matrix = Real(1,1);
Small_Matrix = Small_Matrix + Integral(Gamma, (exp(gf.X(1)) - old_soln.val)^2 ); % L2-Norm Squared Error

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 15;

% define geometry representation - Domain, reference element
G1 = GeoElement(Gamma,lagrange_deg2_dim2);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(Body_Force_Matrix);
MATS = MATS.Append_Matrix(Vector_Mass_Matrix);
MATS = MATS.Append_Matrix(Normal_Matrix);
MATS = MATS.Append_Matrix(Curv_Matrix);
MATS = MATS.Append_Matrix(Small_Matrix);

end