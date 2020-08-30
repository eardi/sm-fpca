function MATS = MatAssem_Nedelec1stKind_Deg2_tetrahedron()
%MatAssem_Nedelec1stKind_Deg2_tetrahedron

% Copyright (c) 10-19-2016,  Shawn W. Walker

% define domain
Omega   = Domain('tetrahedron');
%d_Omega = Domain('triangle') < Omega;

% define finite element spaces
Ned2 = Element(Omega,nedelec_1stkind_deg2_dim3,1);
P1   = Element(Omega,lagrange_deg1_dim3,1); % piecewise linear

% define functions on FEM spaces
vv = Test(Ned2);
uu = Trial(Ned2);
%q  = Test(P1);
p  = Trial(P1);

u_soln = Coef(Ned2);
u_old  = Coef(Ned2);

% define geometric function on \Omega
gf = GeoFunc(Omega);

% define FEM matrices
Mass_Matrix = Bilinear(Ned2,Ned2);
Mass_Matrix = Mass_Matrix + Integral(Omega, vv.val' * uu.val);

% curl constraint
Curl_Matrix = Bilinear(Ned2,P1);
Curl_Matrix = Curl_Matrix + Integral(Omega, sum(vv.curl) * p.val);

% curl-curl
CurlCurl_Matrix = Bilinear(Ned2,Ned2);
CurlCurl_Matrix = CurlCurl_Matrix + Integral(Omega, vv.curl' * uu.curl);

% RHS of L^2 projection
Ned2_Proj_Mat_1 = Linear(Ned2);
Ned2_Proj_Mat_1 = Ned2_Proj_Mat_1 + Integral(Omega, vv.val' * [-gf.X(2); gf.X(3); gf.X(1)] );
Ned2_Proj_Mat_2 = Linear(Ned2);
Ned2_Proj_Mat_2 = Ned2_Proj_Mat_2 + Integral(Omega, vv.val' * [exp(-gf.X(2)); gf.X(1)^2; gf.X(3)^3] );
Ned2_Proj_Mat_3 = Linear(Ned2);
Ned2_Proj_Mat_3 = Ned2_Proj_Mat_3 + Integral(Omega, vv.val' * [sin(pi*gf.X(1)); sin(pi*gf.X(2)); sin(pi*gf.X(3))] );

% RHS of curl-curl equation
RHS_CC = Linear(Ned2);
RHS_CC = RHS_CC + Integral(Omega, ( vv.val(1) * sin(pi*gf.X(1)) ) + ( vv.val(2) * sin(pi*gf.X(2)) ) + ( vv.val(3) * sin(pi*gf.X(3)) ) );

Small_Matrix = Real(1,1);
Small_Matrix = Small_Matrix + Integral(Omega, sum(u_old.curl) );

L2_Error_Sq = Real(1,1);
L2_Error_Sq = L2_Error_Sq + Integral(Omega, ( u_soln.val(1) - sin(pi*gf.X(1)) )^2 + ( u_soln.val(2) - sin(pi*gf.X(2)) )^2 + ( u_soln.val(3) - sin(pi*gf.X(3)) )^2 );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;

% define geometry representation - Domain, reference element
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Curl_Matrix);
MATS = MATS.Append_Matrix(CurlCurl_Matrix);
MATS = MATS.Append_Matrix(Ned2_Proj_Mat_1);
MATS = MATS.Append_Matrix(Ned2_Proj_Mat_2);
MATS = MATS.Append_Matrix(Ned2_Proj_Mat_3);
MATS = MATS.Append_Matrix(RHS_CC);
MATS = MATS.Append_Matrix(Small_Matrix);
MATS = MATS.Append_Matrix(L2_Error_Sq);

end