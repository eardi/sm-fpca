function MATS = MatAssem_Stokes_2D()
%MatAssem_Stokes_2D

% Copyright (c) 06-30-2012,  Shawn W. Walker

% define domain (2-D)
Omega = Domain('triangle'); % fluid domain (unit square)
%Inlet = Domain('interval') < Omega; % left side of \Omega
Outlet = Domain('interval') < Omega; % right side of \Omega

% define finite element spaces
Vector_P2 = Element(Omega,lagrange_deg2_dim2,2); % 2-D vector valued
Scalar_P1 = Element(Omega,lagrange_deg1_dim2,1);

% define functions on FE spaces
vv = Test(Vector_P2);
uu = Trial(Vector_P2);

q = Test(Scalar_P1);
p = Trial(Scalar_P1);

BC_Out = Coef(Vector_P2);

% define FEM matrices
BC_Matrix = Linear(Vector_P2);
BC_Matrix = BC_Matrix + Integral(Outlet, BC_Out.val' * vv.val );

Div_Pressure = Bilinear(Scalar_P1,Vector_P2);
Div_Pressure = Div_Pressure + Integral(Omega,-q.val * (uu.grad(1,1) + uu.grad(2,2)));

Stress_Matrix = Bilinear(Vector_P2,Vector_P2);
% symmetrized gradient
D_u = uu.grad + uu.grad';
Stress_Matrix = Stress_Matrix + Integral(Omega,sum(sum(D_u .* vv.grad)));

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 4;
% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(BC_Matrix);
MATS = MATS.Append_Matrix(Div_Pressure);
MATS = MATS.Append_Matrix(Stress_Matrix);

end