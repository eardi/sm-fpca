function MATS = MatAssem_RT1_tetrahedron()
%MatAssem_RT1_tetrahedron

% Copyright (c) 10-17-2016,  Shawn W. Walker

% define domain
Omega = Domain('tetrahedron');

% define finite element spaces
P1  = Element(Omega,lagrange_deg1_dim3,1); % piecewise linear
RT1 = Element(Omega,raviart_thomas_deg1_dim3,1);

% define functions on FEM spaces
vv = Test(RT1);
uu = Trial(RT1);
q  = Test(P1);
p  = Trial(P1);

old_vel = Coef(RT1);
old_p   = Coef(P1);

% define geometric function on \Omega
gf = GeoFunc(Omega);

% define FEM matrices
Mass_Matrix = Bilinear(RT1,RT1);
Mass_Matrix = Mass_Matrix + Integral(Omega, vv.val' * uu.val);

% divergence constraint
Div_Matrix = Bilinear(RT1,P1);
Div_Matrix = Div_Matrix + Integral(Omega, vv.div * p.val);

% RHS of L^2 projection
RT1_Proj_Mat_1 = Bilinear(RT1,P1);
RT1_Proj_Mat_1 = RT1_Proj_Mat_1 + Integral(Omega, vv.val(1) * p.val);
RT1_Proj_Mat_2 = Bilinear(RT1,P1);
RT1_Proj_Mat_2 = RT1_Proj_Mat_2 + Integral(Omega, vv.val(2) * p.val);
RT1_Proj_Mat_3 = Bilinear(RT1,P1);
RT1_Proj_Mat_3 = RT1_Proj_Mat_3 + Integral(Omega, vv.val(3) * p.val);

% RHS for divergence
RHS_Div = Linear(P1);
RHS_Div = RHS_Div + Integral(Omega, q.val * (3*pi^2)*sin(pi*gf.X(1))*sin(pi*gf.X(2))*sin(pi*gf.X(3)) );

Small_Matrix = Real(1,1);
Small_Matrix = Small_Matrix + Integral(Omega, old_vel.div );

L2_Error_Sq = Real(1,1);
L2_Error_Sq = L2_Error_Sq + Integral(Omega, ( old_p.val - sin(pi*gf.X(1))*sin(pi*gf.X(2))*sin(pi*gf.X(3)) )^2 );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 7;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Div_Matrix);
MATS = MATS.Append_Matrix(RT1_Proj_Mat_1);
MATS = MATS.Append_Matrix(RT1_Proj_Mat_2);
MATS = MATS.Append_Matrix(RT1_Proj_Mat_3);
MATS = MATS.Append_Matrix(RHS_Div);
MATS = MATS.Append_Matrix(Small_Matrix);
MATS = MATS.Append_Matrix(L2_Error_Sq);

end