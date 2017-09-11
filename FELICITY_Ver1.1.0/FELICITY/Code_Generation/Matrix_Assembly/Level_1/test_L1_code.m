% test_L1_code
% unofficial test code
clc;
clear all classes;

Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;

C0 = Element(Sigma);
W1 = Element(Omega,lagrange_deg1_dim2,1);
V1 = Element(Sigma,lagrange_deg1_dim1,2);

w = Test(W1,Sigma); % need to restrict this function!

v = Test(V1);
u = Trial(V1);
f = Coef(V1);

gf = GeoFunc(Sigma);

% v.val
% u.val
% f.val
% 
% v.grad
% u.grad
% f.grad
% 
% v.ds
% u.ds
% f.ds

% gf.X
% gf.Tangent_Space_Proj
% gf.deriv_X
% gf.T
% gf.N
% gf.VecKappa
% gf.Kappa
% gf.Kappa_Gauss
% gf.
% gf.
% gf.
% gf.

% FEM matrices
Mass_Matrix = Bilinear(V1,V1);
I1 = Integral(Sigma,f.val(1) * v.val' * u.val,u,f,v);
Mass_Matrix = Mass_Matrix.Add_Integral(I1);

Stiff_Matrix = Bilinear(V1,V1);
I2 = Integral(Sigma,sum(sum(v.grad .* u.grad)),u,v);
Stiff_Matrix = Stiff_Matrix.Add_Integral(I2);

RHS_Matrix = Linear(V1);
I3 = Integral(Sigma,v.val' * [1; 1],v);
RHS_Matrix = RHS_Matrix.Add_Integral(I3);

Bdy_Matrix = Bilinear(W1,V1);
I4 = Integral(Sigma,sum(u.grad * w.grad),u,w);
Bdy_Matrix = Bdy_Matrix.Add_Integral(I4);

Small_Matrix = Real(2,2);
ffoo = sym('foo(F)');
ffoo = subs(ffoo,'F',f.val);
I5 = Integral(Sigma,ffoo(2) * gf.X(2),f);
Small_Matrix = Small_Matrix.Add_Integral(1,1,I5);

Quadrature_Order = 10;
G1 = GeoElement(Omega,lagrange_deg1_dim2);
MATS = Matrices(Quadrature_Order,G1); % include C code!!!
% this has the definition of "foo" (see "Body_Force_Matrix")
MATS = MATS.Include_C_Code('my_foo_code.c');

MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(RHS_Matrix);
MATS = MATS.Append_Matrix(Bdy_Matrix);
MATS = MATS.Append_Matrix(Small_Matrix);

CONVERT = L1toL3(MATS);
Main_Dir = 'C:\TEMP\CODES\';
Snippet_Dir = 'C:\TEMP\CODES\';
[FS, FM, C_Codes] = CONVERT.Run_Conversion(Main_Dir,Snippet_Dir);

FS
FM



% END %