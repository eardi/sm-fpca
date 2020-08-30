function MATS = MatAssem_Mixed_Domains_Constants()
%MatAssem_Mixed_Domains_Constants

% Copyright (c) 01-22-2018,  Shawn W. Walker

% define domain
Omega = Domain('tetrahedron');
Gamma = Domain('triangle') < Omega;

% define a "global constant" space
Const_Space = Element(Omega,constant_one,3);

% Coefs
c0 = Constant(Omega,3);
%c0 = Coef(Const_Space); % alternative way to define a constant

a = Test(Const_Space);
b = Trial(Const_Space);

% define FE forms
Simple_Form = Bilinear(Const_Space,Const_Space);
Simple_Form = Simple_Form + Integral(Gamma, a.val' * b.val * (c0.grad(1,1) + c0.val(1)) );

% try out the Coef functionality
Eval_Const = Real(1,1);
Eval_Const = Eval_Const + Integral(Gamma, (c0.val(1) + c0.grad(1,1)) );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 4;

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega,lagrange_deg1_dim3);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Eval_Const);
MATS = MATS.Append_Matrix(Simple_Form);

end