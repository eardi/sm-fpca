function MATS = Compute_Errors_LapBel_Open_Surface()
%Compute_Errors_LapBel_Open_Surface

% Copyright (c) 11-07-2017,  Shawn W. Walker

% define domain (2-D surface in 3-D)
Gamma = Domain('triangle',3);
dGamma = Domain('interval') < Gamma; % subset

% define finite element spaces
V_h = Element(Gamma, lagrange_deg2_dim2,1); % piecewise quadratic
W_h = Element(dGamma,lagrange_deg1_dim1,1); % piecewise linear
G_h = Element(Gamma, lagrange_deg2_dim2,3); % vector piecewise quadratic

% define functions in FE spaces
u_h = Coef(V_h);
lambda_h = Coef(W_h);

NV_h = Coef(G_h);
TV_h = Coef(G_h);

% geometry access functions
gf_Gamma = GeoFunc(Gamma);
gf_dGamma = GeoFunc(dGamma);

% define exact solns
u_exact = @(u,v) cos(v.*pi.*2.0).*sin(u.*pi.*2.0);
lambda_exact = @(u,v)pi.*1.0./sqrt(u.^2+v.^2+1.0).*1.0./sqrt(u.^2.*v.^2.*4.0+u.^2+v.^2).*(v.*sin(u.*pi.*2.0).*sin(v.*pi.*2.0)-u.*cos(u.*pi.*2.0).*cos(v.*pi.*2.0)-u.*v.^2.*cos(u.*pi.*2.0).*cos(v.*pi.*2.0).*2.0+u.^2.*v.*sin(u.*pi.*2.0).*sin(v.*pi.*2.0).*2.0).*2.0;

% define (discrete) forms
u_L2_Error_sq = Real(1,1);
u_L2_Error_sq = u_L2_Error_sq + Integral(Gamma, (u_h.val - u_exact(gf_Gamma.X(1),gf_Gamma.X(2)))^2 );

lambda_L2_Error_sq = Real(1,1);
lambda_L2_Error_sq = lambda_L2_Error_sq + Integral(dGamma, (lambda_h.val - lambda_exact(gf_dGamma.X(1),gf_dGamma.X(2)))^2 );

% check normal vector
NV_Error_sq = Real(1,1);
NV_Error_sq = NV_Error_sq + Integral(dGamma, sum((gf_Gamma.N - NV_h.val).^2) );

% check tangent vector
TV_Error_sq = Real(1,1);
TV_Error_sq = TV_Error_sq + Integral(dGamma, sum((gf_dGamma.T - TV_h.val).^2) );

% check Neumann data
xi_h = cross(gf_dGamma.T,gf_Gamma.N);
Neumann_L2_Error_sq = Real(1,1);
Neumann_L2_Error_sq = Neumann_L2_Error_sq + Integral(dGamma, ( lambda_h.val - ( -dot(xi_h,u_h.grad) ) )^2 );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;
% define geometry representation - Domain, piecewise quadratic representation
G_Space = GeoElement(Gamma,lagrange_deg2_dim2);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(u_L2_Error_sq);
MATS = MATS.Append_Matrix(lambda_L2_Error_sq);
MATS = MATS.Append_Matrix(NV_Error_sq);
MATS = MATS.Append_Matrix(TV_Error_sq);
MATS = MATS.Append_Matrix(Neumann_L2_Error_sq);

end