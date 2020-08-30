function MATS = MatAssem_Symbolic_Constants()
%MatAssem_Symbolic_Constants

% Copyright (c) 01-18-2018,  Shawn W. Walker

% define domain
Omega = Domain('triangle');

% define finite element (FE) spaces
Vector_P1 = Element(Omega,lagrange_deg1_dim2,2);

% define a "global constant" space
Const_Space = Element(Omega,constant_one,2);

% define functions on FE spaces
v = Test(Vector_P1);
u = Trial(Vector_P1);

u0 = Coef(Vector_P1);
c0 = Constant(Omega,2);
%c0 = Coef(Const_Space); % alternative way to define a constant

a = Test(Const_Space);
b = Trial(Const_Space);

% define FE forms
Simple_Form = Bilinear(Const_Space,Const_Space);
Simple_Form = Simple_Form + Integral(Omega, a.val' * b.val * (c0.grad(1,1) + c0.val(1)) );

% make sure linear forms still work
Lin_A = Linear(Vector_P1);
Lin_A = Lin_A + Integral(Omega, v.val(1) );

Lin_B = Linear(Const_Space);
Lin_B = Lin_B + Integral(Omega, a.val(1) );

% make sure we can mix the constant space with others
Mixed_Form_A = Bilinear(Vector_P1,Const_Space);
Mixed_Form_A = Mixed_Form_A + Integral(Omega, v.val' * b.val );

Mixed_Form_B = Bilinear(Const_Space,Vector_P1);
Mixed_Form_B = Mixed_Form_B + Integral(Omega, a.val' * u.val );

% try out the Coef functionality
Elliptic_Form = Bilinear(Vector_P1,Vector_P1);
Elliptic_Form = Elliptic_Form + Integral(Omega, c0.val(1) * u0.val(1) * v.val' * u.val + c0.val(2) * sum(sum(v.grad .* u.grad)) );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 4;

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega,lagrange_deg1_dim2);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Simple_Form);
MATS = MATS.Append_Matrix(Lin_A);
MATS = MATS.Append_Matrix(Lin_B);
MATS = MATS.Append_Matrix(Mixed_Form_A);
MATS = MATS.Append_Matrix(Mixed_Form_B);
MATS = MATS.Append_Matrix(Elliptic_Form);

end