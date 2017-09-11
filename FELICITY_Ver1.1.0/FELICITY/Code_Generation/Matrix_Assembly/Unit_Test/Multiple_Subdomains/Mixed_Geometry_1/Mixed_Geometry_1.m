function MATS = Mixed_Geometry_1()
%Mixed_Geometry_1

% Copyright (c) 01-24-2014,  Shawn W. Walker

% define domains (one embedded in the other)
Gamma   = Domain('triangle',3);
Sigma   = Domain('interval') < Gamma;

% define finite element (FE) spaces
V_Space = Element(Sigma, lagrange_deg1_dim1,3);

% define functions on FE spaces
uu = Trial(V_Space);
vv = Test(V_Space);

% define geometric function on 'Gamma' subdomain
gGamma = GeoFunc(Gamma);
% % define geometric function on 'Sigma' subdomain
% gSigma = GeoFunc(Sigma);

% define FEM matrices
Mass_Matrix = Bilinear(V_Space,V_Space);
I1 = Integral(Sigma, vv.val' * uu.val);
Mass_Matrix = Mass_Matrix + I1;

Chi = Linear(V_Space);
I1  = Integral(Sigma, vv.val' * gGamma.N);
Chi = Chi.Add_Integral(I1);

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 6;

% define geometry representation - Domain, reference element
G1 = GeoElement(Gamma);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Chi);
MATS = MATS.Append_Matrix(Mass_Matrix);

end