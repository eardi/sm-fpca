function MATS = MatAssem_Nedelec1stKind_Deg1_triangle()
%MatAssem_Nedelec1stKind_Deg1_triangle

% Copyright (c) 10-19-2016,  Shawn W. Walker

% define domain
Omega   = Domain('triangle');
%d_Omega = Domain('interval') < Omega;

% define finite element spaces
Ned1 = Element(Omega,nedelec_1stkind_deg1_dim2,1);
P1   = Element(Omega,lagrange_deg1_dim2,1); % piecewise linear

% define functions on FEM spaces
vv = Test(Ned1);
uu = Trial(Ned1);
%q  = Test(P1);
p  = Trial(P1);

u_soln = Coef(Ned1);
u_old  = Coef(Ned1);

% define geometric function on \Omega
gf = GeoFunc(Omega);

% define FEM matrices
Mass_Matrix = Bilinear(Ned1,Ned1);
Mass_Matrix = Mass_Matrix + Integral(Omega, vv.val' * uu.val);

% curl constraint
Curl_Matrix = Bilinear(Ned1,P1);
Curl_Matrix = Curl_Matrix + Integral(Omega, vv.curl * p.val);

% curl-curl
CurlCurl_Matrix = Bilinear(Ned1,Ned1);
CurlCurl_Matrix = CurlCurl_Matrix + Integral(Omega, vv.curl' * uu.curl);

% RHS of L^2 projection
Ned1_Proj_Mat_1 = Bilinear(Ned1,P1);
Ned1_Proj_Mat_1 = Ned1_Proj_Mat_1 + Integral(Omega, vv.val(1) * p.val);
Ned1_Proj_Mat_2 = Bilinear(Ned1,P1);
Ned1_Proj_Mat_2 = Ned1_Proj_Mat_2 + Integral(Omega, vv.val(2) * p.val);

% RHS of curl-curl equation
RHS_CC = Linear(Ned1);
RHS_CC = RHS_CC + Integral(Omega, ( vv.val(1) * sin(pi*gf.X(1)) ) + ( vv.val(2) * sin(pi*gf.X(2)) ) );

Small_Matrix = Real(1,1);
Small_Matrix = Small_Matrix + Integral(Omega, u_old.curl );

L2_Error_Sq = Real(1,1);
L2_Error_Sq = L2_Error_Sq + Integral(Omega, ( u_soln.val(1) - sin(pi*gf.X(1)) )^2 + ( u_soln.val(2) - sin(pi*gf.X(2)) )^2 );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 7;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Curl_Matrix);
MATS = MATS.Append_Matrix(CurlCurl_Matrix);
MATS = MATS.Append_Matrix(Ned1_Proj_Mat_1);
MATS = MATS.Append_Matrix(Ned1_Proj_Mat_2);
MATS = MATS.Append_Matrix(RHS_CC);
MATS = MATS.Append_Matrix(Small_Matrix);
MATS = MATS.Append_Matrix(L2_Error_Sq);

end