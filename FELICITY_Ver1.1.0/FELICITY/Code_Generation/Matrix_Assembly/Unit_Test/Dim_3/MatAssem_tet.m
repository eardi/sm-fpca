function MATS = MatAssem_tet()
%MatAssem_tet

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domain (3-D volume)
Omega = Domain('tetrahedron');

% define finite element spaces
Scalar_P1    = Element(Omega,lagrange_deg1_dim3,1);
Vector_P1    = Element(Omega,lagrange_deg1_dim3,3);

% define functions on FEM spaces
v  = Test(Scalar_P1);
vv = Test(Vector_P1);
u  = Trial(Scalar_P1);
uu = Trial(Vector_P1);

my_f     = Coef(Vector_P1);
old_soln = Coef(Scalar_P1);

% define geometric function on 'Omega' domain
gf = GeoFunc(Omega);

% define FEM matrices
Mass_Matrix = Bilinear(Scalar_P1,Scalar_P1);
Mass_Matrix = Mass_Matrix + Integral(Omega,v.val * u.val);

Stiff_Matrix = Bilinear(Scalar_P1,Scalar_P1);
Stiff_Matrix = Stiff_Matrix + Integral(Omega,v.grad' * u.grad);

Body_Force_Matrix = Linear(Scalar_P1);
Body_Force_Matrix = Body_Force_Matrix + Integral(Omega,v.val * sin(gf.X(1)) * cos(gf.X(2)) * sin(gf.X(3)));

Vector_Mass_Matrix = Bilinear(Vector_P1,Vector_P1);
Vector_Mass_Matrix = Vector_Mass_Matrix + Integral(Omega,vv.val' * uu.val);

Weighted_Mass_Matrix = Bilinear(Scalar_P1,Scalar_P1);
Weighted_Mass_Matrix = Weighted_Mass_Matrix + Integral(Omega, my_f.grad(2,2) * my_f.val(1) * v.val * u.val );

L2_Norm_Sq_Error = Real(1,1);
L2_Norm_Sq_Error = L2_Norm_Sq_Error + Integral(Omega, (exp(gf.X(1)) - old_soln.val)^2 ); % L2-Norm Squared Error

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 20;

% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(Body_Force_Matrix);
MATS = MATS.Append_Matrix(Vector_Mass_Matrix);
MATS = MATS.Append_Matrix(Weighted_Mass_Matrix);
MATS = MATS.Append_Matrix(L2_Norm_Sq_Error);

end