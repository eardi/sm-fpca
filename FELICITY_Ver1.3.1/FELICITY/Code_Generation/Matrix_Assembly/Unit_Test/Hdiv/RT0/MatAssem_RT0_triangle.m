function MATS = MatAssem_RT0_triangle()
%MatAssem_RT0_triangle

% Copyright (c) 06-25-2012,  Shawn W. Walker

% define domain
Omega = Domain('triangle');

% define finite element spaces
P0  = Element(Omega,lagrange_deg0_dim2,1); % piecewise constants
RT0 = Element(Omega,raviart_thomas_deg0_dim2,1);

% define functions on FEM spaces
vv = Test(RT0);
uu = Trial(RT0);
q  = Test(P0);
p  = Trial(P0);

old_vel = Coef(RT0);
old_p   = Coef(P0);

% define geometric function on \Omega
gf = GeoFunc(Omega);

% define FEM matrices
Mass_Matrix = Bilinear(RT0,RT0);
Mass_Matrix = Mass_Matrix + Integral(Omega,vv.val' * uu.val);

% divergence constraint
Div_Matrix = Bilinear(RT0,P0);
Div_Matrix = Div_Matrix + Integral(Omega,vv.div * p.val);

% RHS for divergence
RHS_Div = Linear(P0);
RHS_Div = RHS_Div + Integral(Omega,q.val * (2*pi^2)*sin(pi*gf.X(1))*sin(pi*gf.X(2)));

Small_Matrix = Real(1,1);
Small_Matrix = Small_Matrix + Integral(Omega, old_vel.div );

L2_Error_Sq = Real(1,1);
L2_Error_Sq = L2_Error_Sq + Integral(Omega, (old_p.val - sin(pi*gf.X(1))*sin(pi*gf.X(2)))^2 );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 5;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Div_Matrix);
MATS = MATS.Append_Matrix(RHS_Div);
MATS = MATS.Append_Matrix(Small_Matrix);
MATS = MATS.Append_Matrix(L2_Error_Sq);

end