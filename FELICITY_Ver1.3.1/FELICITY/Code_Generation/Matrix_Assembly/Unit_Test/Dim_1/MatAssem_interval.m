function MATS = MatAssem_interval()
%MatAssem_interval

% Copyright (c) 03-20-2018,  Shawn W. Walker

% define domain (1-D curve embedded in 3-D)
Sigma = Domain('interval',3);

% define finite element spaces
Scalar_P2    = Element(Sigma,lagrange_deg2_dim1,1);
Vector_P1    = Element(Sigma,lagrange_deg1_dim1,3);

% define functions on FEM spaces
v  = Test(Scalar_P2);
vv = Test(Vector_P1);
u  = Trial(Scalar_P2);
uu = Trial(Vector_P1);

my_f     = Coef(Vector_P1);
old_soln = Coef(Scalar_P2);

% define some constants
C1 = pi;
C2 = exp(C1);

% define geometric function on 'Sigma' domain
gf = GeoFunc(Sigma);

% define FEM matrices
Mass_Matrix = Bilinear(Scalar_P2,Scalar_P2);
Mass_Matrix = Mass_Matrix + Integral(Sigma,v.val * u.val);

Stiff_Matrix = Bilinear(Scalar_P2,Scalar_P2);
Stiff_Matrix = Stiff_Matrix + Integral(Sigma,v.ds * u.ds);

Body_Force_Matrix = Linear(Scalar_P2);
if verLessThan('matlab', '9.3')
    fooF = sym('foo(F)');
    foo_eval = subs(fooF,'F', C1 * gf.X(3) );
else
    syms F;
    fooF = str2sym('foo(F)');
    foo_eval = subs(fooF, F, C1 * gf.X(3) );
end
Body_Force_Matrix = Body_Force_Matrix + Integral(Sigma,v.val * foo_eval);

Vector_Mass_Matrix = Bilinear(Vector_P1,Vector_P1);
Vector_Mass_Matrix = Vector_Mass_Matrix + Integral(Sigma,vv.val' * uu.val);

Weighted_Mass_Matrix = Bilinear(Scalar_P2,Scalar_P2);
Weighted_Mass_Matrix = Weighted_Mass_Matrix + Integral(Sigma,my_f.ds(1) * v.val * u.val);

Tangent_Matrix = Linear(Vector_P1);
Tangent_Matrix = Tangent_Matrix + Integral(Sigma,vv.val' * gf.T);

Curv_Matrix = Linear(Scalar_P2);
Curv_Matrix = Curv_Matrix + Integral(Sigma,v.val * gf.Kappa);

Small_Matrix = Real(2,2);
Small_Matrix(1,1) = Small_Matrix(1,1) + Integral(Sigma, (exp(gf.X(1)) - old_soln.val)^2 ); % L2-Norm Squared Error
Small_Matrix(1,2) = Small_Matrix(1,2) + Integral(Sigma, old_soln.ds ); % verify the fundamental theorem of calculus
Small_Matrix(2,1) = Small_Matrix(2,1) + Integral(Sigma, my_f.ds(1) );  % verify the fundamental theorem of calculus

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 16;
% define geometry representation - Domain, reference element
G1 = GeoElement(Sigma,lagrange_deg2_dim1);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% include the definition of "foo" (see "Body_Force_Matrix")
MATS = MATS.Include_C_Code('my_foo_code.c');

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(Body_Force_Matrix);
MATS = MATS.Append_Matrix(Vector_Mass_Matrix);
MATS = MATS.Append_Matrix(Weighted_Mass_Matrix);
MATS = MATS.Append_Matrix(Tangent_Matrix);
MATS = MATS.Append_Matrix(Curv_Matrix);
MATS = MATS.Append_Matrix(Small_Matrix);

end